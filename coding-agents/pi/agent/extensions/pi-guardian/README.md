# pi-guardian

Extensão/camada do PI Agent para bloquear acesso a arquivos sensíveis por padrões configuráveis.

## Feature flags

Ative/desative guardas somente em `@coding-agents/pi/agent/settings.json`:

```json
{
  "piGuardian": {
    "features": {
      "file": true,
      "path": true,
      "gitignore": true
    }
  }
}
```

Use `false` para desativar uma camada sem remover a extensão.

## API

```ts
import { assertFileAccessAllowed, FileGuardError, BLOQUED_FILES, isBlockedFile } from "./src/guard-file";
```

> O nome `BLOQUED_FILES` é intencional e faz parte do contrato da extensão.

## Estrutura modular

- `src/constants/guardian-constants.ts` — padrões e comandos configuráveis
- `src/errors/file-guard-error.ts` — erro customizado de bloqueio de arquivos
- `src/errors/path-guard-error.ts` — erro customizado de bloqueio de diretórios
- `src/operations/guard-operations.ts` — tipos/regras de operação (`list`, `read`, etc.)
- `src/utils/path-utils.ts` — normalização de caminhos e tokens
- `src/utils/pattern-matcher.ts` — interpretação de `*` e matching
- `src/utils/bash-utils.ts` — extração/classificação de comandos shell
- `src/utils/tool-inputs.ts` — leitura segura de inputs das tools
- `src/guard-file.ts` — regra pública de bloqueio de arquivos
- `src/guard-path.ts` — regra pública de bloqueio de diretórios sensíveis

Essa separação permite reaproveitar utilitários em futuras features, como bloqueio de diretórios.

Com as feature flags no `settings.json` você pode desligar só uma camada sem remover a extensão.

## Exemplos de uso

```ts
isBlockedFile("/home/me/.ssh/id_rsa"); // true
isBlockedFile("certs/server.pem"); // true
isBlockedFile(".env.local"); // true
isBlockedFile("README.md"); // false

assertFileAccessAllowed("private.key", "list"); // ok: pode listar o item
assertFileAccessAllowed("private.key", "read"); // lança FileGuardError: não pode ler conteúdo
assertFileAccessAllowed("README.md"); // ok
```

Operações `list` são permitidas para que o PI Agent consiga mostrar que o arquivo existe. Operações de conteúdo (`read`, `write`, `edit`, `process`) continuam bloqueadas.

Erro lançado:

```ts
throw new FileGuardError(`Access denied by pi-guardian: ${filePath}`);
```

## Instalação no PI Agent

Esta pasta está em um local auto-descoberto pelo PI Agent:

```txt
~/.pi/agent/extensions/pi-guardian/index.ts
```

Use `/reload` no PI Agent para recarregar extensões.

## Testes

```bash
cd ~/.pi/agent/extensions/pi-guardian
npm install
npm test
```
