function restart
  sudo systemctl restart systemd-logind
end

function update
  ~/.dotfiles/scripts/linux/system-update.sh
end

function shutdown
  sudo shutdown now
end
