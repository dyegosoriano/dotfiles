if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source

# Adicione asdf ao caminho
set -x PATH $HOME/.asdf/bin $PATH
set -x PATH $HOME/.asdf/shims $PATH

# Inicializar asdf
source ~/.asdf/asdf.fish

# Inportando alias
if test -f ~/.bash_aliases
    for line in (cat ~/.bash_aliases | grep -E "^alias " | sed -E "s/^alias ([a-zA-Z0-9_-]+)='(.*)'/\1 \2/")
        set alias_name (echo $line | cut -d ' ' -f1)
        set alias_cmd (echo $line | cut -d ' ' -f2-)
        abbr -a $alias_name $alias_cmd
    end
end

