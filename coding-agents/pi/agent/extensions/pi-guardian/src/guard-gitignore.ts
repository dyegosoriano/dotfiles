import { GitignoreGuardError } from "./errors/gitignore-guard-error.js";
import {
  commandContainsGitignoredPath,
  isGitignoreNegationPattern,
  matchesGitignorePattern,
  readGitignorePatterns,
} from "./utils/gitignore-utils.js";
import { isGuardianFeatureEnabled } from "./config.js";

export { GitignoreGuardError } from "./errors/gitignore-guard-error.js";

export type GitignoreGuardOperation = "read" | "write" | "edit" | "list" | "search" | "index" | "terminal";

export type GitignoreGuardResult = {
  allowed: boolean;
  hidden: boolean;
  message?: string;
};

function gitignoreDecision(params: { path: string; rootDir: string }): { blocked: boolean; allowedByException: boolean } {
  if (!isGuardianFeatureEnabled("gitignore")) return { blocked: false, allowedByException: false };
  const patterns = readGitignorePatterns({ rootDir: params.rootDir });
  let blocked = false;
  let allowedByException = false;

  for (const pattern of patterns) {
    if (!matchesGitignorePattern({ path: params.path, pattern, rootDir: params.rootDir })) continue;

    if (isGitignoreNegationPattern({ pattern })) {
      blocked = false;
      allowedByException = true;
    } else {
      blocked = true;
      allowedByException = false;
    }
  }

  return { blocked, allowedByException };
}

export function isBlockedByGitignore(params: { path: string; rootDir?: string }): boolean {
  return gitignoreDecision({ path: params.path, rootDir: params.rootDir ?? process.cwd() }).blocked;
}

export function isAllowedByGitignoreException(params: { path: string; rootDir?: string }): boolean {
  return gitignoreDecision({ path: params.path, rootDir: params.rootDir ?? process.cwd() }).allowedByException;
}

export function guardGitignoreAccess(params: {
  path: string;
  rootDir?: string;
  operation: GitignoreGuardOperation;
}): GitignoreGuardResult {
  const rootDir = params.rootDir ?? process.cwd();
  if (!isGuardianFeatureEnabled("gitignore")) return { allowed: true, hidden: false };
  const blocked =
    params.operation === "terminal"
      ? commandContainsGitignoredPath({ command: params.path, patterns: readGitignorePatterns({ rootDir }), rootDir })
      : isBlockedByGitignore({ path: params.path, rootDir });

  if (!blocked) return { allowed: true, hidden: false };

  if (params.operation === "read") {
    return {
      allowed: false,
      hidden: true,
      message: `The file "${params.path}" is ignored by .gitignore and its content was hidden by pi-guardian.`,
    };
  }

  throw new GitignoreGuardError({ path: params.path, operation: params.operation });
}

export function assertGitignoreAccessAllowed(params: { path: string; rootDir?: string; operation: GitignoreGuardOperation }): void {
  const result = guardGitignoreAccess(params);
  if (!result.allowed) throw new GitignoreGuardError({ path: params.path, operation: params.operation });
}
