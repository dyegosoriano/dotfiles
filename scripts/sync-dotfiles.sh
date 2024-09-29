#!/bin/bash

HOST="r2-d2.local"
USER="soriano"

SRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" &> /dev/null && pwd )" # Diretório local
DEST="/home/soriano/" # Diretório destinio

clear

echo -e '\n\033[0;36mChanging permissions for directory files...\033[0m\n'
ssh $USER@$HOST "sudo chmod -R 777 $DEST/my-containers/data/"

echo -e '\n\033[0;36mCopy files...\033[0m\n'
rsync -azv -e ssh --update --delete --exclude=rxamples/* --include=* $SRC $USER@$HOST:$DEST --chown=soriano:soriano

echo -e '\n\033[0;36mFinish\033[0m\n'
