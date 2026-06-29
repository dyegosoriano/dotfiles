import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import test from "node:test";

import {
  assertGitignoreAccessAllowed,
  GitignoreGuardError,
  guardGitignoreAccess,
  isAllowedByGitignoreException,
  isBlockedByGitignore,
} from "../src/guard-gitignore.js";
import { commandContainsGitignoredPath, readGitignorePatterns } from "../src/utils/gitignore-utils.js";

function fixture(gitignore: string): string {
  const rootDir = fs.mkdtempSync(path.join(os.tmpdir(), "pi-guardian-gitignore-"));
  fs.writeFileSync(path.join(rootDir, ".gitignore"), gitignore);
  return rootDir;
}

const DEFAULT_GITIGNORE = `
# dependencies
node_modules/

dist/
build/
coverage/
.env
.env.*
*.log
`;

test("lê padrões do .gitignore, ignora linhas vazias e comentários", () => {
  const rootDir = fixture(DEFAULT_GITIGNORE);
  assert.deepEqual(readGitignorePatterns({ rootDir }), ["node_modules/", "dist/", "build/", "coverage/", ".env", ".env.*", "*.log"]);
});

test("bloqueia diretórios e arquivos ignorados comuns", () => {
  const rootDir = fixture(DEFAULT_GITIGNORE);
  for (const ignoredPath of ["node_modules", "node_modules/pkg/index.js", "dist/main.js", "build/out.js", "coverage/index.html", ".env", ".env.local", "app.log"]) {
    assert.equal(isBlockedByGitignore({ path: ignoredPath, rootDir }), true, ignoredPath);
  }
});

test("permite arquivos não ignorados", () => {
  const rootDir = fixture(DEFAULT_GITIGNORE);
  for (const allowedPath of ["src/app.ts", "README.md", "package.json"]) {
    assert.equal(isBlockedByGitignore({ path: allowedPath, rootDir }), false, allowedPath);
  }
});

test("suporta exceções com !", () => {
  const rootDir = fixture(".env*\n!.env.example\ndist/\n!dist/README.md\n");
  assert.equal(isBlockedByGitignore({ path: ".env", rootDir }), true);
  assert.equal(isBlockedByGitignore({ path: ".env.local", rootDir }), true);
  assert.equal(isBlockedByGitignore({ path: ".env.example", rootDir }), false);
  assert.equal(isAllowedByGitignoreException({ path: ".env.example", rootDir }), true);
  assert.equal(isBlockedByGitignore({ path: "dist/main.js", rootDir }), true);
  assert.equal(isBlockedByGitignore({ path: "dist/README.md", rootDir }), false);
});

test("operação read bloqueada oculta conteúdo sem lançar erro e retorna alerta", () => {
  const rootDir = fixture(DEFAULT_GITIGNORE);
  const result = guardGitignoreAccess({ path: ".env", rootDir, operation: "read" });
  assert.deepEqual(result, {
    allowed: false,
    hidden: true,
    message: 'The file ".env" is ignored by .gitignore and its content was hidden by pi-guardian.',
  });
});

test("lança GitignoreGuardError para operações diferentes de read e inclui operação", () => {
  const rootDir = fixture(DEFAULT_GITIGNORE);
  for (const operation of ["write", "edit", "list", "search", "index", "terminal"] as const) {
    const pathOrCommand = operation === "terminal" ? "cat .env" : ".env";
    assert.throws(
      () => assertGitignoreAccessAllowed({ path: pathOrCommand, rootDir, operation }),
      (error: unknown) =>
        error instanceof GitignoreGuardError &&
        error.message === `Access denied by pi-guardian gitignore guard for operation "${operation}": ${pathOrCommand}`,
      operation,
    );
  }
});

test("funciona com caminhos relativos, absolutos e normalizados", () => {
  const rootDir = fixture(DEFAULT_GITIGNORE);
  assert.equal(isBlockedByGitignore({ path: "./node_modules//pkg/index.js", rootDir }), true);
  assert.equal(isBlockedByGitignore({ path: path.join(rootDir, ".env.local"), rootDir }), true);
});

test("bloqueia comandos de terminal que acessam caminhos ignorados", () => {
  const rootDir = fixture(DEFAULT_GITIGNORE + "!dist/README.md\n");
  const patterns = readGitignorePatterns({ rootDir });
  for (const command of ["cat .env", "cat .env.local", "ls node_modules", "rm -rf dist", "grep -R token coverage", "find ./build -type f", "tail -f app.log"]) {
    assert.equal(commandContainsGitignoredPath({ command, patterns, rootDir }), true, command);
  }
});

test("permite comandos de terminal seguros", () => {
  const rootDir = fixture(".env*\n!.env.example\ndist/\n!dist/README.md\n*.log\n");
  const patterns = readGitignorePatterns({ rootDir });
  for (const command of ["cat .env.example", "ls src", "cat README.md", "cat package.json", "npm test", "pnpm test", "node scripts/build.js", "cat dist/README.md"]) {
    assert.equal(commandContainsGitignoredPath({ command, patterns, rootDir }), false, command);
  }
});
