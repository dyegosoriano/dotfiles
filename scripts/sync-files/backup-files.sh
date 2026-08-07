#!/bin/bash

DEST="/mnt/SSD-4TB/Backup/XPS-9300/"
HOST="r2-d2.local"
USER="soriano"

SRC="/home/soriano/"

clear

echo -e '\n\033[0;36mCopy files...\033[0m\n'

rsync -azv --delete --delete-excluded --force -e ssh --update \
  --exclude='/Documents/**/node_modules/***' \
  --exclude='/Documents/**/dist/***' \
  --include='/Documents/***' \
  --include='/Downloads/***' \
  --include='/Pictures/***' \
  --include='/Music/***' \
  --exclude='*' \
  "$SRC" "$USER@$HOST:$DEST" --chown=soriano:soriano

echo -e '\n\033[0;36mFinish\033[0m\n'
