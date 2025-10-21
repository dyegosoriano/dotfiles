function g
  git $argv
end

function gcm
  set -l GEMINI_API_KEY $GEMINI_API_KEY
  if test -z "$GEMINI_API_KEY"
    echo "Erro: Configure GEMINI_API_KEY como variável de ambiente"
    echo "Execute: set -Ux GEMINI_API_KEY \"sua-chave-aqui\""
    return 1
  end

  set -l git_diff (git diff --staged)
  if test -z "$git_diff"
    echo "Nenhuma mudança staged para commitar"
    echo "Execute: git add <arquivos> para adicionar alterações"
    return 1
  end

  set -l prompt "Analyze this git diff and write ONLY the first line of a commit message following the Commitizen conventional commits format.

    CRITICAL RULES:
    - ONLY describe changes that are marked with + (additions) or - (deletions) in the diff
    - DO NOT mention unchanged code or context lines
    - DO NOT invent or assume features that are not explicitly added or removed
    - Use the format: <type>(<scope>): <subject>
    - Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert
    - Subject must be lowercase and not end with a period
    - Keep the first line under 72 characters
    - Focus ONLY on what was actually changed (lines with + or -)
    - Return ONLY the first line of the commit message, nothing else

    Git Diff:
    $git_diff"

  set -l response (curl -s -X POST \
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=$GEMINI_API_KEY" \
    -H "Content-Type: application/json" \
    -d (printf '{"contents":[{"parts":[{"text":%s}]}]}' (echo $prompt | jq -Rs .)))

  set -l message (echo $response | jq -r '.candidates[0].content.parts[0].text' | string trim)
  if test -z "$message"
    echo "Erro: não foi possível gerar a mensagem de commit"
    return 1
  end

  commandline "git commit -m \"$message\""
end

