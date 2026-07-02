import { addAllowedCommand, addBlockedCommand, loadConfig, type CommandPolicyConfig } from "./utils/config-storage.js";
import { ALLOWED_COMMANDS, BLOCKED_COMMANDS } from "./constants/guardian-constants.js";
import { CommandGuardError } from "./errors/command-guard-error.js";

export type CommandGuardResult = { requiresConfirmation?: boolean; matchedRule?: string; allowed: boolean; command: string; reason?: string };

export type CommandGuardDecision = "allow-once" | "block" | "add-to-whitelist" | "add-to-blacklist";

let cachedConfig: CommandPolicyConfig = { allowedCommands: [], blockedCommands: [] };

export function normalizeCommandLine(params: { commandLine: string }): string {
  return params.commandLine.trim().replace(/\s+/g, " ");
}

export function splitCommandLine(params: { commandLine: string }): string[] {
  const input = normalizeCommandLine(params);
  const tokens: string[] = [];

  let quote: string | undefined;
  let current = "";

  for (let i = 0; i < input.length; i += 1) {
    const char = input[i];
    if ((char === '"' || char === "'") && input[i - 1] !== "\\") {
      if (quote === char) quote = undefined;
      else if (!quote) quote = char;
      continue;
    }

    if (!quote && /\s/.test(char)) {
      if (current) tokens.push(current);
      current = "";
      continue;
    }

    current += char;
  }

  if (current) tokens.push(current);

  return tokens;
}

export function extractMainCommand(params: { commandLine: string }): string {
  return splitCommandLine(params)[0] ?? "";
}

export function extractCommandSegments(params: { commandLine: string }): string[] {
  const input = params.commandLine.trim();
  const segments: string[] = [];

  let quote: string | undefined;
  let current = "";

  for (let i = 0; i < input.length; i += 1) {
    const char = input[i];

    if ((char === '"' || char === "'") && input[i - 1] !== "\\") quote = quote === char ? undefined : quote ? quote : char;

    const two = input.slice(i, i + 2);

    if (!quote && (two === "&&" || two === "||")) {
      if (current.trim()) segments.push(current.trim());
      current = "";
      i += 1;
      continue;
    }

    if (!quote && (char === ";" || char === "|")) {
      if (current.trim()) segments.push(current.trim());
      current = "";
      continue;
    }

    current += char;
  }

  if (current.trim()) segments.push(current.trim());

  return segments;
}

function shellInnerCommand(commandLine: string): string | undefined {
  const tokens = splitCommandLine({ commandLine });

  if ((tokens[0] === "sh" || tokens[0] === "bash") && tokens[1] === "-c") return tokens.slice(2).join(" ");

  return undefined;
}

export function matchesWildcardCommandPattern(params: { commandLine: string; pattern: string }): boolean {
  const command = normalizeCommandLine({ commandLine: params.commandLine });
  const pattern = normalizeCommandLine({ commandLine: params.pattern });

  if (pattern.endsWith(" *")) return command === pattern.slice(0, -2) || command.startsWith(pattern.slice(0, -1));

  return command === pattern || extractMainCommand({ commandLine: command }) === pattern;
}

export function matchesCommandPattern(params: { commandLine: string; pattern: string }): boolean {
  return matchesWildcardCommandPattern(params);
}

function findMatch(commandLine: string, rules: string[]): string | undefined {
  for (const segment of extractCommandSegments({ commandLine })) {
    const inner = shellInnerCommand(segment);

    if (inner) {
      const innerMatch = findMatch(inner, rules);
      if (innerMatch) return innerMatch;
    }

    const match = rules.find((pattern) => matchesCommandPattern({ commandLine: segment, pattern }));

    if (match) return match;
  }

  return undefined;
}

export function isBlockedCommand(params: { commandLine: string }): boolean {
  return Boolean(findMatch(params.commandLine, [...BLOCKED_COMMANDS, ...cachedConfig.blockedCommands]));
}

export function isAllowedCommand(params: { commandLine: string }): boolean {
  const segments = extractCommandSegments({ commandLine: params.commandLine });

  return segments.length > 0 && segments.every((segment) => {
    const inner = shellInnerCommand(segment);

    if (inner) return isAllowedCommand({ commandLine: inner });

    return Boolean(findMatch(segment, [...ALLOWED_COMMANDS, ...cachedConfig.allowedCommands]));
  });
}

export async function guardCommandExecution(params: {
  commandLine: string;
  onUnknownCommand?: (params: { commandLine: string; command: string }) => Promise<CommandGuardDecision> | CommandGuardDecision;
}): Promise<CommandGuardResult> {
  cachedConfig = await loadConfig();

  const commandLine = normalizeCommandLine({ commandLine: params.commandLine });
  const command = extractMainCommand({ commandLine });

  const blockedRule = findMatch(commandLine, [...BLOCKED_COMMANDS, ...cachedConfig.blockedCommands]);
  if (blockedRule) return { allowed: false, command, matchedRule: blockedRule, reason: `Command matched blacklist rule: ${blockedRule}` };

  const allowedRules = [...ALLOWED_COMMANDS, ...cachedConfig.allowedCommands];
  if (isAllowedCommand({ commandLine })) return { allowed: true, command, matchedRule: findMatch(commandLine, allowedRules), reason: "Command matched whitelist." };

  const decision = params.onUnknownCommand ? await params.onUnknownCommand({ commandLine, command }) : "block";
  if (decision === "allow-once") return { allowed: true, command, requiresConfirmation: true, reason: "Command approved by user for this execution." };

  if (decision === "add-to-whitelist") {
    await addAllowedCommand(commandLine);
    cachedConfig = await loadConfig();
    return { allowed: true, command, requiresConfirmation: true, reason: "Command approved by user and persisted in config." };
  }

  if (decision === "add-to-blacklist") {
    await addBlockedCommand(commandLine);
    cachedConfig = await loadConfig();
    return { allowed: false, command, requiresConfirmation: true, matchedRule: commandLine, reason: "Command blocked by user and persisted in config." };
  }

  return { allowed: false, command, requiresConfirmation: true, reason: "Command rejected by user." };
}

export async function assertCommandExecutionAllowed(params: {
  commandLine: string;
  onUnknownCommand?: (params: { commandLine: string; command: string }) => Promise<CommandGuardDecision> | CommandGuardDecision;
}): Promise<void> {
  const result = await guardCommandExecution(params);
  if (!result.allowed) throw new CommandGuardError({ commandLine: params.commandLine, command: result.command, reason: result.reason });
}

export { ALLOWED_COMMANDS, BLOCKED_COMMANDS } from "./constants/guardian-constants.js";
export { CommandGuardError } from "./errors/command-guard-error.js";
