if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source # Inicializando o Starship
set -g fish_greeting "" # Removendo a saudação do Fish

if test -d ~/.asdf # ASDF configuration
    if not contains $_asdf_shims $PATH
        set -gx --prepend PATH $_asdf_shims
    end

    set --erase _asdf_shims
end

if test -f ~/.bash_aliases # Importando alias
    for line in (cat ~/.bash_aliases | grep -E "^alias " | sed -E "s/^alias ([a-zA-Z0-9_-]+)='(.*)'/\1 \2/")
        set alias_name (echo $line | cut -d ' ' -f1)
        set alias_cmd (echo $line | cut -d ' ' -f2-)
        abbr -a $alias_name $alias_cmd
    end
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
