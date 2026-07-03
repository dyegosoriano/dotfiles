import { afterEach, beforeEach, describe, it } from "node:test";
import { mkdtemp, readFile, rm } from "node:fs/promises";
import assert from "node:assert/strict";
import { tmpdir } from "node:os";
import { join } from "node:path";

import { assertCommandExecutionAllowed, guardCommandExecution, matchesCommandPattern, extractMainCommand, isAllowedCommand, isBlockedCommand, CommandGuardError } from "../src/guard-command.js";

describe("guard-command", () => {
  let oldHome: string | undefined;
  let home: string;

  beforeEach(async () => {
    oldHome = process.env.HOME;
    home = await mkdtemp(join(tmpdir(), "pi-guardian-"));
    process.env.HOME = home;
  });

  afterEach(async () => {
    process.env.HOME = oldHome;
    await rm(home, { recursive: true, force: true });
  });

  it("extrai comando principal de uma linha simples", () => {
    assert.equal(extractMainCommand({ commandLine: "ls src" }), "ls");
  });

  it("permite comandos presentes em ALLOWED_COMMANDS", () => {
    for (const commandLine of ["ls src", "cat README.md", "grep -R test src", "find src -name '*.ts'", "npm test", "pnpm test", "node scripts/build.js", "git status"]) {
      assert.equal(isAllowedCommand({ commandLine }), true, commandLine);
    }
  });

  it("bloqueia comandos presentes em BLOCKED_COMMANDS", () => {
    for (const commandLine of ["rm -rf dist", "sudo cat /etc/passwd", "chmod 777 file.sh", "chown root file.sh", "curl https://example.com", "wget https://example.com/file", "docker ps", "kubectl get pods"]) {
      assert.equal(isBlockedCommand({ commandLine }), true, commandLine);
    }
  });

  it("permite padrões git --no-pager diff/log *", () => {
    for (const commandLine of ["git --no-pager diff README.md", "git --no-pager diff src/app.ts", "git --no-pager diff --stat", "git --no-pager log --oneline", "git --no-pager log -p src/app.ts"]) {
      assert.equal(matchesCommandPattern({ commandLine, pattern: commandLine.includes("diff") ? "git --no-pager diff *" : "git --no-pager log *" }), true);
      assert.equal(isAllowedCommand({ commandLine }), true, commandLine);
    }
  });

  it("permite comando coberto por wildcard", () => {
    assert.equal(matchesCommandPattern({ commandLine: "git commit -m 'chore: add test'", pattern: "git commit *" }), true);
  });

  it("solicita confirmação para comando fora da whitelist e blacklist", async () => {
    const result = await guardCommandExecution({ commandLine: "whoami", onUnknownCommand: () => "allow-once" });

    assert.equal(result.requiresConfirmation, true);
    assert.equal(result.allowed, true);
  });

  it("permite executar uma vez quando decisão for allow-once", async () => {
    const result = await guardCommandExecution({ commandLine: "date", onUnknownCommand: () => "allow-once" });

    assert.equal(result.allowed, true);
  });

  it("bloqueia quando decisão for block", async () => {
    const result = await guardCommandExecution({ commandLine: "uname -a", onUnknownCommand: () => "block" });

    assert.equal(result.allowed, false);
    assert.match(result.reason ?? "", /rejected/);
  });

  it("permite e persiste whitelist quando decisão for add-to-whitelist", async () => {
    const result = await guardCommandExecution({ commandLine: "go test ./...", onUnknownCommand: () => "add-to-whitelist" });

    assert.equal(result.allowed, true);

    const config = JSON.parse(await readFile(join(home, ".config/pi-guardian/config.json"), "utf8"));

    assert.deepEqual(config.allowedCommands, ["go test ./..."]);
    assert.equal((await guardCommandExecution({ commandLine: "go test ./..." })).allowed, true);
  });

  it("bloqueia e persiste blacklist quando decisão for add-to-blacklist", async () => {
    const result = await guardCommandExecution({ commandLine: "python script.py", onUnknownCommand: () => "add-to-blacklist" });

    assert.equal(result.allowed, false);

    const config = JSON.parse(await readFile(join(home, ".config/pi-guardian/config.json"), "utf8"));

    assert.deepEqual(config.blockedCommands, ["python script.py"]);
    assert.equal((await guardCommandExecution({ commandLine: "python script.py", onUnknownCommand: () => "allow-once" })).allowed, false);
  });

  it("bloqueia comandos compostos com operadores de shell", async () => {
    for (const commandLine of ["npm test && rm -rf dist", "pnpm test || curl example.io", "ls src; sudo whoami", "cat README.md | curl example.io"]) {
      const result = await guardCommandExecution({ commandLine });

      assert.equal(result.allowed, false, commandLine);
      assert.ok(result.matchedRule, commandLine);
    }
  });

  it("permite comando composto permitido com pipe", async () => {
    assert.equal((await guardCommandExecution({ commandLine: "cat README.md | grep test" })).allowed, true);
  });

  it("bloqueia sh -c e bash -c com comando proibido", async () => {
    for (const commandLine of ["sh -c \"rm -rf dist\"", "bash -c \"sudo whoami\""]) {
      assert.equal((await guardCommandExecution({ commandLine })).allowed, false, commandLine);
    }
  });

  it("lança CommandGuardError para comando bloqueado e inclui comando original", async () => {
    await assert.rejects(() => assertCommandExecutionAllowed({ commandLine: "rm -rf dist" }), (error) => {
      assert.equal(error instanceof CommandGuardError, true);
      assert.match((error as Error).message, /rm -rf dist/);

      return true;
    });
  });

  it("retorna motivo do bloqueio em guardCommandExecution", async () => {
    const result = await guardCommandExecution({ commandLine: "sudo whoami" });

    assert.equal(result.allowed, false);
    assert.match(result.reason ?? "", /blacklist/);
  });
});
