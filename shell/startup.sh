# Automatically enter tmux session after shell startup.
if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t default || tmux new-session -s default
fi
