function mktouch
  # Desabilita brace expansion temporariamente para evitar interpretação automática do shell
  set -l old_brace_expand $fish_brace_expansion
  set -g fish_brace_expansion 0

  set -l input (string join ' ' $argv)

  # Restaura a configuração original
  set -g fish_brace_expansion $old_brace_expand

  # VALIDAÇÃO: Verifica se todos os padrões {**} contêm vírgula
  for match in (string match -r -a '\{[^}]*\}' -- $input)
    if not string match -q -r ',' -- $match
      echo "❌ Erro: O padrão $match precisa ter ao menos uma vírgula"
      return 1
    end
  end

  # EXTRAÇÃO DE ARQUIVOS: Identifica o último segmento (nome do arquivo) e extensão
  set -l last_segment (string match -r '/([^/]+)\.[^/]*$' -- $input)
  set -l extension (string match -r '\.[^\/]*$' -- $input)
  set -l multiple_files

  # Processa nomes de arquivos com padrões {file1,file2} ou arquivo único
  if test -n "$last_segment"
    set last_segment (string replace -r '^/' '' -- $last_segment[2])

    if string match -q -r '^\{.*\}$' -- $last_segment
      # Extrai múltiplos nomes: {app,config} → ["app", "config"]
      set -l content (string match -r '\{([^}]+)\}' -- $last_segment)
      set multiple_files (string split ',' -- $content[2])
    else
      # Arquivo único
      set multiple_files $last_segment
    end
  end

  # EXTRAÇÃO DE PASTAS: Separa caminho base dos padrões de pastas
  set -l path_only (string replace -r '/[^/]+\.[^/]*$' '' -- $input)
  set -l folder_patterns_part ""
  set -l base_path ""

  # Divide entre caminho fixo e padrões com chaves
  set -l first_pattern_pos (string match -r '^([^{]*)(.*\{[^}]*\}.*)$' -- $path_only)

  if test -n "$first_pattern_pos"
    set folder_patterns_part $first_pattern_pos[3]  # Parte com padrões {src,test}
    set base_path $first_pattern_pos[2]             # Caminho base fixo
  else
    set base_path $path_only
  end

  # PROCESSAMENTO RECURSIVO: Expande padrões aninhados de pastas
  function _process_folder_patterns -a pattern_string
    # Caso base: sem mais padrões, retorna o caminho limpo
    if not string match -q -r '\{[^}]*\}' -- $pattern_string
      if test -n "$pattern_string"
        set pattern_string (string replace -r '^/' '' -- $pattern_string)
        set pattern_string (string replace -r '/$' '' -- $pattern_string)
        if test -n "$pattern_string"
          echo "$pattern_string"
        end
      end
      return
    end

    # Encontra o primeiro padrão {opção1,opção2} e processa recursivamente
    set -l match (string match -r '^([^{]*)\{([^}]+)\}(.*)$' -- $pattern_string)

    if test -n "$match"
      set -l options (string split ',' -- $match[3])  # ["src", "test"]
      set -l suffix $match[4]                         # Resto do padrão
      set -l prefix $match[2]                         # Prefixo antes do padrão

      # Para cada opção, combina com o restante recursivamente
      for option in $options
        set -l current_path ""
        if test -n "$prefix"
          set current_path "$prefix/$option"
        else
          set current_path "$option"
        end

        # Processa o restante do padrão recursivamente
        set -l sub_patterns (_process_folder_patterns $suffix)
        if test -n "$sub_patterns"
          for sub_pattern in $sub_patterns
            echo "$current_path/$sub_pattern"
          end
        else
          echo "$current_path"
        end
      end
    end
  end

  # CRIAÇÃO FINAL: Combina todas as pastas com todos os arquivos
  set -l multiple_folders
  if test -n "$folder_patterns_part"
    set multiple_folders (_process_folder_patterns $folder_patterns_part)
  end

  # Cria cada combinação pasta/arquivo
  for folder in $multiple_folders
    for file in $multiple_files
      mkdir -p "$base_path$folder"              # Cria diretório
      touch "$base_path$folder/$file$extension" # Cria arquivo
    end
  end
end

function mkd
  command mkdir -pv $argv
end
