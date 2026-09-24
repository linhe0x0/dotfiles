# Function to get the internal IP address of the current machine
#
# Automatically detects the operating system and uses appropriate commands:
# - On macOS: Uses ipconfig with the default network interface
# - On Linux: First tries hostname -I, falls back to ip route if needed
# Returns the first valid internal IP address found
#
# Usage: get_internal_ip (no arguments needed)
#
# This function is aliased as 'iip' for convenience
get_internal_ip() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # For macOS
    ipconfig getifaddr $(route get default | awk '/interface:/ {print $2}')
  else
    # For Linux
    hostname -I | awk '{print $1}' 2>/dev/null ||
      ip route get 1.2.3.4 | awk '{for(i=1;i<=NF;i++)if($i=="src")print $(i+1)}'
  fi
}

# Open a brew package's homepage in the default browser
#
# Usage: open_brew_package_home <package>
#
# Output is one line, always:
#   success -> "→ <url>"   (already open in your browser)
#   failure -> "✗ <reason>" (and a non-zero exit)
#
open_brew_package_home() {
  if (($# == 0)); then
    echo "✗ Which package?" >&2
    return 1
  fi

  local url
  url=$(brew info "$1" 2>/dev/null | awk '/^https?:\/\// {print; exit}')

  if [[ -z "$url" ]]; then
    echo "✗ '$1' not found (no formula or cask by that name)" >&2
    return 1
  fi

  open "$url" && echo "→ $url"
}

# SSH Port Forwarding Functions
#
# Usage:
#   ssh_forward_port <host> <port1> [port2] ...  - Forward local ports to remote host
#   ssh_disconnect_port <port1> [port2] ...     - Disconnect port forwarding
#   ssh_list_forwards                          - List active port forwards
#
# Aliases: fip, dip, lip
ssh_forward_port() {
  (($# < 2)) && echo "Usage: fip <host> <port1> [port2] ..." && return 1
  local host="$1"
  shift
  for port in "$@"; do
    ssh -f -N -L "$port:localhost:$port" "$host" && echo "Forwarding localhost:$port -> $host:$port"
  done
}

ssh_disconnect_port() {
  (($# == 0)) && echo "Usage: dip <port1> [port2] ..." && return 1
  for port in "$@"; do
    pkill -f "ssh.*-L $port:localhost:$port" && echo "Stopped forwarding port $port" || echo "No forwarding on port $port"
  done
}

ssh_list_forwards() {
  pgrep -af "ssh.*-L [0-9]+:localhost:[0-9]+" || echo "No active forwards"
}

# Open a dev layout in tmux: the left pane stays as a plain shell for you to
# start the AI agent manually, the right side splits into lazygit (top two
# thirds) and a terminal (bottom third). Herdr is not involved. The window
# is named dev-<slug>, where slug is the enclosing git repository's name
# (the current directory when outside a repo). Inside tmux it focuses the
# dev-<slug> window if one exists, otherwise the current window is renamed
# and the layout is built in place; outside tmux it
# creates and attaches a session named dev first (attaching to the existing
# one if it already exists).
#
# This function is aliased as 'tdl' for convenience.
tmux_dev_layout() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || root=$PWD
  local slug="${root##*/}"
  slug="${slug//[.:]/-}" # avoid '.' and ':' in tmux names
  local name="dev-$slug"

  local left right term
  if [[ -n "$TMUX" ]]; then
    if tmux list-windows -F '#{window_name}' | grep -qx "$name"; then
      tmux select-window -t "$name"
      return
    fi
    tmux rename-window "$name"
    left=$(tmux display-message -p '#{pane_id}')
  else
    if tmux has-session -t dev 2>/dev/null; then
      tmux attach -t dev
      return
    fi
    tmux new-session -d -s dev -n "$name" -c "$PWD"
    left=$(tmux list-panes -t dev: -F '#{pane_id}')
  fi

  # Layout: the left pane is left empty (run your agent there); the right
  # third splits into lazygit (top two thirds) and a terminal (bottom third).
  right=$(tmux split-window -h -l 33% -t "$left" -c "$PWD" -P -F '#{pane_id}')
  term=$(tmux split-window -v -l 33% -t "$right" -c "$PWD" -P -F '#{pane_id}')

  tmux send-keys -t "$right" 'lazygit' Enter

  tmux select-pane -t "$left"
  if [[ -z "$TMUX" ]]; then
    tmux attach -t dev
  fi
}

# Run a command while preventing idle sleep (wraps it in caffeinate -i)
#
# Usage: nosleep <command> [args...]
# Example: nosleep ./slow-build.sh
#
# Exits with the wrapped command's exit status
nosleep() {
  echo "🔋 Mac will stay awake while the command runs; sleep resumes automatically when it finishes."
  caffeinate -i "$@"
}

# Prevent idle sleep or display sleep (caffeinate wrappers)
#
# Each prints a hint, then runs caffeinate until Ctrl-C (or for a fixed time).
# Extra args are passed through, e.g. `stay ./build.sh`
stay() {
  echo "🔋 Mac will stay awake until you press Ctrl-C"
  caffeinate -i "$@"
}

screenon() {
  echo "🔋 Display will stay on until you press Ctrl-C"
  caffeinate -d "$@"
}

stay1h() {
  echo "🔋 Mac will stay awake for the next hour"
  caffeinate -i -t 3600 "$@"
}

stay2h() {
  echo "🔋 Mac will stay awake for the next 2 hours"
  caffeinate -i -t 7200 "$@"
}

stay4h() {
  echo "🔋 Mac will stay awake for the next 4 hours"
  caffeinate -i -t 14400 "$@"
}

stay8h() {
  echo "🔋 Mac will stay awake for the next 8 hours"
  caffeinate -i -t 28800 "$@"
}
