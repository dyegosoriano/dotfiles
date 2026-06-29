export class GitignoreGuardError extends Error {
  constructor(params: { path: string; operation?: string }) {
    const { path, operation } = params;
    super(
      operation
        ? `Access denied by pi-guardian gitignore guard for operation "${operation}": ${path}`
        : `Access denied by pi-guardian gitignore guard: ${path}`,
    );
    this.name = "GitignoreGuardError";
  }
}
