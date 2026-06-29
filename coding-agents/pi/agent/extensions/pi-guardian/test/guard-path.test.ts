import assert from "node:assert/strict";
import { homedir } from "node:os";
import test from "node:test";

import { assertPathAccessAllowed, BLOCKED_PATHS, isBlockedPath, PathGuardError } from "../src/guard-path.js";
import { commandContainsBlockedPath } from "../src/utils/path-guard-utils.js";

test("bloqueia acesso direto a /etc", () => {
  assert.equal(isBlockedPath({ path: "/etc" }), true);
});

test("bloqueia acesso direto a /root", () => {
  assert.equal(isBlockedPath({ path: "/root" }), true);
});

test("bloqueia arquivos dentro de /etc", () => {
  assert.equal(isBlockedPath({ path: "/etc/passwd" }), true);
});

test("bloqueia arquivos dentro de /var", () => {
  assert.equal(isBlockedPath({ path: "/var/log/syslog" }), true);
});

test("bloqueia diretórios aninhados bloqueados", () => {
  assert.equal(isBlockedPath({ path: "~/.config/gcloud/application_default_credentials.json" }), true);
});

test("bloqueia /boot, /proc, /sys e /dev", () => {
  assert.equal(isBlockedPath({ path: "/sys/kernel/debug" }), true);
  assert.equal(isBlockedPath({ path: "/proc/cpuinfo" }), true);
  assert.equal(isBlockedPath({ path: "/boot/grub" }), true);
  assert.equal(isBlockedPath({ path: "/dev/null" }), true);
});

test("bloqueia ~/.ssh, ~/.aws, ~/.kube e ~/.azure", () => {
  assert.equal(isBlockedPath({ path: "~/.aws/credentials" }), true);
  assert.equal(isBlockedPath({ path: "~/.azure/config" }), true);
  assert.equal(isBlockedPath({ path: "~/.kube/config" }), true);
  assert.equal(isBlockedPath({ path: "~/.ssh/id_rsa" }), true);
});

test("bloqueia caminhos absolutos dentro de diretórios bloqueados com ~", () => {
  assert.equal(isBlockedPath({ path: `${homedir()}/.config/gcloud/application_default_credentials.json` }), true);
  assert.equal(isBlockedPath({ path: `${homedir()}/.aws/credentials` }), true);
  assert.equal(isBlockedPath({ path: `${homedir()}/.azure/config` }), true);
  assert.equal(isBlockedPath({ path: `${homedir()}/.kube/config` }), true);
  assert.equal(isBlockedPath({ path: `${homedir()}/.ssh/id_rsa` }), true);
});

test("permite src/app.ts", () => {
  assert.equal(isBlockedPath({ path: "src/app.ts" }), false);
});

test("permite README.md", () => {
  assert.equal(isBlockedPath({ path: "README.md" }), false);
});

test("permite package.json", () => {
  assert.equal(isBlockedPath({ path: "package.json" }), false);
});

test("normaliza caminhos com ./ e //", () => {
  assert.equal(isBlockedPath({ path: "./etc//shadow" }), true);
});

test("funciona com caminhos absolutos", () => {
  assert.equal(isBlockedPath({ path: "/root/.bashrc" }), true);
});

test("lança PathGuardError em caminhos bloqueados", () => {
  assert.throws(
    () => assertPathAccessAllowed({ path: "/etc/passwd" }),
    (error: unknown) => error instanceof PathGuardError && error.message === "Access denied by pi-guardian: /etc/passwd",
  );
});

test("inclui o nome da operação na mensagem de erro", () => {
  assert.throws(
    () => assertPathAccessAllowed({ path: "/etc/passwd", operation: "read" }),
    (error: unknown) =>
      error instanceof PathGuardError && error.message === 'Access denied by pi-guardian for operation "read": /etc/passwd',
  );
});

test("bloqueia comandos de terminal que acessam diretórios bloqueados", () => {
  assert.equal(commandContainsBlockedPath({ command: "cat ~/.aws/credentials", blockedPaths: BLOCKED_PATHS }), true);
  assert.equal(commandContainsBlockedPath({ command: 'grep -R "token" /etc', blockedPaths: BLOCKED_PATHS }), true);
  assert.equal(commandContainsBlockedPath({ command: "find /proc -type f", blockedPaths: BLOCKED_PATHS }), true);
  assert.equal(commandContainsBlockedPath({ command: "cat ~/.ssh/id_rsa", blockedPaths: BLOCKED_PATHS }), true);
  assert.equal(commandContainsBlockedPath({ command: "rm -rf /var/log", blockedPaths: BLOCKED_PATHS }), true);
  assert.equal(commandContainsBlockedPath({ command: "cat /etc/passwd", blockedPaths: BLOCKED_PATHS }), true);
  assert.equal(commandContainsBlockedPath({ command: "ls /root", blockedPaths: BLOCKED_PATHS }), true);
  assert.equal(commandContainsBlockedPath({ command: "cd /sys", blockedPaths: BLOCKED_PATHS }), true);
});

test("permite comandos de terminal seguros", () => {
  assert.equal(commandContainsBlockedPath({ command: "node scripts/build.js", blockedPaths: BLOCKED_PATHS }), false);
  assert.equal(commandContainsBlockedPath({ command: "cat README.md", blockedPaths: BLOCKED_PATHS }), false);
  assert.equal(commandContainsBlockedPath({ command: "pnpm test", blockedPaths: BLOCKED_PATHS }), false);
  assert.equal(commandContainsBlockedPath({ command: "npm test", blockedPaths: BLOCKED_PATHS }), false);
  assert.equal(commandContainsBlockedPath({ command: "ls src", blockedPaths: BLOCKED_PATHS }), false);
});
