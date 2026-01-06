#!/bin/bash
# Script criado para o Ubuntu 22.04 LTS

HOST_INSTANCE="r2-d2.local"
HOST_USER="soriano"

# sudo blkid

# sudo nano /etc/fstab
# sudo umount -a
# sudo mount -a

# sudo lsblk
# sudo cryptsetup luksOpen /dev/sda luks-sda
# sudo mount /dev/mapper/luks-sda /media/ssd-01-4gb

clear

echo -e '\n\033[0;36mAccessing remote instance...\033[0m\n'
ssh $HOST_USER@$HOST_INSTANCE << EOF
uname -a
grep "model name" /proc/cpuinfo
grep MemTotal /proc/meminfo
ps -u -p 1

# Atualizar sistema
echo -e '\n\033[0;36mUpdating system\033[0m\n'
sudo apt update
sudo apt upgrade -y

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

# Instalar DOCKER
echo -e '\n\033[0;36mInstalling DOCKER\033[0m\n'
sudo apt  install docker.io -y
docker version

# Instalar DOCKER COMPOSE
echo -e '\n\033[0;36mInstalling DOCKER COMPOSE\033[0m\n'
sudo apt install docker-compose -y
docker-compose version

# Instalar K3S
echo -e '\n\033[0;36mInstalling K3S\033[0m\n'
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
sudo systemctl status k3s --no-pager
sudo kubectl version

# Instalar SAMBA
echo -e '\n\033[0;36mInstalling SAMBA\033[0m\n'
sudo apt install samba samba-common-bin -y
samba --version
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
sudo systemctl enable smbd
sudo systemctl start smbd
sudo systemctl status smbd --no-pager

# Adicionar o usuário $USER no grupo de usuários para executar o docker sem o sudo
echo -e '\n\033[0;36mAdding user $USER in usergroup to run docker without sudo\033[0m\n'
sudo usermod -aG docker ${USER}
sudo su - ${USER}
groups
sudo usermod -aG docker ${USER}

# Preparando ambiente para execução do Pihole.
echo -e '\n\033[0;36mPreparing environment for Pihole execution.\033[0m\n'
sudo systemctl stop systemd-resolved.service
sudo systemctl disable systemd-resolved.service
sudo sed -i 's/127.0.0.53/8.8.8.8/g' /etc/resolv.conf

# Limpar o cache do APT
echo -e "\n\033[0;36mClearing APT's cache...\033[0m\n"
sudo apt autoclean
sudo apt autoremove -y
EOF

echo -e '\n\033[0;36mFinish\033[0m\n'