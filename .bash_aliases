# REMOTE
alias rmt-instance="ssh -i ~/.ssh/ssh-key.pem ubuntu@X.X.X.X"
alias rmt-r2d2="ssh soriano@100.10.10.10"

alias rmt-topGain-api="ssh -i ~/.ssh/younner-dev.pem ubuntu@ec2-44-201-192-199.compute-1.amazonaws.com"
alias rmt-topGain-web="ssh -i ~/.ssh/younner-dev.pem ubuntu@ec2-18-205-116-183.compute-1.amazonaws.com"

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