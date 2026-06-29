import assert from "node:assert/strict";
import test from "node:test";

import { assertFileAccessAllowed, FileGuardError, isBlockedFile } from "../src/guard-file.js";

test("bloqueia arquivos .pem", () => {
  assert.equal(isBlockedFile("certs/private.pem"), true);
});

test("bloqueia arquivos .key", () => {
  assert.equal(isBlockedFile("keys/server.key"), true);
});

test("bloqueia .env", () => {
  assert.equal(isBlockedFile(".env"), true);
});

test("bloqueia .env.local", () => {
  assert.equal(isBlockedFile("apps/api/.env.local"), true);
});

test("bloqueia arquivos id_rsa", () => {
  assert.equal(isBlockedFile("/home/user/.ssh/id_rsa"), true);
});

test("permite arquivos comuns como README.md", () => {
  assert.equal(isBlockedFile("README.md"), false);
});

test("permite arquivos .ts, .js e .json", () => {
  assert.equal(isBlockedFile("scripts/build.js"), false);
  assert.equal(isBlockedFile("src/index.ts"), false);
  assert.equal(isBlockedFile("package.json"), false);
});

test("interpreta * no início do padrão", () => {
  assert.equal(isBlockedFile("nested/client.pem"), true);
});

test("interpreta * no final do padrão", () => {
  assert.equal(isBlockedFile(".env.production"), true);
});

test("interpreta * no início e no final do padrão", async (t) => {
  const guard = await import("../src/guard-file.js");
  const originalPatterns = [...guard.BLOQUED_FILES];

  guard.BLOQUED_FILES.push("*secret*");

  t.after(() => {
    guard.BLOQUED_FILES.splice(0, guard.BLOQUED_FILES.length, ...originalPatterns);
  });

  assert.equal(guard.isBlockedFile("docs/my-secret-plan.md"), true);
});

test("permite listar arquivo bloqueado sem ler conteúdo", () => {
  assert.doesNotThrow(() => assertFileAccessAllowed("/tmp/private.key", "list"));
});

test("lança FileGuardError ao tentar acessar conteúdo de arquivo bloqueado", () => {
  assert.throws(
    () => assertFileAccessAllowed("/tmp/private.key", "read"),
    (error: unknown) => error instanceof FileGuardError && error.message === "Access denied by pi-guardian: /tmp/private.key",
  );
});
