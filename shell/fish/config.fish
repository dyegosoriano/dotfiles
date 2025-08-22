if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source # Inicializando o Starship
zoxide init fish | source # Inicializando o Zoxide
fzf --fish | source # Inicializando o FZF

set -g fish_greeting "" # Removendo a saudação do Fish

if test "$TERM_PROGRAM" != "WarpTerminal"
end

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

# If `tmuxifier` is available, and `$TMUXIFIER_NO_COMPLETE` is not set, then
# load Tmuxifier shell completion.
if test -n (which tmuxifier); and test -z $TMUXIFIER_NO_COMPLETE
  if [ (fish --version 2>| awk -F'version ' '{print $2}') = '2.0.0' ]; # fish shell 2.0.0 does not have the source alias
    . "$TMUXIFIER/completion/tmuxifier.fish"
  else
    source "$TMUXIFIER/completion/tmuxifier.fish"
  end
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

export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
export FZF_CTRL_T_OPTS="--preview 'bat -n color=always {}'"

export FZF_DEFAULT_OPTS='
  --walker-skip .git,node_modules,dist
  --layout reverse
  --border top
  --height 40%
  --style full
'