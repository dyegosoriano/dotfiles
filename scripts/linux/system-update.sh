#!/bin/bash

# Atualiza o sistema Linux
echo -e '\n\033[0;36mUpdating the system...\033[0m\n'
sudo apt update
sudo apt upgrade -y

# Limpa o cache do apt
echo -e "\n\033[0;36mClearing apt's cache...\033[0m\n"
sudo apt autoclean
sudo apt autoremove -y

# Verifica se o Snap está instalado
if [ -x "$(command -v snap)" ]; then
  # Atualiza o Snap
  echo -e '\n\033[0;36mUpdating Snap...\033[0m\n'
  sudo snap refresh

  # Atualiza os aplicativos do Snap
  echo -e '\n\033[0;36mUpdating Snap apps...\033[0m\n'
  sudo snap refresh --list | awk '{print $1}' | xargs -n1 snap refresh

  # Faz a limpeza do cache.
  sudo rm -rf /var/cache/snapd
else
  echo -e '\n\033[0;36mSnap not found. Skipping update of Snap and Snap apps....\033[0m\n'
fi

# Verifica se o Homebrew está instalado
if [ -x "$(command -v brew)" ]; then
  # Atualiza o Homebrew
  echo -e '\n\033[0;36mUpdating Homebrew...\033[0m\n'
  brew update --auto-update

  # Atualiza os aplicativos do Homebrew
  echo -e '\n\033[0;36mUpdating Homebrew apps...\033[0m\n'
  brew upgrade

  # Faz a limpeza de dependências que não estão mais em uso.
  echo -e '\n\033[0;36mCleaning up Homebrew dependencies...\033[0m\n'
  brew autoremove && brew cleanup --prune=all
else
  echo -e '\n\033[0;36mHomebrew not found. Skipping update of Homebrew and Homebrew apps....\033[0m\n'
fi

DIR="$HOME/.tmuxifier"
if [ -d "$DIR" ]; then
  echo -e '\n\033[0;36mUpdating Tmuxifier...\033[0m\n'
  cd "$DIR" && git pull && cd
fi

# Remove imagens do Docker inutilizadas
echo -e '\n\033[0;36mRemoving unused Docker images an volumes...\033[0m\n'
docker image prune -a --force && docker volume prune -a --force

echo -e '\n\033[0;36mClearing build cache......\033[0m\n'
docker builder prune -f

echo -e '\n\033[0;36mUpdate and cleaning done!\033[0m\n'
