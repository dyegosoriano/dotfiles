import { mkdir, readFile, writeFile } from "node:fs/promises";
import { homedir } from "node:os";
import { join } from "node:path";

export type CommandPolicyConfig = { allowedCommands: string[], blockedCommands: string[] };

const DEFAULT_CONFIG: CommandPolicyConfig = { allowedCommands: [], blockedCommands: [] };

function configPath(): string {
  return join(process.env.HOME ?? homedir(), ".config", "pi-guardian", "config.json");
}

function normalizeConfig(value: unknown): CommandPolicyConfig {
  const config = (value && typeof value === "object" ? value : {}) as Partial<CommandPolicyConfig>;
  return {
    allowedCommands: Array.isArray(config.allowedCommands) ? [...new Set(config.allowedCommands.filter((item): item is string => typeof item === "string"))] : [],
    blockedCommands: Array.isArray(config.blockedCommands) ? [...new Set(config.blockedCommands.filter((item): item is string => typeof item === "string"))] : [],
  };
}

function parseConfig(raw: string): CommandPolicyConfig {
  return normalizeConfig(JSON.parse(raw.replace(/,\s*([}\]])/g, "$1")));
}

export async function loadConfig(): Promise<CommandPolicyConfig> {
  const path = configPath();
  await mkdir(join(path, ".."), { recursive: true });

  try {
    const raw = await readFile(path, "utf8");
    return parseConfig(raw);
  } catch {
    return { ...DEFAULT_CONFIG };
  }
}

export async function saveConfig(config: CommandPolicyConfig): Promise<void> {
  const path = configPath();

  await mkdir(join(path, ".."), { recursive: true });
  const existing = await readExistingConfig();

  const merged = normalizeConfig({
    allowedCommands: [...existing.allowedCommands, ...config.allowedCommands],
    blockedCommands: [...existing.blockedCommands, ...config.blockedCommands],
  });

  await writeFile(path, `${JSON.stringify(merged, null, 2)}\n`, "utf8");
}

async function readExistingConfig(): Promise<CommandPolicyConfig> {
  try {
    return parseConfig(await readFile(configPath(), "utf8"));
  } catch {
    return { ...DEFAULT_CONFIG };
  }
}

export async function addAllowedCommand(command: string): Promise<void> {
  const config = await readExistingConfig();

  if (!config.allowedCommands.includes(command)) config.allowedCommands.push(command);

  await writeConfig(config);
}

export async function addBlockedCommand(command: string): Promise<void> {
  const config = await readExistingConfig();

  if (!config.blockedCommands.includes(command)) config.blockedCommands.push(command);

  await writeConfig(config);
}

async function writeConfig(config: CommandPolicyConfig): Promise<void> {
  const path = configPath();

  await mkdir(join(path, ".."), { recursive: true });
  await writeFile(path, `${JSON.stringify(normalizeConfig(config), null, 2)}\n`, "utf8");
}
