#!/bin/bash

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../" &> /dev/null && pwd)"

echo -e '\n\033[0;36mUpdating system...\033[0m'
sudo apt update && sudo apt upgrade -y

echo -e '\n\033[0;36mInstalling programs...\033[0m'
sudo apt install neovim ripgrep zoxide fish tmux eza fzf git bat -y
bash -c "$(curl -sLo- https://superfile.dev/install.sh)"
curl -sS https://starship.rs/install.sh | sh

echo -e '\n\033[0;36mConfiguring server...\033[0m'

bash "$SRC/scripts/linux/server/shortcuts.sh"

chsh -s "$(command -v bash)" # Keep bash as login shell for SSH; .bash_profile starts fish interactively

echo -e '\n\033[0;36mFinished.\033[0m'
