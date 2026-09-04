# Automatically enter tmux session after shell startup.
if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
  # Only attach if the default session has no attached clients.
  attached=$(tmux display-message -p -t default '#{session_attached}' 2>/dev/null)
  if [ "${attached:-0}" -eq 0 ]; then
    tmux attach-session -t default || tmux new-session -s default
  fi
fi
