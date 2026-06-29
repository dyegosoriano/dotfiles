export class PathGuardError extends Error {
  constructor(params: { path: string; operation?: string }) {
    const { path, operation } = params;

    super(operation ? `Access denied by pi-guardian for operation "${operation}": ${path}` : `Access denied by pi-guardian: ${path}`);

    this.name = "PathGuardError";
  }
}
