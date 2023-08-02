#!/bin/bash

echo -e '\n\033[0;36mRemoving the .gitconfig .zshrc files\033[0m\n'
rm -rf ~/.gitconfig
rm -rf ~/.zshrc

echo -e '\n\033[0;36mCreating shortcuts of files .bash_aliases .gitconfig .zshrc\033[0m\n'
ln -s ~/.dotfiles/.bash_aliases ~/.bash_aliases
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.zshrc ~/.zshrc

# Atualizar sistema
echo -e '\n\033[0;36mUpdating system\033[0m\n'
sudo apt update
sudo apt upgrade -y

# Instalar DOCKER e DOCKER COMPOSE
echo -e '\n\033[0;36mInstalling DOCKER and DOCKER COMPOSE\033[0m\n'
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker

# Adicionar o usuário $USER no grupo de usuários para executar o docker sem o sudo
echo -e '\n\033[0;36mAdding user $USER in usergroup to run docker without sudo\033[0m\n'
sudo usermod -aG docker ${USER}
sudo su - ${USER}
groups
sudo usermod -aG docker username

# Instalar ASDF
echo -e '\n\033[0;36mInstalling ASDF\033[0m\n'
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"

# Instalar Yarn
echo -e '\n\033[0;36mInstalling Yarn using ASDF\033[0m\n'
asdf plugin-add yarn
asdf install yarn latest

# Instalar NodeJS
echo -e '\n\033[0;36mInstalling NodeJS using ASDF\033[0m\n'
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

# Limpar o cache do APT
echo -e "\n\033[0;36mClearing APT's cache...\033[0m\n"
sudo apt autoclean
sudo apt autoremove -y

echo -e '\n\033[0;36mFinish\033[0m\n'