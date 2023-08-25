#!/bin/bash

echo -e '\n\033[0;36mRemoving the .gitconfig .zshrc files\033[0m\n'
rm -rf ~/.gitconfig
rm -rf ~/.zshrc

echo -e '\n\033[0;36mCreating shortcuts of files .bash_aliases .gitconfig .zshrc\033[0m\n'
ln -s ~/.dotfiles/.bash_aliases ~/.bash_aliases
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.zshrc ~/.zshrc

cd /home/${USER}

# Atualizar sistema
echo -e '\n\033[0;36mUpdating system\033[0m\n'
sudo apt update 
sudo apt upgrade -y
sudo apt install curl -y

# Instalar ZSH e Oh My Zsh
echo -e '\n\033[0;36mInstalling ZSH and Oh My Zsh\033[0m\n'
sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Instalar Zinit
# https://github.com/zdharma-continuum/zinitcd
echo -e '\n\033[0;36mInstalling Zinit\033[0m\n'
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
zinit self-update

# Instalar DOCKER
echo -e '\n\033[0;36mInstalling DOCKER\033[0m\n'
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce -y

# Instalar DOCKER COMPOSE
echo -e '\n\033[0;36mInstalling DOCKER and DOCKER COMPOSE\033[0m\n'
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose

chmod +x ~/.docker/cli-plugins/docker-compose

docker compose version

# Adicionar o usuário $USER no grupo de usuários para executar o docker sem o sudo
echo -e '\n\033[0;36mAdding user $USER in usergroup to run docker without sudo\033[0m\n'
sudo usermod -aG docker ${USER}
sudo su - ${USER}
groups
sudo usermod -aG docker ${USER}

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