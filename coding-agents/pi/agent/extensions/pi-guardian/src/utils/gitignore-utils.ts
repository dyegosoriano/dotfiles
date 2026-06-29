import fs from "node:fs";
import path from "node:path";

import { normalizePath, stripShellQuotes } from "./path-utils.js";

export function readGitignorePatterns(params: { rootDir: string }): string[] {
  const gitignorePath = path.join(params.rootDir, ".gitignore");
  if (!fs.existsSync(gitignorePath)) return [];

  return fs
    .readFileSync(gitignorePath, "utf8")
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => line.length > 0 && !line.startsWith("#"));
}

export function normalizeGitignorePattern(params: { pattern: string }): string {
  const negated = params.pattern.startsWith("!");
  const rawPattern = negated ? params.pattern.slice(1) : params.pattern;
  const normalizedPattern = normalizePath(rawPattern).replace(/^\//, "");
  return negated ? `!${normalizedPattern}` : normalizedPattern;
}

export function isGitignoreNegationPattern(params: { pattern: string }): boolean {
  return params.pattern.trim().startsWith("!");
}

function pathRelativeToRoot(params: { targetPath: string; rootDir: string }): string {
  const slashPath = params.targetPath.replace(/\\/g, "/");
  const absolutePath = path.isAbsolute(slashPath) ? slashPath : path.resolve(params.rootDir, slashPath);
  const relativePath = path.relative(params.rootDir, absolutePath).replace(/\\/g, "/");
  return normalizePath(relativePath);
}

function wildcardToRegExp(pattern: string): RegExp {
  const escaped = pattern.replace(/[|\\{}()[\]^$+?.]/g, "\\$&").replace(/\*/g, "[^/]*");
  return new RegExp(`^${escaped}$`);
}

export function matchesGitignorePattern(params: { path: string; pattern: string; rootDir?: string }): boolean {
  const rootDir = params.rootDir ?? process.cwd();
  const normalizedPath = pathRelativeToRoot({ targetPath: params.path, rootDir });
  const normalizedPattern = normalizeGitignorePattern({ pattern: params.pattern }).replace(/^!/, "");
  const directoryPattern = params.pattern.replace(/^!/, "").endsWith("/");
  const patternWithoutSlash = normalizedPattern.replace(/\/$/, "");

  if (!patternWithoutSlash) return false;

  if (directoryPattern) {
    return normalizedPath === patternWithoutSlash || normalizedPath.startsWith(`${patternWithoutSlash}/`);
  }

  if (!patternWithoutSlash.includes("/")) {
    return normalizedPath
      .split("/")
      .some((segment, index, segments) => wildcardToRegExp(patternWithoutSlash).test(segment) || wildcardToRegExp(patternWithoutSlash).test(segments.slice(index).join("/")));
  }

  const matcher = wildcardToRegExp(patternWithoutSlash);
  return matcher.test(normalizedPath) || normalizedPath.startsWith(`${patternWithoutSlash}/`);
}

export function commandContainsGitignoredPath(params: { command: string; patterns: string[]; rootDir: string }): boolean {
  return params.command
    .split(/[\s;&|<>]+/)
    .map(stripShellQuotes)
    .filter(Boolean)
    .some((token) => {
      if (token.startsWith("-")) return false;
      let blocked = false;
      for (const pattern of params.patterns) {
        if (!matchesGitignorePattern({ path: token, pattern, rootDir: params.rootDir })) continue;
        blocked = !isGitignoreNegationPattern({ pattern });
      }
      return blocked;
    });
}
