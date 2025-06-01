#!/bin/bash

DEST="/mnt/SSD-4TB/Backup/XPS-9300/"
HOST="r2-d2.local"
USER="soriano"

SRC="/home/soriano"

clear

echo -e '\n\033[0;36mCopy files...\033[0m\n'

rsync -azv --delete -e ssh --update \
--exclude='node_modules' \
--exclude='.config/*' \
--exclude='.cache/*' \
--exclude='.asdf/*' \
--include=* $SRC $USER@$HOST:$DEST --chown=soriano:soriano

echo -e '\n\033[0;36mFinish\033[0m\n'
