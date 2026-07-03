import { afterEach, beforeEach, describe, it } from "node:test";
import { mkdir, mkdtemp, readFile, rm, writeFile } from "node:fs/promises";
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

  it("preserva itens existentes ao adicionar whitelist", async () => {
    await guardCommandExecution({ commandLine: "go test ./...", onUnknownCommand: () => "add-to-whitelist" });
    await guardCommandExecution({ commandLine: "go vet ./...", onUnknownCommand: () => "add-to-whitelist" });

    const config = JSON.parse(await readFile(join(home, ".config/pi-guardian/config.json"), "utf8"));

    assert.deepEqual(config.allowedCommands, ["go test ./...", "go vet ./..."]);
  });

  it("não limpa config existente ao solicitar confirmação", async () => {
    const configDir = join(home, ".config/pi-guardian");
    const configPath = join(configDir, "config.json");
    const rawConfig = `{
  "blockedCommands": ["python", "python3"],
  "allowedCommands": ["git commit *", "git status *"],
}
`;

    await mkdir(configDir, { recursive: true });
    await writeFile(configPath, rawConfig);

    await guardCommandExecution({ commandLine: "whoami", onUnknownCommand: () => "allow-once" });

    assert.equal(await readFile(configPath, "utf8"), rawConfig);
  });

  it("preserva whitelist e blacklist existentes ao adicionar whitelist com vírgula final", async () => {
    const configDir = join(home, ".config/pi-guardian");
    const configPath = join(configDir, "config.json");

    await mkdir(configDir, { recursive: true });
    await writeFile(configPath, `{
  "blockedCommands": ["python", "python3"],
  "allowedCommands": ["git commit *", "git status *"],
}
`);

    await guardCommandExecution({ commandLine: "go vet ./...", onUnknownCommand: () => "add-to-whitelist" });

    const config = JSON.parse(await readFile(configPath, "utf8"));

    assert.deepEqual(config.blockedCommands, ["python", "python3"]);
    assert.deepEqual(config.allowedCommands, ["git commit *", "git status *", "go vet ./..."]);
  });

  it("bloqueia e persiste blacklist quando decisão for add-to-blacklist", async () => {
    const result = await guardCommandExecution({ commandLine: "python script.py", onUnknownCommand: () => "add-to-blacklist" });

    assert.equal(result.allowed, false);

    const config = JSON.parse(await readFile(join(home, ".config/pi-guardian/config.json"), "utf8"));

    assert.deepEqual(config.blockedCommands, ["python script.py"]);
    assert.equal((await guardCommandExecution({ commandLine: "python script.py", onUnknownCommand: () => "allow-once" })).allowed, false);
  });

  it("preserva itens existentes ao adicionar blacklist", async () => {
    await guardCommandExecution({ commandLine: "python script.py", onUnknownCommand: () => "add-to-blacklist" });
    await guardCommandExecution({ commandLine: "ruby script.rb", onUnknownCommand: () => "add-to-blacklist" });

    const config = JSON.parse(await readFile(join(home, ".config/pi-guardian/config.json"), "utf8"));

    assert.deepEqual(config.blockedCommands, ["python script.py", "ruby script.rb"]);
  });

  it("preserva whitelist e blacklist existentes ao adicionar blacklist com vírgula final", async () => {
    const configDir = join(home, ".config/pi-guardian");
    const configPath = join(configDir, "config.json");

    await mkdir(configDir, { recursive: true });
    await writeFile(configPath, `{
  "blockedCommands": ["python", "python3"],
  "allowedCommands": ["git commit *", "git status *"],
}
`);

    await guardCommandExecution({ commandLine: "ruby script.rb", onUnknownCommand: () => "add-to-blacklist" });

    const config = JSON.parse(await readFile(configPath, "utf8"));

    assert.deepEqual(config.blockedCommands, ["python", "python3", "ruby script.rb"]);
    assert.deepEqual(config.allowedCommands, ["git commit *", "git status *"]);
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
