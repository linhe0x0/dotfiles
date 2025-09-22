#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [[ "${TRACE-0}" == "1" ]]; then
  set -o xtrace
fi

cd "$(dirname "$0")"

# source utils
source "../utils.sh"

# install raycast configurations.
install_raycast() {
  install "raycast"

  mkdir -p $HOME/.config/raycast
  link_file $PWD/scripts $HOME/.config/raycast/scripts

  ok "raycast"
}

install_raycast
