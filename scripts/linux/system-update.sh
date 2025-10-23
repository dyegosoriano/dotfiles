#!/usr/bin/env bash

GREEN='\033[0;32m'
BLUE='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# CONFIGURAÇÃO
set -e # Se qualquer comando falhar, o script será encerrado imediatamente

# 1. Atualização do Sistema (APT)
if command -v apt &> /dev/null; then
  echo -e "\n${BLUE}>>> Atualizando o sistema (APT)...${NC}\n"
  sudo apt update && sudo apt upgrade -y

  echo -e "\n${BLUE}>>> Limpando cache do APT...${NC}\n"
  sudo apt autoclean && sudo apt autoremove -y
fi

# 2. Atualização do SNAP
if command -v snap &> /dev/null; then
  echo -e "\n${BLUE}>>> Atualizando Snap e aplicativos Snap...${NC}\n"
  sudo snap refresh
fi

# 3. Atualização do HOMEBREW
if command -v brew &> /dev/null; then
  echo -e "\n${BLUE}>>> Atualizando Homebrew e aplicativos Homebrew...${NC}\n"
  brew update --auto-update && brew upgrade

  echo -e "\n${BLUE}>>> Limpando dependências do Homebrew...${NC}\n"
  brew autoremove && brew cleanup --verbose
fi

# 4. Atualização de Plugins ASDF
if command -v asdf &> /dev/null; then
  echo -e "\n${BLUE}>>> Atualizando plugins do ASDF...${NC}\n"
  asdf plugin update --all
fi

# 5. Atualização do TMUXIFIER
TMUXIFIER_DIR="$HOME/.tmuxifier"
if [ -d "$TMUXIFIER_DIR" ]; then
  echo -e "\n${BLUE}>>> Atualizando Tmuxifier...${NC}\n"
  (cd "$TMUXIFIER_DIR" && git pull)
fi

# 6. Limpeza do DOCKER
if command -v docker &> /dev/null; then
  echo -e "\n${BLUE}>>> Removendo imagens, volumes e cache de build do Docker não utilizados...${NC}\n"
  docker image prune -a --force && docker volume prune -a --force && docker builder prune -f
fi

echo -e "\n${GREEN}*** Update e limpeza concluídos! ✨ ***${NC}\n"
