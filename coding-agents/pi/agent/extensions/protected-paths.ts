import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { normalize, resolve, sep } from "path";

const BLOCKED_PATHS = [
  "credentials/**",
  "secrets/**",
  "vpn/**",

  ".dotfiles/**",
  ".gnupg/**",
  ".notes/**",
  ".azure/**",
  ".kube/**",
  ".ssh/**",
  ".aws/**",
  ".gcp/**",

  "*.ovpn",
  "*.p12",
  "*.pem",
  "*.crt",
  "*.key",
  ".env*",
];

function expandHome(value: string) {
  return value.startsWith("~") ? value.replace(/^~/, process.env.HOME ?? "") : value;
}

function toAbs(cwd: string, value: string) {
  return normalize(resolve(expandHome(cwd), expandHome(value)));
}

function escapeRegExp(value: string) {
  return value.replace(/[.+?^${}()|[\]\\]/g, "\\$&");
}

function globToRegExpSource(pattern: string) {
  const token = "__DOUBLE_STAR__";
  const normalized = pattern.replace(/\\/g, "/").replace(/\*\*/g, token);
  return escapeRegExp(normalized).replace(/\*/g, "[^/]*").replace(new RegExp(token, "g"), ".*");
}

function wildcardToRegExp(pattern: string, anchored = true) {
  const source = globToRegExpSource(pattern);
  return new RegExp(anchored ? `^${source}$` : source);
}

function resolvePatternCandidates(cwd: string, pattern: string) {
  if (pattern.startsWith("/") || pattern.startsWith("~")) {
    return [normalize(resolve(expandHome(pattern)))];
  }

  const local = normalize(resolve(cwd, pattern));
  const home = process.env.HOME ? normalize(resolve(process.env.HOME, pattern)) : undefined;

  return home && home !== local ? [local, home] : [local];
}

function matchesWildcardPattern(abs: string, pattern: string) {
  const normalizedAbs = abs.replace(/\\/g, "/");

  if (pattern.startsWith("/") || pattern.startsWith("~")) {
    return wildcardToRegExp(normalize(resolve(expandHome(pattern))).replace(/\\/g, "/"), true).test(normalizedAbs);
  }

  return new RegExp(`(?:^|.*/)${globToRegExpSource(pattern)}$`).test(normalizedAbs);
}

function isBlockedPath(cwd: string, value: string) {
  const abs = toAbs(cwd, value);

  return BLOCKED_PATHS.some((blocked) => {
    if (blocked.includes("*")) {
      return matchesWildcardPattern(abs, blocked);
    }

    return resolvePatternCandidates(cwd, blocked).some((blockedAbs) => {
      return abs === blockedAbs || abs.startsWith(blockedAbs + sep);
    });
  });
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
    const isFileTool = fileTools.has(toolName);

    if (!isFileTool && toolName !== "bash") return undefined;

    if (toolName === "bash") {
      const command = typeof (event.input as { command?: unknown })?.command === "string"
        ? (event.input as { command: string }).command
        : "";

      if (!command || !isBlockedCommand(ctx.cwd, command)) return undefined;

      if (ctx.hasUI) ctx.ui.notify(`Comando bloqueado: ${command}`, "warning");

      return { reason: "Comando tenta acessar caminho protegido", block: true };
    }

    const values = collectStrings(event.input);
    const matches = values.find((value) => isBlockedPath(ctx.cwd, value));

    if (!matches) return undefined;

    if (ctx.hasUI) ctx.ui.notify(`Acesso bloqueado: ${matches}`, "warning");

    return { reason: `Path protegido: ${matches}`, block: true };
  });
}
