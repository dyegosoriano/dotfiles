import { CONTENT_READING_COMMANDS } from "../constants/guardian-constants.js";
import { stripShellQuotes } from "./path-utils.js";

export function extractPotentialPathsFromCommand(command: string): string[] {
  return command
    .split(/[\s;&|<>]+/)
    .map(stripShellQuotes)
    .filter(Boolean);
}

export function getCommandExecutable(command: string): string {
  const firstCommand = command.trim().split(/[\s;&|]+/)[0] ?? "";
  return firstCommand.split("/").pop() ?? firstCommand;
}

export function commandReadsFileContent(command: string): boolean {
  const executable = getCommandExecutable(command);
  return CONTENT_READING_COMMANDS.includes(executable as (typeof CONTENT_READING_COMMANDS)[number]);
}
