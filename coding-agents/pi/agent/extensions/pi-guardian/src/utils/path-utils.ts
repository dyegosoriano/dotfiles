import { homedir } from "node:os";
import path from "node:path";

export function normalizePath(filePath: string): string;

export function normalizePath(params: { path: string }): string;

export function normalizePath(input: string | { path: string }): string {
  const rawPath = typeof input === "string" ? input : input.path;
  const slashNormalizedPath = rawPath.replace(/\\/g, "/");
  const pathWithExpandedHome = slashNormalizedPath.replace(/^~(?=\/|$)/, homedir().replace(/\\/g, "/"));
  const normalizedPath = path.posix.normalize(pathWithExpandedHome).replace(/^\.\//, "");

  if (normalizedPath === ".") return "";
  if (normalizedPath.length > 1 && normalizedPath.endsWith("/")) return normalizedPath.slice(0, -1);

  return normalizedPath;
}

export function stripShellQuotes(value: string): string {
  return value.trim().replace(/^[\'"]|[\'"]$/g, "");
}
