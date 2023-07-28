#!/bin/bash

rm -rf ~/.gitconfig
rm -rf ~/.zshrc

ln -s ~/.dotfiles/.bash_aliases ~/.bash_aliases
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.zshrc ~/.zshrc

ln -s ~/.dotfiles/.zshrc ~/.zshrc
# Instalando DOCKER
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker

# Adicionando usuário $USER no grupo de usuários para executar o docker sem o sudo
sudo usermod -aG docker ${USER}
sudo su - ${USER}
groups
sudo usermod -aG docker username

# Instalando ASDF
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"

# Instalando Yarn
asdf plugin-add yarn
asdf install yarn latest

# Instalando NodeJS
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

