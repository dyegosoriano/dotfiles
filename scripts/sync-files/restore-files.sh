#!/bin/bash

DEST="/mnt/SSD-4TB/Backup/XPS-9300/"
HOST="r2-d2.local"
USER="soriano"
SSH_KEY="$HOME/.ssh/xps-9300"

SRC="/home/soriano/Documentos/restore/"

clear

echo -e '\n\033[0;36mCopy files...\033[0m\n'
rsync -azv -e "ssh -i $SSH_KEY" --update --exclude='node_modules' --include=* $USER@$HOST:$DEST $SRC --chown=soriano:soriano
echo -e '\n\033[0;36mFinish\033[0m\n'
