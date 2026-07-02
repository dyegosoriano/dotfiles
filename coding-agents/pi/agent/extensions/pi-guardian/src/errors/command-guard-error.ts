export class CommandGuardError extends Error {
  constructor(params: { commandLine: string; command?: string; reason?: string }) {
    const { commandLine, reason } = params;

    super(
      reason
        ? `Command denied by pi-guardian: ${commandLine}. Reason: ${reason}`
        : `Command denied by pi-guardian: ${commandLine}`
    );

    this.name = "CommandGuardError";
  }
}
