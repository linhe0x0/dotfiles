if command -q tmux && not set -q TMUX
  tmux attach -t default || tmux new -s default
end
