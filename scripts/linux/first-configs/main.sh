#!/bin/bash

SRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../../" &> /dev/null && pwd )"

echo -e '\n\033[0;36mConfiguring shell...\033[0m'

# HISTORY
[ -f ~/.local/share/fish/fish_history ] && mv ~/.local/share/fish/fish_history ~/.local/share/fish/fish_history.backup 2>/dev/null; ln -sfn "$SRC/backup/fish_history" ~/.local/share/fish/fish_history
[ -f ~/.bash_history ] && mv ~/.bash_history ~/.bash_history.backup 2>/dev/null; ln -sfn "$SRC/backup/bash_history" ~/.bash_history
[ -f ~/.bash_aliases ] && mv ~/.bash_aliases ~/.bash_aliases.backup 2>/dev/null; ln -sfn "$SRC/shell/bash/aliases" ~/.bash_aliases

# # TOOLS
[ -d ~/.config/television ] && mv ~/.config/television ~/.config/television.backup 2>/dev/null; ln -sfn "$SRC/programs/television" ~/.config/television
[ -f ~/.config/tmux/tmux.conf ] && mv ~/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf.backup 2>/dev/null; ln -sfn "$SRC/programs/tmux/tmux.conf" ~/.config/tmux/tmux.conf
[ -f ~/.tmux.conf ] && mv ~/.tmux.conf ~/.tmux.conf.backup 2>/dev/null; ln -sfn "$SRC/programs/tmux/tmux.conf" ~/.tmux.conf

# FILES
[ -d ~/.config/superfile ] && mv ~/.config/superfile ~/.config/superfile.backup 2>/dev/null; ln -sfn "$SRC/programs/superfile" ~/.config/superfile
[ -d ~/.config/yazi ] && mv ~/.config/yazi ~/.config/yazi.backup 2>/dev/null; ln -sfn "$SRC/programs/yazi" ~/.config/yazi

TERMINAL
[ -d ~/.config/alacritty ] && mv ~/.config/alacritty ~/.config/alacritty.backup 2>/dev/null; ln -sfn "$SRC/programs/alacritty" ~/.config
[ -d ~/.config/ghostty ] && mv ~/.config/ghostty ~/.config/ghostty.backup 2>/dev/null; ln -sfn "$SRC/programs/ghostty" ~/.config
[ -d ~/.config/kitty ] && mv ~/.config/kitty ~/.config/kitty.backup 2>/dev/null; ln -sfn "$SRC/programs/kitty" ~/.config

# MEDIA
[ -d ~/.config/rmpc ] && mv ~/.config/rmpc ~/.config/rmpc.backup 2>/dev/null; ln -sfn "$SRC/programs/rmpc" ~/.config/rmpc
[ -d ~/.config/mpd ] && mv ~/.config/mpd ~/.config/mpd.backup 2>/dev/null; ln -sfn "$SRC/programs/mpd" ~/.config/mpd
[ -d ~/.config/mpv ] && mv ~/.config/mpv ~/.config/mpv.backup 2>/dev/null; ln -sfn "$SRC/programs/mpv" ~/.config/mpv
[ -d ~/.config/imv ] && mv ~/.config/imv ~/.config/imv.backup 2>/dev/null; ln -sfn "$SRC/programs/imv" ~/.config/imv

# DEVELOPMENT
[ -f ~/.gitconfig ] && mv ~/.gitconfig ~/.gitconfig.backup 2>/dev/null; ln -sfn "$SRC/programs/git/gitconfig" ~/.gitconfig
[ -d ~/.config/git ] && mv ~/.config/git ~/.config/git.backup 2>/dev/null; ln -sfn "$SRC/programs/git" ~/.config/git

echo -e '\n\033[0;36mFinished.\033[0m'
