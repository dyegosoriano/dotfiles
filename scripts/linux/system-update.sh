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
else
  echo -e '\n\033[0;36mSnap not found. Skipping update of Snap and Snap apps....\033[0m\n'
fi

# Remove imagens do Docker inutilizadas
echo -e '\n\033[0;36mRemoving unused Docker images...\033[0m\n'
docker image prune -a --force

echo -e '\n\033[0;36mUpdate and cleaning done!\033[0m\n'