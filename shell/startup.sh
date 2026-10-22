# Automatically enter tmux session after shell startup.
# Skip in Rex sessions so Rex manages the terminal without tmux.
if [ "$TERM_PROGRAM" = "rex" ] || [ -n "$REX_SESSION" ]; then
  return 0
fi
if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
  # Only attach if the default session has no attached clients.
  attached=$(tmux display-message -p -t main '#{session_attached}' 2>/dev/null)
  if [ "${attached:-0}" -eq 0 ]; then
    tmux new -A -s main
  fi
fi
