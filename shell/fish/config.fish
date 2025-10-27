if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Inicializando o Starship, Zoxide e FZF
starship init fish | source
zoxide init fish | source
fzf --fish | source

# Removendo a saudação do Fish
set -g fish_greeting ""

# Set/fix Tmuxifier root path if needed
if test -z $TMUXIFIER
    set -gx TMUXIFIER "$HOME/.tmuxifier"
end

# Add `bin` directory to `$PATH`
if not contains "$TMUXIFIER/bin" $PATH
    set -gx PATH "$TMUXIFIER/bin" $PATH
end

# Se `tmuxifier` estiver disponível, e `$TMUXIFIER_NO_COMPLETE` não estiver definido, então carregue a conclusão de shell do Tmuxifier
if test -n (which tmuxifier 2>/dev/null); and test -z $TMUXIFIER_NO_COMPLETE
    source "$TMUXIFIER/completion/tmuxifier.fish"
end

# Força o carregamento de todas as funções personalizadas
if test -d ~/.dotfiles/shell/fish/functions
    for file in ~/.dotfiles/shell/fish/functions/*.fish
        source $file
    end
end

# Configurações do FZF
set -gx FZF_DEFAULT_OPTS "--walker-skip .git,node_modules,dist --layout reverse --border top --height 40% --style full"
set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200'"
set -gx FZF_CTRL_T_OPTS "--preview 'bat -n color=always {}'"
