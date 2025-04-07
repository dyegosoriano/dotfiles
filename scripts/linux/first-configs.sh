#!/bin/bash

SRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../" &> /dev/null && pwd )"

echo -e '\n\033[0;36mRemoving the .gitconfig .zshrc files\033[0m'
rm -rf ~/.config/starship.toml
rm -rf ~/.tmuxifier/layouts
rm -rf ~/.config/ghostty
rm -rf ~/.bash_aliases
rm -rf ~/.config/fish
rm -rf ~/.gitconfig
rm -rf ~/.zshrc

echo -e '\n\033[0;36mCreating shortcuts of files .bash_aliases .gitconfig .zshrc\033[0m'
ln -s $SRC/backup/tmuxifier/layouts ~/.tmuxifier/layouts
ln -s $SRC/backup/starship.toml ~/.config/starship.toml
ln -s $SRC/backup/bash_aliases ~/.bash_aliases
ln -s $SRC/backup/gitconfig ~/.gitconfig
ln -s $SRC/backup/ghostty ~/.config/
ln -s $SRC/backup/fish ~/.config/
ln -s $SRC/backup/zshrc ~/.zshrc

echo -e '\n\033[0;36mInstalling NerdFonts font package\033[0m'
cp -vf $SRC/utils/fonts/*.ttf ~/.local/share/fonts

echo -e '\n\033[0;36mEnable SSH\033[0m' # Habilita o SSH
sudo apt install openssh-server -y && sudo systemctl enable ssh && sudo systemctl start ssh
sudo chmod 700 ~/.ssh && sudo chmod 600 ~/.ssh/authorized_keys
sudo systemctl start ssh && sudo systemctl enable ssh

echo -e '\n\033[0;36mUpdating system\033[0m' # Atualizar sistema e instalar pacotes essenciais
sudo apt update && sudo apt upgrade -y && sudo apt install build-essential bashtop htop wget curl eza git -y

echo -e '\n\033[0;36mInstalling Tmux\033[0m' # Instala Tmux
rm -rf ~/.tmux/plugins/tpm && rm -rf ~/.tmux.conf && ln -s $SRC/backup/tmux/.tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone -b v2.1.2 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
brew install --quiet --force tmux && tmux source-file ~/.tmux.conf

echo -e '\n\033[0;36mInstalling Tmuxifier\033[0m' # https://github.com/jimeh/tmuxifier
git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
export PATH="$HOME/.tmuxifier/bin:$PATH" # Tornar o tmuxifier executável nos shell's bash e zsh
$HOME/.tmuxifier/bin

echo -e '\n\033[0;36mInstalling Neovim\033[0m' # Remove o diretório ~/.config/nvim e cria um link simbólico para o diretório ~/dotfiles/backup/nvim
rm -rf ~/.config/nvim && ln -s $SRC/backup/nvim ~/.config/
brew install --quiet --force neovim

echo -e '\n\033[0;36mWant to install essential desktop packages? yes/no:\033[0m' # Instala pacotes essenciais para usuário
read desktop_response

if [ "$desktop_response" == "yes" ]; then
  cd $HOME
  echo -e '\n\033[0;36mInstalling essential packages\033[0m'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

  brew install --quiet --force docker-compose lazydocker lazygit neofetch ripgrep zoxide docker fzf bat

  echo -e '\n\033[0;36mDo you want to install Fish Shell and Starship or ZSH and Oh My Zsh? fish/zsh/no:\033[0m'
  read terminal_response

  if [ "$terminal_response" == "fish" ]; then
      echo -e '\n\033[0;36mInstalling Fish Shell and Starship\033[0m'
      brew install --quiet --force fish starship
      echo "$(brew --prefix)/bin/fish" | sudo tee -a /etc/shells
      # chsh -s "$(brew --prefix)/bin/fish" # Set the default shell to fish
      chsh -s $(which fish) # Set the default shell to fish
  fi

  if [ "$terminal_response" == "zsh" ]; then
    echo -e '\n\033[0;36mInstalling ZSH, Oh My Zsh, and Zinit\033[0m'
    brew install --quiet --force zsh zinit
    chsh -s $(which zsh)
    zinit self-update
  fi

  echo -e '\n\033[0;36mDo you want to install ASDF? yes/no:\033[0m' # Instalar ASDF
  read asdf_response

  if [ "$asdf_response" == "yes" ]; then
    # https://github.com/asdf-vm/asdf-plugins
    echo -e '\n\033[0;36mInstalling ASDF\033[0m'
    brew install --quiet --force asdf

    asdf plugin add yarn https://github.com/twuni/asdf-yarn.git && asdf install yarn latest # Instala Yarn
    asdf plugin add ollama https://github.com/virtualstaticvoid/asdf-ollama.git # Instala Ollama
    asdf plugin add awscli https://github.com/MetricMike/asdf-awscli.git # Instala AWS CLI
    asdf plugin add deno https://github.com/asdf-community/asdf-deno.git # Instala Deno
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git # Instala NodeJS
    asdf plugin add lua https://github.com/Stratus3D/asdf-lua.git # Instala Lua
  fi
fi

echo -e '\n\033[0;36mDo you want to install Tailscale VPN? yes/no:\033[0m' # Configurando servidor NFS
read tailscale_response

if [ "$tailscale_response" == "yes" ]; then
  echo -e '\n\033[0;36mInstalling Tailscale VPN...\033[0m'
  brew install --quiet --force tailscale
  sudo tailscale up
fi

echo -e "\n\033[0;36mClearing package cache...\033[0m\n" # Limpa o cache dos pacotes
brew autoremove --quiet && brew cleanup --quiet
sudo apt autoclean && sudo apt autoremove -y
