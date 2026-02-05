#!/bin/bash

DEST="/mnt/SSD-4TB/Backup/XPS-9300/"
HOST="r2-d2.local"
USER="soriano"

SRC="/home/soriano"

clear

echo -e '\n\033[0;36mCopy files...\033[0m\n'

rsync -azv --delete --force -e ssh --update \
--exclude='node_modules' \
--exclude='.tmuxifier/*' \
--exclude='.dbclient/*' \
--exclude='.windsurf/*' \
--exclude='.codeium/*' \
--exclude='.mcp-hub/*' \
--exclude='.eclipse/*' \
--exclude='.mongodb/*' \
--exclude='.config/*' \
--exclude='.dotnet/*' \
--exclude='.docker/*' \
--exclude='.vscode/*' \
--exclude='.cursor/*' \
--exclude='.cache/*' \
--exclude='.local/*' \
--exclude='.cargo/*' \
--exclude='.asdf/*' \
--exclude='.tmux/*' \
--exclude='.warp/*' \
--exclude='.yarn/*' \
--exclude='.npm/*' \
--exclude='snap/*' \
--exclude='dist/*' \
--include=* $SRC $USER@$HOST:$DEST --chown=soriano:soriano

echo -e '\n\033[0;36mFinish\033[0m\n'
