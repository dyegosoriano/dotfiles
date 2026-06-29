import { normalizePath, stripShellQuotes } from "./path-utils.js";

export function allBlockedPaths(params: { blockedPathGroups: string[][] }): string[] {
  return params.blockedPathGroups.flat();
}

function normalizeForPathGuard(path: string): string {
  return normalizePath({ path });
}

function isInsideBlockedPath(path: string, blockedPath: string): boolean {
  const normalizedPath = normalizeForPathGuard(path);
  const normalizedBlockedPath = normalizeForPathGuard(blockedPath);

  if (normalizedPath === normalizedBlockedPath) return true;
  if (normalizedPath.startsWith(`${normalizedBlockedPath}/`)) return true;

  if (normalizedBlockedPath.startsWith("/")) {
    const relativeBlockedPath = normalizedBlockedPath.slice(1);
    return normalizedPath === relativeBlockedPath || normalizedPath.startsWith(`${relativeBlockedPath}/`);
  }

  return false;
}

export function pathContainsBlockedSegment(params: { path: string; blockedPaths: string[] }): boolean {
  return params.blockedPaths.some((blockedPath) => isInsideBlockedPath(params.path, blockedPath));
}

export function commandContainsBlockedPath(params: { command: string; blockedPaths: string[] }): boolean {
  return params.command
    .split(/[\s;&|<>]+/)
    .map(stripShellQuotes)
    .filter(Boolean)
    .some((token) => pathContainsBlockedSegment({ path: token, blockedPaths: params.blockedPaths }));
}
