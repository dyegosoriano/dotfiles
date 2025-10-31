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

  set -l response (
    curl -s -X POST \
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=$GEMINI_API_KEY" \
    -H "Content-Type: application/json" \
    -d (printf '{"contents":[{"parts":[{"text":%s}]}]}' (echo $prompt | jq -Rs .))
  )

  set -l message (echo $response | jq -r '.candidates[0].content.parts[0].text' | string trim)
  if test -z "$message"
    echo "Erro: não foi possível gerar a mensagem de commit"
    return 1
  end

  commandline "git commit -m \"$message\""
end

function gbranch --description "Navegar, selecionar e manipular branches com fzf"
  set action (
    printf "checkout\ncriar nova branch a partir\nmerge na atual\nrebase na atual\ndeletar branch(es)" \
    | fzf --prompt="Escolha a ação: "
  )

  if test -z "$action"
    echo "Nenhuma ação selecionada."
    return
  end

  switch $action
    case checkout
      set branch (
        git branch -a --color=always | sed 's/^..//' | fzf \
        --preview "git log --oneline --decorate --color=always --graph --date=short -n 20 {}" \
        --prompt="Selecione a branch para checkout: " \
        --ansi
      )

      if test -n "$branch"
        set clean_branch (echo $branch | sed 's#remotes/##')
        git checkout $clean_branch
      end

    case "criar nova branch a partir"
      set branch (
        git branch -a --color=always | sed 's/^..//' | fzf \
        --preview "git log --oneline --decorate --color=always --graph --date=short -n 20 {}" \
        --prompt="Selecione a branch base: " \
        --ansi
      )

      if test -n "$branch"
        set clean_branch (echo $branch | sed 's#remotes/##')
        read -P "Digite o nome da nova branch: " newbranch
        if test -n "$newbranch"
          git checkout -b $newbranch $clean_branch
        end
      end

    case "merge na atual"
      set branch (
        git branch -a --color=always | sed 's/^..//' | fzf \
        --preview "git log --oneline --decorate --color=always --graph --date=short -n 20 {}" \
        --prompt="Selecione a branch para merge: " \
        --ansi
      )

      if test -n "$branch"
        set clean_branch (echo $branch | sed 's#remotes/##')
        git merge $clean_branch
      end

    case "rebase na atual"
      set branch (
        git branch -a --color=always | sed 's/^..//' | fzf \
        --preview "git log --oneline --decorate --color=always --graph --date=short -n 20 {}" \
        --prompt="Selecione a branch para rebase: " \
        --ansi
      )

      if test -n "$branch"
        set clean_branch (echo $branch | sed 's#remotes/##')
        git rebase $clean_branch
      end

    case "deletar branch(es)"
      set branches (
        git branch -a --color=always | sed 's/^..//' | fzf \
        --preview "git log --oneline --decorate --color=always --graph --date=short -n 20 {}" \
        --prompt="Selecione branch(es) para deletar: " \
        --multi \
        --ansi
      )

      if test -n "$branches"
        set current_branch (git rev-parse --abbrev-ref HEAD)
        for branch in $branches
          set clean_branch (echo $branch | sed 's#remotes/##')
          if test "$clean_branch" != "$current_branch"
            git branch -d $clean_branch
          else
            echo "⚠️ Não é possível deletar a branch atual: $clean_branch"
          end
        end
      end
  end
end

function gchist --description "Navegar e interagir com histórico de commits usando fzf"
  set commits (
    git log --oneline --all --decorate --color=always \
    --preview "echo {} | awk '{print \$1}' | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'" \
    --pretty=format:'%C(auto)%h %C(blue)%an %C(yellow)%ad %Creset%s' \
    --date=short | fzf \
    --multi \
    --ansi
  )

  if test -z "$commits"
    echo "Nenhum commit selecionado."
    return
  end

  # Extrai apenas os hashes dos commits selecionados
  set hashes (
    for line in $commits
      echo $line | awk '{print $1}'
    end
  )

  echo "Commits selecionados: $hashes"

  # Menu de ações
  set action (
    printf "checkout\nreset --soft\nreset --mixed\nreset --hard\ncherry-pick\nrebase -i\ncopiar hash para linha de comando" \
    | fzf --prompt="Escolha a ação: "
  )

  switch $action
    case checkout
      git checkout $hashes[1]

    case "reset --soft"
      git reset --soft $hashes[1]

    case "reset --mixed"
      git reset --mixed $hashes[1]

    case "reset --hard"
      git reset --hard $hashes[1]

    case cherry-pick
      git cherry-pick $hashes

    case "rebase -i"
      git rebase -i $hashes[1]

    case "copiar hash para linha de comando"
      commandline -i $hashes[1]
  end
end

function gstage --description "Gerenciar staging do git de forma interativa"
  set action (
    printf "stage (git add)\nunstage (git reset)\ndiscard (git restore)" \
    | fzf --prompt="Escolha a ação: "
  )

  switch $action
    case "stage (git add)"
      set files (
        git status --porcelain | awk '{print $2}' | fzf \
        --preview 'git diff --color=always -- {}' \
        --preview-window=up:70%:wrap \
        --multi
      )

      if test -n "$files"
        git add $files
        echo "✅ Arquivos adicionados: $files"
      end

    case "unstage (git reset)"
      set files (
        git diff --name-only --staged | fzf \
        --preview 'git diff --staged --color=always -- {}' \
        --preview-window=up:70%:wrap \
        --multi
      )

      if test -n "$files"
        git reset $files
        echo "↩️ Arquivos removidos do staging: $files"
      end

    case "discard (git restore)"
      set files (
        git status --porcelain | grep "^ M" | awk '{print $2}' | fzf \
        --preview 'git diff --color=always -- {}' \
        --preview-window=up:70%:wrap \
        --multi
      )

      if test -n "$files"
        read -P "⚠️ Tem certeza que deseja descartar alterações em: $files ? (y/N) " confirm
        if test "$confirm" = y
          git restore $files
          echo "🗑️ Alterações descartadas: $files"
        end
      end
  end
end

function gstash --description "Gerenciamento interativo de git stash"
  set action (
    printf "apply\npop\ndelete" \
    | fzf --prompt="Escolha a ação: "
  )

  switch $action
    case apply
      set stash (git stash list | fzf --preview 'echo {} | cut -d: -f1 | xargs git stash show -p --color=always')

      if test -n "$stash"
        set stash_id (echo $stash | cut -d: -f1)
        git stash apply $stash_id
        echo "✅ Aplicado: $stash_id"
      end

    case pop
      set stash (git stash list | fzf --preview 'echo {} | cut -d: -f1 | xargs git stash show -p --color=always')

      if test -n "$stash"
        set stash_id (echo $stash | cut -d: -f1)
        git stash pop $stash_id
        echo "📦 Pop realizado: $stash_id"
      end

    case delete
      set stashes (git stash list | fzf --multi --preview 'echo {} | cut -d: -f1 | xargs git stash show -p --color=always')

      if test -n "$stashes"
        for s in $stashes
          set stash_id (echo $s | cut -d: -f1)
          git stash drop $stash_id
          echo "🗑️ Removido: $stash_id"
        end
      end
  end
end
