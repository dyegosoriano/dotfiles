import { basename } from "node:path";

import { normalizePath } from "./path-utils.js";

export function escapeRegExp(value: string): string {
  return value.replace(/[|\\{}()[\]^$+?.]/g, "\\$&");
}

export function wildcardPatternToRegExp(pattern: string): RegExp {
  const source = pattern.split("*").map(escapeRegExp).join(".*");
  return new RegExp(`^${source}$`);
}

export function matchesPattern(filePath: string, pattern: string): boolean {
  const normalizedPath = normalizePath(filePath);
  const fileName = basename(normalizedPath);

  if (!pattern.includes("*")) return normalizedPath === pattern || fileName === pattern;

  const matcher = wildcardPatternToRegExp(normalizePath(pattern));

  return matcher.test(normalizedPath) || matcher.test(fileName);
}
