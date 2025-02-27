#!/bin/bash

SRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../" &> /dev/null && pwd )"

echo -e '\n\033[0;36mRemoving the .gitconfig .zshrc files\033[0m'
rm -rf ~/.config/starship.toml && rm -rf ~/.config/ghostty && rm -rf ~/.bash_aliases && rm -rf ~/.config/fish && rm -rf ~/.gitconfig && rm -rf ~/.zshrc

echo -e '\n\033[0;36mCreating shortcuts of files .bash_aliases .gitconfig .zshrc\033[0m'
ln -s $SRC/backup/starship.toml ~/.config/starship.toml
ln -s $SRC/backup/bash_aliases ~/.bash_aliases
ln -s $SRC/backup/gitconfig ~/.gitconfig
ln -s $SRC/backup/ghostty ~/.config/
ln -s $SRC/backup/fish ~/.config/
ln -s $SRC/backup/zshrc ~/.zshrc

echo -e '\n\033[0;36mInstalling NerdFonts font package\033[0m'
cp -vf $SRC/utils/fonts/*.ttf ~/.local/share/fonts

echo -e '\n\033[0;36mUpdating system\033[0m' # Atualizar sistema e instalar pacotes essenciais
sudo apt update && sudo apt upgrade -y && sudo apt install openssh-server bashtop htop wget curl git -y

echo -e '\n\033[0;36mEnable SSH\033[0m' # Habilita o SSH
sudo chmod 700 ~/.ssh && sudo chmod 600 ~/.ssh/authorized_keys
sudo systemctl start ssh && sudo systemctl enable ssh

echo -e '\n\033[0;36mInstalling Neovim\033[0m' # Instala Neovim
rm -rf ~/.config/nvim && ln -s $SRC/backup/nvim ~/.config/
sudo apt install neovim -y

echo -e '\n\033[0;36mInstalling Tmux\033[0m' # Instala Tmux
rm -rf ~/.tmux/plugins/tpm && rm -rf ~/.tmux.conf && ln -s $SRC/backup/tmux/.tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone -b v2.1.2 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
sudo apt install tmux -y && tmux source-file ~/.tmux.conf

echo -e '\n\033[0;36mWant to install essential desktop packages? yes/no:\033[0m' # Instala pacotes essenciais para usuário
read desktop_response

if [ "$desktop_response" == "yes" ]; then
  cd $HOME
  echo -e '\n\033[0;36mInstalling essential packages\033[0m'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  sudo apt install build-essential procps htop file -y
  sudo snap install beekeeper-studio dbeaver-ce
  brew install act gh

  echo -e '\n\033[0;36mDo you want to install Fish Shell and Starship or ZSH and Oh My Zsh? fish/zsh/no:\033[0m'
  read terminal_response

  case "$terminal_response" in
    fish)
      echo -e '\n\033[0;36mInstalling Fish Shell and Starship\033[0m'
      sudo apt-add-repository ppa:fish-shell/release-3 && sudo apt update && sudo apt install fish -y # https://github.com/fish-shell/fish-shell

      curl -sS https://starship.rs/install.sh | sh # https://starship.rs/guide/
      starship preset pastel-powerline -o ~/.config/starship.toml
      ;;
    zsh)
      echo -e '\n\033[0;36mInstalling ZSH, Oh My Zsh, and Zinit\033[0m'
      sudo apt install zsh -y
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      chsh -s $(which zsh)

      bash -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
      zinit self-update
      ;;
    *)
      echo "No shell installation selected."
      ;;
  esac

  echo -e '\n\033[0;36mDo you want to install ASDF? yes/no:\033[0m' # Instalar ASDF
  read asdf_response

  if [ "$asdf_response" == "yes" ]; then
    echo -e '\n\033[0;36mInstalling ASDF\033[0m'
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
    . "$HOME/.asdf/asdf.sh"
    . "$HOME/.asdf/completions/asdf.bash"

    echo -e '\n\033[0;36mInstalling Yarn using ASDF\033[0m' # Instala Yarn
    asdf plugin-add yarn && asdf install yarn latest

    echo -e '\n\033[0;36mInstalling LazyDocker using ASDF\033[0m'
    asdf plugin add lazydocker https://github.com/comdotlinux/asdf-lazydocker.git
    asdf list all lazydocker && asdf install lazydocker latest && asdf global lazydocker latest

    echo -e '\n\033[0;36mInstalling NodeJS using ASDF\033[0m' # Instala NodeJS
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  fi
fi

echo -e '\n\033[0;36mDo you want to install Docker and Docker Compose? yes/no:\033[0m' # Instalar DOCKER
read docker_response

if [ "$docker_response" == "yes" ]; then
  echo -e '\n\033[0;36mInstalling DOCKER\033[0m'
  sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  apt-cache policy docker-ce
  sudo apt install docker-ce -y

  docker version

  echo -e '\n\033[0;36mInstalling DOCKER and DOCKER COMPOSE\033[0m' # Instala DOCKER COMPOSE
  mkdir -p ~/.docker/cli-plugins/
  curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose

  chmod +x ~/.docker/cli-plugins/docker-compose

  docker compose version

  echo -e '\n\033[0;36mAdding user $USER in usergroup to run docker without sudo\033[0m' # Adicionar o usuário $USER no grupo de usuários para executar o docker sem o sudo
  sudo usermod -aG docker ${USER}
  sudo su - ${USER}
  groups
  sudo usermod -aG docker ${USER}
fi

echo -e '\n\033[0;36mDo you want to install K3S? yes/no:\033[0m' # Instalar K3S
read k3s_response

if [ "$k3s_response" == "yes" ]; then
    echo -e '\n\033[0;36mDo you want to install K3s as (1) master or (2) slave?\033[0m' # Configurando K3S
    read k3s_option

    if [ "$k3s_option" == "1" ]; then
      echo -e '\n\033[0;36mInstalling K3s as master...\033[0m'
      curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s -

    elif [ "$k3s_option" == "2" ]; then
      echo -e '\n\033[0;36mEnter the master IP?\033[0m'
      read master_ip

      echo -e '\n\033[0;36mEnter the master token?\033[0m'
      read master_token

      echo -e '\n\033[0;36mInstalling K3s as slave...\033[0m'
      export HOSTNAME=$(hostname)

      curl -sfL https://get.k3s.io | K3S_TOKEN="$master_token" K3S_URL="https://$master_ip:6443" K3S_NODE_NAME="$HOSTNAME" sh -

  else
    echo "Invalid response. Please choose (1) for master or (2) for slave."
  fi
fi

echo -e '\n\033[0;36mDo you want to implement file sharing services? yes/no:\033[0m' # Configurando servidor NFS
read sharefiles_response

if [ "$sharefiles_response" == "yes" ]; then
  echo -e '\n\033[0;36mDo you want to install NFS server? yes/no:\033[0m' # Configurando servidor NFS
  read nfs_response

  if [ "$nfs_response" == "yes" ]; then
    sudo apt install nfs-kernel-server -y

    echo -e '\n\033[0;36mEnter an IP mask that will be allowed (Ex: 100.10.10.0/24)\033[0m'
    read ask_nfs_ip

    echo -e '\n\033[0;36mEnter the directory you want to share (Ex: /mnt/SSD-4TB/)\033[0m'
    read ask_nfs_file

    echo -e '\n\033[0;36mConfiguring NFS server\033[0m'
    sudo mkdir /var/nfs -p && sudo chmod 777 /var/nfs

    echo "$ask_nfs_file $ask_nfs_ip(rw,no_root_squash,sync)" | sudo tee -a /etc/exports
    sudo systemctl restart nfs-kernel-server
    sudo ufw allow from $ask_nfs_ip to any port nfs
  fi

  echo -e '\n\033[0;36mDo you want to install SAMBA server? yes/no:\033[0m' # Configurando servidor Samba
  read samba_response

  if [ "$samba_response" == "yes" ]; then
    sudo apt install samba -y

    echo -e '\n\033[0;36mRestart the Samba Service\033[0m' # Reiniciando servidor Samba
    sudo systemctl restart smbd
    sudo systemctl restart nmbd
  fi
fi

echo -e '\n\033[0;36mDo you want to install Tailscale VPN? yes/no:\033[0m' # Configurando servidor NFS
read tailscale_response

if [ "$tailscale_response" == "yes" ]; then
  echo -e '\n\033[0;36mInstalling Tailscale VPN...\033[0m'
  curl -fsSL https://tailscale.com/install.sh | sh
  sudo tailscale up
fi

echo -e '\n\033[0;36mDo you want to pre-configure Pihole? yes/no:\033[0m' # Configurando servidor NFS
read pihole_response

if [ "$pihole_response" == "yes" ]; then
  echo -e '\n\033[0;36mPreparing environment for Pihole execution.\033[0m'
  sudo systemctl stop systemd-resolved.service
  sudo systemctl disable systemd-resolved.service
  sudo sed -i 's/127.0.0.53/8.8.8.8/g' /etc/resolv.conf
fi

echo -e "\n\033[0;36mClearing APT's cache...\033[0m\n" # Limpar o cache do APT
sudo apt autoclean && sudo apt autoremove -y

# echo -e '\n\033[0;36mFinish and reboot system...\033[0m'
# sleep 10 && sudo reboot
