import assert from "node:assert/strict";
import test from "node:test";

import { isGuardianFeatureEnabled } from "../src/config.js";

test("lê as features do pi-guardian somente do settings.json", () => {
  assert.equal(isGuardianFeatureEnabled("file"), true);
  assert.equal(isGuardianFeatureEnabled("path"), true);
  assert.equal(isGuardianFeatureEnabled("gitignore"), true);
});
