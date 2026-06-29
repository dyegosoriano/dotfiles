import { commandContainsBlockedPath } from "../utils/path-guard-utils.js";
import { PathGuardError } from "../errors/path-guard-error.js";
import { assertPathAccessAllowed } from "../guard-path.js";
import { assertGitignoreAccessAllowed } from "../guard-gitignore.js";

export type GuardOperation = "list" | "read" | "write" | "edit" | "process" | "execute" | "search" | "index" | "terminal";

export type FileGuardOperation = GuardOperation;

export function isListOperation(operation: GuardOperation): boolean {
  return operation === "list";
}

export function assertGuardOperationPathAllowed(params: { path: string; operation: GuardOperation; rootDir?: string }): void {
  assertPathAccessAllowed(params);
  const gitignoreOperation = params.operation === "execute" || params.operation === "process" ? "terminal" : params.operation;
  assertGitignoreAccessAllowed({ path: params.path, rootDir: params.rootDir, operation: gitignoreOperation });
}

export function assertGuardOperationCommandAllowed(params: { command: string; blockedPaths: string[]; operation?: string; rootDir?: string }): void {
  if (commandContainsBlockedPath({ command: params.command, blockedPaths: params.blockedPaths })) {
    throw new PathGuardError({ path: params.command, operation: params.operation ?? "execute" });
  }
  assertGitignoreAccessAllowed({ path: params.command, rootDir: params.rootDir, operation: "terminal" });
}
