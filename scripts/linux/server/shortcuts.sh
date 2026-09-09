
#!/bin/bash

SRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../../" &> /dev/null && pwd )"

echo -e '\n\033[0;36mConfiguring shell...\033[0m'

echo -e '\n\033[0;36mConfiguring programs...\033[0m'
[ -d ~/.config/superfile ] && mv ~/.config/superfile ~/.config/superfile.backup 2>/dev/null; ln -sfn "$SRC/programs/superfile" ~/.config/superfile
[ -d ~/.tmux.conf ] && mv ~/.tmux.conf ~/.tmux.conf.backup 2>/dev/null; ln -sfn "$SRC/programs/tmux/tmux.conf" ~/.tmux.conf
[ -d ~/..config/git ] && mv ~/..config/git ~/..config/git.backup 2>/dev/null; ln -sfn "$SRC/programs/git" ~/..config/git

echo -e '\n\033[0;36mConfiguring shell...\033[0m'
[ -d ~/.local/share/fish/fish_history ] && mv ~/.local/share/fish/fish_history ~/.local/share/fish/fish_history.backup 2>/dev/null; ln -sfn "$SRC/backup/fish_history" ~/.local/share/fish/fish_history
[ -d ~/.config/starship.toml ] && mv ~/.config/starship.toml ~/.config/starship.toml.backup 2>/dev/null; ln -sfn "$SRC/shell/starship/starship.toml" ~/.config/starship.toml
[ -d ~/.bash_history ] && mv ~/.bash_history ~/.bash_history.backup 2>/dev/null; ln -sfn "$SRC/backup/bash_history" ~/.bash_history
[ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.backup 2>/dev/null; ln -sfn "$SRC/shell/bash/bashrc" ~/.bashrc
[ -f ~/.bash_profile ] && mv ~/.bash_profile ~/.bash_profile.backup 2>/dev/null; ln -sfn "$SRC/shell/bash/bash_profile" ~/.bash_profile
[ -d ~/.bash_aliases ] && mv ~/.bash_aliases ~/.bash_aliases.backup 2>/dev/null; ln -sfn "$SRC/shell/bash/aliases" ~/.bash_aliases

[ -d ~/.config/fish ] && mv ~/.config/fish ~/.config/fish.backup 2>/dev/null; ln -sfn "$SRC/shell/fish" ~/.config/fish
[ -d ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup 2>/dev/null; ln -sfn "$SRC/shell/zsh/zshrc" ~/.zshrc

echo -e '\n\033[0;36mFinished.\033[0m'
