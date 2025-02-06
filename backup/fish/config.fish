if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source

# Adicione asdf ao caminho
set -x PATH $HOME/.asdf/bin $PATH
set -x PATH $HOME/.asdf/shims $PATH

# Inicializar asdf
source ~/.asdf/asdf.fish
