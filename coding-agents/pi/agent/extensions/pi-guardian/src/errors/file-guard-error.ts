export class FileGuardError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "FileGuardError";
  }
}
