#!/bin/bash

DEST="/mnt/SSD-4TB/Backup/XPS-9300/"
SSH_KEY="$HOME/.ssh/xps-9300"
HOST="r2-d2.local"
USER="soriano"

SRC="/home/soriano/"

clear

echo -e '\n\033[0;36mCopy files...\033[0m\n'

rsync -azv --delete --delete-excluded --force -e "ssh -i $SSH_KEY" --update \
  --exclude='/Documents/**/.docker/data/***' \
  --exclude='/Documents/**/node_modules/***' \
  --exclude='/Documents/**/.angular/***' \
  --exclude='/Documents/**/.next/***' \
  --exclude='/Documents/**/dist/***' \
  --include='/Documents/***' \
  --include='/Downloads/***' \
  --include='/.dotfiles/***' \
  --include='/Pictures/***' \
  --include='/Music/***' \
  --exclude='/.pi/**/node_modules/***' \
  --include='/.pi/***' \
  --exclude='*' \
  "$SRC" "$USER@$HOST:$DEST" --chown=soriano:soriano

echo -e '\n\033[0;36mFinish\033[0m\n'
