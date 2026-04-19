#!/bin/bash

SRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../../" &> /dev/null && pwd )"

echo -e '\n\033[0;36mConfiguring shell...\033[0m'

# HISTORY
[ -f "$HOME/.local/share/fish/fish_history" ] && mv "$HOME/.local/share/fish/fish_history" "$HOME/.local/share/fish/fish_history.backup" 2>/dev/null; ln -sfn "$SRC/backup/fish_history" "$HOME/.local/share/fish/fish_history"
[ -f $HOME/.bash_history ] && mv $HOME/.bash_history $HOME/.bash_history.backup 2>/dev/null; ln -sfn "$SRC/backup/bash_history" $HOME/.bash_history

# # TOOLS
[ -d "$HOME/.config/television" ] && mv "$HOME/.config/television" "$HOME/.config/television.backup" 2>/dev/null; ln -sfn "$SRC/programs/television" "$HOME/.config/television"

# FILES
[ -d "$HOME/.config/superfile" ] && mv "$HOME/.config/superfile" "$HOME/.config/superfile.backup" 2>/dev/null; ln -sfn "$SRC/programs/superfile" "$HOME/.config/superfile"
[ -d "$HOME/.config/yazi" ] && mv "$HOME/.config/yazi" "$HOME/.config/yazi.backup" 2>/dev/null; ln -sfn "$SRC/programs/yazi" "$HOME/.config/yazi"

# TERMINAL
[ -d "$HOME/.config/alacritty" ] && mv "$HOME/.config/alacritty" "$HOME/.config/alacritty.backup" 2>/dev/null; ln -sfn "$SRC/programs/alacritty" "$HOME/.config"
[ -d "$HOME/.config/ghostty" ] && mv "$HOME/.config/ghostty" "$HOME/.config/ghostty.backup" 2>/dev/null; ln -sfn "$SRC/programs/ghostty" "$HOME/.config"
[ -d "$HOME/.config/kitty" ] && mv "$HOME/.config/kitty" "$HOME/.config/kitty.backup" 2>/dev/null; ln -sfn "$SRC/programs/kitty" "$HOME/.config"

# MEDIA
[ -d "$HOME/.config/rmpc" ] && mv "$HOME/.config/rmpc" "$HOME/.config/rmpc.backup" 2>/dev/null; ln -sfn "$SRC/programs/rmpc" "$HOME/.config/rmpc"
[ -d "$HOME/.config/mpd" ] && mv "$HOME/.config/mpd" "$HOME/.config/mpd.backup" 2>/dev/null; ln -sfn "$SRC/programs/mpd" "$HOME/.config/mpd"
[ -d "$HOME/.config/mpv" ] && mv "$HOME/.config/mpv" "$HOME/.config/mpv.backup" 2>/dev/null; ln -sfn "$SRC/programs/mpv" "$HOME/.config/mpv"
[ -d "$HOME/.config/imv" ] && mv "$HOME/.config/imv" "$HOME/.config/imv.backup" 2>/dev/null; ln -sfn "$SRC/programs/imv" "$HOME/.config/imv"

# DEVELOPMENT
[ -f "$HOME/.gitconfig" ] && mv "$HOME/.gitconfig" "$HOME/.gitconfig.backup" 2>/dev/null; ln -sfn "$SRC/programs/git/gitconfig" "$HOME/.gitconfig"
[ -d "$HOME/.config/git" ] && mv "$HOME/.config/git" "$HOME/.config/git.backup" 2>/dev/null; ln -sfn "$SRC/programs/git" "$HOME/.config/git"

# SHELL
[ -f "$HOME/.config/tmux/tmux.conf" ] && mv "$HOME/.config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf.backup" 2>/dev/null; ln -sfn "$SRC/programs/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
[ -f "$HOME/.bash_aliases" ] && mv "$HOME/.bash_aliases" "$HOME/.bash_aliases.backup" 2>/dev/null; ln -sfn "$SRC/shell/bash/aliases" "$HOME/.bash_aliases"
[ -d "$HOME/.config/tmux" ] && mv "$HOME/.config/tmux" "$HOME/.config/tmux.backup" 2>/dev/null; ln -sfn "$SRC/programs/tmux" "$HOME/.config/tmux"
[ -d "$HOME/.config/fish" ] && mv "$HOME/.config/fish" "$HOME/.config/fish.backup" 2>/dev/null; ln -sfn "$SRC/shell/fish" "$HOME/.config/fish"
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.backup" 2>/dev/null; ln -sfn "$SRC/shell/zsh/zshrc" "$HOME/.zshrc"

# EDITOR
[ -d ~/.config/zed ] && mv ~/.config/zed ~/.config/zed.backup 2>/dev/null; ln -sfn "$SRC/programs/zed" ~/.config/zed

echo -e '\n\033[0;36mFinished.\033[0m'
