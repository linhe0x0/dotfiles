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

# install starship configurations.
install_starship() {
  install "starship"

  link_file $PWD/starship.toml $HOME/.config/starship.toml

  ok "starship"
}

install_starship
