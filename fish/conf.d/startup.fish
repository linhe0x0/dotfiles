if command -q tmux && not set -q TMUX
  tmux new -A -s main
end
