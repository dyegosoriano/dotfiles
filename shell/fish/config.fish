if status is-interactive
  # Commands to run in interactive sessions can go here
end

# Inicializando o Starship, Zoxide e FZF
starship init fish | source
zoxide init fish | source
fzf --fish | source

# Removendo a saudação do Fish
set -g fish_greeting ""

# O bloco abaixo foi removido pois estava vazio
# if test "$TERM_PROGRAM" != "WarpTerminal"
# end

if test -d ~/.asdf # ASDF configuration
  source (brew --prefix asdf)/libexec/asdf.fish
  set -gx PATH $HOME/.asdf/installs/nodejs/(asdf current nodejs | awk '{print $2}')/.npm/bin $PATH
end

if test -z $TMUXIFIER # Set/fix Tmuxifier root path if needed.
  set -gx TMUXIFIER "$HOME/.tmuxifier"
end

if not contains "$TMUXIFIER/bin" $PATH # Add `bin` directroy to `$PATH`.
  set -gx PATH "$TMUXIFIER/bin" $PATH
end

# Se `tmuxifier` estiver disponível, e `$TMUXIFIER_NO_COMPLETE` não estiver definido, então carregue a conclusão de shell do Tmuxifier.
if test -n (which tmuxifier); and test -z $TMUXIFIER_NO_COMPLETE
  # A verificação da versão do Fish é obsoleta, a linha abaixo foi removida e a sintaxe foi corrigida para usar o comando `source`.
  source "$TMUXIFIER/completion/tmuxifier.fish"
end

# Força o carregamento de todas as funções personalizadas
for file in ~/.dotfiles/shell/fish/functions/*.fish
  source $file
end

# Enable the `brew` key bindings
set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
set -gx HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar"
set -gx HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew"

fish_add_path -gP "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"

set -q MANPATH; or set MANPATH ''
set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH
set -q INFOPATH; or set INFOPATH ''
set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH

export FZF_DEFAULT_OPTS="--walker-skip .git,node_modules,dist --layout reverse --border top --height 40% --style full"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
export FZF_CTRL_T_OPTS="--preview 'bat -n color=always {}'"
