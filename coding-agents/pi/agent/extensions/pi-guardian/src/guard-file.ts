import { isListOperation, type FileGuardOperation } from "./operations/guard-operations.js";
import { BLOQUED_FILES } from "./constants/guardian-constants.js";
import { FileGuardError } from "./errors/file-guard-error.js";
export { FileGuardError } from "./errors/file-guard-error.js";
import { matchesPattern } from "./utils/pattern-matcher.js";

export type { FileGuardOperation, GuardOperation } from "./operations/guard-operations.js";

export { BLOQUED_FILES } from "./constants/guardian-constants.js";

export function isBlockedFile(filePath: string): boolean {
  return BLOQUED_FILES.some((pattern) => matchesPattern(filePath, pattern));
}

export function assertFileAccessAllowed(filePath: string, operation: FileGuardOperation = "read"): void {
  if (isListOperation(operation)) return;

  if (isBlockedFile(filePath)) {
    throw new FileGuardError(`Access denied by pi-guardian: ${filePath}`);
  }
}
