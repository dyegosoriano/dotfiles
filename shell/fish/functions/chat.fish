function chat --description 'Faz uma pergunta e recebe explicação com comandos inseridos no terminal'
  if not set -q GEMINI_API_KEY
    echo "❌ GEMINI_API_KEY não está configurada"
    echo "💡 Configure a variável de ambiente:"
    echo "   set -Ux GEMINI_API_KEY sua-api-key-aqui"
    echo "   Obtenha sua API key em: https://makersuite.google.com/app/apikey"
    return 1
  end

  if test (count $argv) -eq 0
    echo "Uso: chat <sua pergunta>"
    echo "Exemplo: chat como listar arquivos ocultos"
    return 1
  end

  set -l question (string join " " $argv)
  echo "🤔 Processando sua pergunta: $question"
  echo ""

  set -l prompt "Responda a seguinte pergunta de forma clara e concisa em português. Se a resposta envolver comandos de terminal, coloque cada comando em um bloco de código markdown usando \`\`\`. Pergunta: $question"
  set -l escaped_prompt (string replace -a '\\' '\\\\' $prompt | string replace -a '"' '\\"' | string replace -a \n '\\n')
  set -l json_data "{\"contents\":[{\"parts\":[{\"text\":\"$escaped_prompt\"}]}]}"

  set -l response (curl -s -X POST \
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent?key=$GEMINI_API_KEY" \
    -H "Content-Type: application/json" \
    -d $json_data
  )

  if test $status -ne 0
    echo "❌ Erro ao fazer requisição para a API do Gemini"
    return 1
  end

  set -l text_response ""

  if command -v jq >/dev/null 2>&1
    set text_response (echo $response | jq -r '.candidates[0].content.parts[0].text' 2>/dev/null)
  else
    set text_response (echo $response | string match -r '"text":\s*"([^"]*)"' | string replace -r '.*"text":\s*"([^"]*)".*' '$1')
  end

  if test -z "$text_response"; or test "$text_response" = "null"
    echo "❌ Erro ao processar resposta da API"
    echo "Resposta bruta: $response"
    return 1
  end

  set -l in_command 0
  set -l commands

  for line in (string split \n $text_response)
    if string match -q '```*' $line
      if test $in_command -eq 0
        set in_command 1
      else
        set in_command 0
      end
    else if test $in_command -eq 1
      if test -n "$line"
        set -a commands (string trim $line)
        echo "📝 Comando: "(string trim $line)
      end
    else
      echo $line
    end
  end

  if test (count $commands) -gt 0
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "💡 Comandos encontrados!"

    if test (count $commands) -eq 1
      echo "Pressione Enter para inserir o comando no terminal ou Ctrl+C para cancelar"
      read -P "➜ " confirm
      commandline -r $commands[1]
    else
      echo "Selecione qual comando inserir no terminal:"
      set -l selected (printf "%s\n" $commands | fzf --prompt='Selecione o comando: ' --height=40%)
      if test -n "$selected"
        commandline -r $selected
      end
    end
  end
end

