import fs from "node:fs";
import { fileURLToPath } from "node:url";

export type GuardianFeature = "file" | "path" | "gitignore";

type PiGuardianSettings = Partial<Record<GuardianFeature, boolean>> & {
  features?: Partial<Record<GuardianFeature, boolean>>;
};

type AgentSettings = {
  piGuardian?: PiGuardianSettings;
  extensions?: {
    piGuardian?: PiGuardianSettings;
  };
};

const SETTINGS_PATH_CANDIDATES = [
  // Source execution: agent/extensions/pi-guardian/src/config.ts -> agent/settings.json
  fileURLToPath(new URL("../../../settings.json", import.meta.url)),
  // Built execution: agent/extensions/pi-guardian/dist/src/config.js -> agent/settings.json
  fileURLToPath(new URL("../../../../settings.json", import.meta.url)),
];

function readSettings(): AgentSettings {
  const settingsPath = SETTINGS_PATH_CANDIDATES.find((candidate) => fs.existsSync(candidate));
  if (!settingsPath) return {};

  try {
    return JSON.parse(fs.readFileSync(settingsPath, "utf8")) as AgentSettings;
  } catch {
    return {};
  }
}

function getPiGuardianSettings(): PiGuardianSettings | undefined {
  const settings = readSettings();
  return settings.piGuardian ?? settings.extensions?.piGuardian;
}

export function isGuardianFeatureEnabled(feature: GuardianFeature): boolean {
  const piGuardianSettings = getPiGuardianSettings();
  const features = piGuardianSettings?.features;

  const value = features?.[feature] ?? piGuardianSettings?.[feature];
  return value ?? true;
}
