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

# Function to open the homepage of a brew package
#
# Usage: open_brew_package_home <package_name>
#
# Extracts the homepage URL from brew info (3rd line) and opens it in default browser
#
# This function is aliased as 'brew_home' for convenience
open_brew_package_home() {
  brew info "$1" | tee /dev/tty | sed -n '3p' | xargs open
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
