export function getPathInput(input: unknown): string | undefined {
  if (!input || typeof input !== "object") return undefined;
  const value = (input as { path?: unknown }).path;

  return typeof value === "string" ? value : undefined;
}

export function getEditPaths(input: unknown): string[] {
  const path = getPathInput(input);
  return path ? [path] : [];
}

export function getBashCommand(input: unknown): string | undefined {
  if (!input || typeof input !== "object") return undefined;

  const value = (input as { command?: unknown }).command;

  return typeof value === "string" ? value : undefined;
}
