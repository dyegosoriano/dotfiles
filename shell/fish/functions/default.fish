function lsa
  eza --long --group-directories-first --no-permissions --color=always --icons=always --no-time --no-user --grid --all $argv
end

function ls
  eza --long --group-directories-first --no-permissions --color=always --icons=always --no-time --no-user --grid $argv
end

function rank
  sort | uniq -c | sort -nr | head -n 10 $argv
end

function fs
  du -sh * | sort -h $argv
end

function history
  history | grep $argv
end

function mkdir
  mkdir -pv
end

function cat
  bat $argv
end

function y
  yarn $argv
end

function n
  npm $argv
end

function b
  bat $argv
end

function c
  clear
end

function e
  exit
end
