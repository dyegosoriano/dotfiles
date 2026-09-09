#!/bin/bash

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../" &> /dev/null && pwd)"

echo -e '\n\033[0;36mConfiguring desktop...\033[0m'

bash "$SRC/scripts/linux/desktop/shortcuts.sh"

echo -e '\n\033[0;36mFinished.\033[0m'
