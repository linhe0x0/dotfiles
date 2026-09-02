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
