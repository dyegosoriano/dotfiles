function tmx
  tmux $argv
end

function tmx-kill
  tmux kill-session -t $argv
end

function tmx-attach
  tmux attach -t $argv
end

function tmx-new
  tmux new -s $argv
end

function tmx-list
  tmux ls
end
