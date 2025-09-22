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

# install direnv configurations.
install_direnv() {
  install "direnv"

  mkdir -p $HOME/.config/direnv
  link_file $PWD/direnv.toml $HOME/.config/direnv/direnv.toml

  ok "direnv"
}

install_direnv
