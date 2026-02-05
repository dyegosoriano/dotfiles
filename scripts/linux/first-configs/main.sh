#!/bin/bash

SRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../../" &> /dev/null && pwd )"

echo -e '\n\033[0;36mConfiguring shell...\033[0m'

[ -d ~/.config/superfile ] && mv ~/.config/superfile ~/.config/superfile.backup 2>/dev/null; ln -sfn "$SRC/programs/superfile" ~/.config/superfile
[ -d ~/.config/yazi ] && mv ~/.config/yazi ~/.config/yazi.backup 2>/dev/null; ln -sfn "$SRC/programs/yazi" ~/.config/yazi
[ -d ~/.config/imv ] && mv ~/.config/imv ~/.config/imv.backup 2>/dev/null; ln -sfn "$SRC/programs/imv" ~/.config/imv

[ -d ~/.config/rmpc ] && mv ~/.config/rmpc ~/.config/rmpc.backup 2>/dev/null; ln -sfn "$SRC/programs/rmpc" ~/.config/rmpc
[ -d ~/.config/mpd ] && mv ~/.config/mpd ~/.config/mpd.backup 2>/dev/null; ln -sfn "$SRC/programs/mpd" ~/.config/mpd
[ -d ~/.config/mpv ] && mv ~/.config/mpv ~/.config/mpv.backup 2>/dev/null; ln -sfn "$SRC/programs/mpv" ~/.config/mpv

echo -e '\n\033[0;36mFinished.\033[0m'

