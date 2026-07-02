import { isToolCallEventType } from "@earendil-works/pi-coding-agent";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

import { commandReadsFileContent, extractPotentialPathsFromCommand } from "./src/utils/bash-utils.js";
import { assertFileAccessAllowed, BLOQUED_FILES, FileGuardError, isBlockedFile } from "./src/guard-file.js";
import { assertPathAccessAllowed, BLOCKED_PATHS, isBlockedPath, PathGuardError } from "./src/guard-path.js";
import { assertGuardOperationCommandAllowed } from "./src/operations/guard-operations.js";
import { guardGitignoreAccess, GitignoreGuardError, type GitignoreGuardOperation } from "./src/guard-gitignore.js";
import { getBashCommand, getEditPaths, getPathInput } from "./src/utils/tool-inputs.js";
import { isGuardianFeatureEnabled } from "./src/config.js";
import { assertCommandExecutionAllowed, CommandGuardError } from "./src/guard-command.js";

export { ALLOWED_COMMANDS, BLOCKED_COMMANDS, BLOCKED_CREDENTIALS_PATHS, CONTENT_READING_COMMANDS, BLOCKED_CONFIGS_PATHS, BLOCKED_ROOT_PATHS, BLOQUED_FILES } from "./src/constants/guardian-constants.js";
export type { FileGuardOperation, GuardOperation } from "./src/operations/guard-operations.js";
export { matchesPattern, wildcardPatternToRegExp } from "./src/utils/pattern-matcher.js";
export { assertPathAccessAllowed, BLOCKED_PATHS, isBlockedPath } from "./src/guard-path.js";
export { assertFileAccessAllowed, isBlockedFile } from "./src/guard-file.js";
export { normalizePath, stripShellQuotes } from "./src/utils/path-utils.js";
export { FileGuardError } from "./src/errors/file-guard-error.js";
export { PathGuardError } from "./src/errors/path-guard-error.js";
export { GitignoreGuardError } from "./src/errors/gitignore-guard-error.js";
export type { GitignoreGuardOperation, GitignoreGuardResult } from "./src/guard-gitignore.js";
export { assertGitignoreAccessAllowed, guardGitignoreAccess, isAllowedByGitignoreException, isBlockedByGitignore } from "./src/guard-gitignore.js";
export { assertCommandExecutionAllowed, extractMainCommand, guardCommandExecution, isAllowedCommand, isBlockedCommand, matchesCommandPattern } from "./src/guard-command.js";
export { CommandGuardError } from "./src/errors/command-guard-error.js";
export type { CommandGuardDecision, CommandGuardResult } from "./src/guard-command.js";

export default function piGuardian(pi: ExtensionAPI) {
  pi.on("tool_call", async (event) => {
    const paths: Array<{ path: string; operation: string }> = [];
    const fileGuardEnabled = isGuardianFeatureEnabled("file");
    const pathGuardEnabled = isGuardianFeatureEnabled("path");
    const gitignoreGuardEnabled = isGuardianFeatureEnabled("gitignore");
    const commandGuardEnabled = isGuardianFeatureEnabled("command");

    if (fileGuardEnabled || pathGuardEnabled || gitignoreGuardEnabled) {
      if (isToolCallEventType("read", event)) {
        const path = getPathInput(event.input);
        if (path) paths.push({ path, operation: "read" });
      }

      if (isToolCallEventType("write", event)) {
        const path = getPathInput(event.input);
        if (path) paths.push({ path, operation: "write" });
      }

      if (isToolCallEventType("edit", event)) {
        paths.push(...getEditPaths(event.input).map((path) => ({ path, operation: "edit" })));
      }
    }

    if (isToolCallEventType("bash", event)) {
      const command = getBashCommand(event.input);
      if (command) {
        try {
          if (commandGuardEnabled) {
            await assertCommandExecutionAllowed({ commandLine: command });
          }
          if (pathGuardEnabled) {
            assertGuardOperationCommandAllowed({ command, blockedPaths: BLOCKED_PATHS, operation: "execute" });
          }
          if (gitignoreGuardEnabled) {
            guardGitignoreAccess({ path: command, rootDir: process.cwd(), operation: "terminal" });
          }
        } catch (error) {
          if (error instanceof CommandGuardError || error instanceof PathGuardError || error instanceof GitignoreGuardError) return { block: true, reason: error.message };
          throw error;
        }

        if (commandReadsFileContent(command)) {
          paths.push(...extractPotentialPathsFromCommand(command).map((path) => ({ path, operation: "read" })));
        }
      }
    }

    for (const { path, operation } of paths) {
      try {
        if (pathGuardEnabled) assertPathAccessAllowed({ path, operation });
        if (fileGuardEnabled) assertFileAccessAllowed(path, operation as never);
        if (gitignoreGuardEnabled) {
          const gitignoreResult = guardGitignoreAccess({
            path,
            rootDir: process.cwd(),
            operation: operation as GitignoreGuardOperation,
          });
          if (!gitignoreResult.allowed) return { block: true, reason: gitignoreResult.message };
        }
      } catch (error) {
        if (error instanceof FileGuardError || error instanceof PathGuardError || error instanceof GitignoreGuardError) {
          return { block: true, reason: error.message };
        }
        throw error;
      }
    }
  });
}
