import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { dirname, normalize, relative, resolve } from "path";
import { execFileSync } from "child_process";
import { statSync } from "fs";

const BLOCKED_PATHS = ["credentials/**", "secrets/**", "vpn/**", ".dotfiles/**", ".gnupg/**", ".notes/**", ".azure/**", ".kube/**", ".ssh/**", ".aws/**", ".gcp/**"];
const BLOCKED_FILES = ["*.ovpn", "*.p12", "*.pem", "*.crt", "*.key", ".env*"]

const BLOQUED_ITEMS = [...BLOCKED_PATHS, ...BLOCKED_FILES]

function expandHome(value: string) {
  return value.startsWith("~") ? value.replace(/^~/, process.env.HOME ?? "") : value;
}

function normalizePath(value: string) {
  return normalize(value).replace(/\\/g, "/");
}

function toAbs(cwd: string, value: string) {
  return normalizePath(resolve(expandHome(cwd), expandHome(value)));
}

function escapeRegExp(value: string) {
  return value.replace(/[.+?^${}()|[\]\\]/g, "\\$&");
}

function globToRegExpSource(pattern: string) {
  const token = "__DOUBLE_STAR__";
  const normalized = pattern.replace(/\\/g, "/").replace(/\*\*/g, token);
  return escapeRegExp(normalized).replace(/\*/g, "[^/]*").replace(new RegExp(token, "g"), ".*");
}

function parseGitIgnorePattern(rawPattern: string) {
  let pattern = rawPattern.trim();

  if (!pattern || pattern.startsWith("#")) return undefined;

  if (pattern.startsWith("\\#")) pattern = pattern.slice(1);

  const negated = pattern.startsWith("!");
  if (negated) pattern = pattern.slice(1);

  const anchored = pattern.startsWith("/");
  if (anchored) pattern = pattern.slice(1);

  const directoryOnly = pattern.endsWith("/");
  pattern = pattern.replace(/\/+$/g, "");

  if (!pattern) return undefined;

  return { pattern, negated, anchored, directoryOnly };
}

function relativeCandidates(cwd: string, abs: string) {
  const bases = [cwd, process.env.HOME].filter(Boolean) as string[];
  const candidates = [abs];

  for (const base of bases) {
    const rel = normalizePath(relative(expandHome(base), abs));
    if (rel && !rel.startsWith("../") && rel !== "..") candidates.push(rel);
  }

  return [...new Set(candidates)];
}

function matchesGitIgnorePattern(cwd: string, abs: string, rawPattern: string) {
  const rule = parseGitIgnorePattern(rawPattern);
  if (!rule) return false;

  if (rawPattern.startsWith("/") || rawPattern.startsWith("~")) {
    const absolutePattern = toAbs(cwd, rawPattern.replace(/^!/, ""));
    const source = globToRegExpSource(absolutePattern);
    return new RegExp(rule.directoryOnly ? `^${source}(?:/.*)?$` : `^${source}$`).test(abs);
  }

  const source = globToRegExpSource(rule.pattern);
  const hasSlash = rule.pattern.includes("/");

  return relativeCandidates(cwd, abs).some((candidate) => {
    const regex = rule.anchored
      ? new RegExp(rule.directoryOnly ? `^${source}(?:/.*)?$` : `^${source}$`)
      : new RegExp(rule.directoryOnly || hasSlash ? `(?:^|/)${source}(?:/.*)?$` : `(?:^|/)${source}$`);

    return regex.test(candidate);
  });
}

function existingBaseDir(abs: string) {
  try {
    return statSync(abs).isDirectory() ? abs : dirname(abs);
  } catch {
    return dirname(abs);
  }
}

function gitRootFor(abs: string) {
  try {
    return execFileSync("git", ["-C", existingBaseDir(abs), "rev-parse", "--show-toplevel"], { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }).trim();
  } catch {
    return undefined;
  }
}

function isGitIgnored(abs: string) {
  const gitRoot = gitRootFor(abs);
  if (!gitRoot) return false;

  try {
    execFileSync("git", ["-C", gitRoot, "check-ignore", "-q", "--", abs], { stdio: "ignore" });
    return true;
  } catch {
    return false;
  }
}

function isBlockedPath(cwd: string, value: string) {
  const abs = toAbs(cwd, value);
  let blocked = isGitIgnored(abs);

  for (const rawPattern of BLOQUED_ITEMS) {
    const rule = parseGitIgnorePattern(rawPattern);
    if (!rule) continue;

    if (matchesGitIgnorePattern(cwd, abs, rawPattern)) {
      blocked = !rule.negated;
    }
  }

  return blocked;
}

function collectStrings(input: unknown): string[] {
  if (typeof input === "string") return [input];
  if (Array.isArray(input)) return input.flatMap(collectStrings);
  if (input && typeof input === "object") {
    return Object.values(input as Record<string, unknown>).flatMap(collectStrings);
  }
  return [];
}

function extractCommandCandidates(command: string) {
  return command.match(/[^\s"'`]+/g) ?? [];
}

function isBlockedCommand(cwd: string, command: string) {
  return extractCommandCandidates(command).some((candidate) => isBlockedPath(cwd, candidate));
}

export default function(pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    const toolName = event.toolName;
    const fileTools = new Set(["read", "write", "edit", "ls", "find", "grep"]);

    if (!fileTools.has(toolName) && toolName !== "bash") return undefined;

    if (toolName === "bash") {
      const command = typeof (event.input as { command?: unknown })?.command === "string"
        ? (event.input as { command: string }).command
        : "";

      if (!command || !isBlockedCommand(ctx.cwd, command)) return undefined;

      if (ctx.hasUI) ctx.ui.notify(`Comando bloqueado: ${command}`, "warning");
      return { reason: "Comando tenta acessar caminho protegido", block: true };
    }

    const matches = collectStrings(event.input).find((value) => isBlockedPath(ctx.cwd, value));

    if (!matches) return undefined;

    if (ctx.hasUI) ctx.ui.notify(`Acesso bloqueado: ${matches}`, "warning");
    return { reason: `Path protegido: ${matches}`, block: true };
  });
}
