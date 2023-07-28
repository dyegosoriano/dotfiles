# REMOTE
alias remote-instance="ssh -i ~/.ssh/ssh-key.pem ubuntu@X.X.X.X"

# TERMINAL
alias restart='sudo systemctl restart systemd-logind'
alias shutdown='sudo shutdown now'

alias update='sudo apt update && apt upgrade -y'

alias command-history='history|grep'
alias filesize='du -sh * | sort -h'
alias mkdir='mkdir -pv'
alias ips='ip -c -br a'
alias cls='clear'
alias lsa='ls -la'
alias ls='ls -l'

# DOCKER
alias dk='docker'