if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source # Inicializando o Starship
set -g fish_greeting "" # Removendo a saudação do Fish

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

# Importando alias
if test -f ~/.bash_aliases
    for line in (cat ~/.bash_aliases | grep -E "^alias " | sed -E "s/^alias ([a-zA-Z0-9_-]+)='(.*)'/\1 \2/")
        set alias_name (echo $line | cut -d ' ' -f1)
        set alias_cmd (echo $line | cut -d ' ' -f2-)
        abbr -a $alias_name $alias_cmd
    end
end
