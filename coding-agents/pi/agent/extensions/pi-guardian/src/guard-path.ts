import { BLOCKED_CONFIGS_PATHS, BLOCKED_CREDENTIALS_PATHS, BLOCKED_ROOT_PATHS } from "./constants/guardian-constants.js";
import { pathContainsBlockedSegment } from "./utils/path-guard-utils.js";
import { PathGuardError } from "./errors/path-guard-error.js";
import { isGuardianFeatureEnabled } from "./config.js";

export { BLOCKED_CONFIGS_PATHS, BLOCKED_CREDENTIALS_PATHS, BLOCKED_ROOT_PATHS } from "./constants/guardian-constants.js";
export { PathGuardError } from "./errors/path-guard-error.js";

export const BLOCKED_PATHS = [...BLOCKED_ROOT_PATHS, ...BLOCKED_CREDENTIALS_PATHS, ...BLOCKED_CONFIGS_PATHS];

export function isBlockedPath(params: { path: string }): boolean {
  if (!isGuardianFeatureEnabled("path")) return false;
  return pathContainsBlockedSegment({ path: params.path, blockedPaths: BLOCKED_PATHS });
}

export function assertPathAccessAllowed(params: { path: string; operation?: string }): void {
  if (!isGuardianFeatureEnabled("path")) return;
  if (isBlockedPath({ path: params.path })) {
    throw new PathGuardError(params);
  }
}
