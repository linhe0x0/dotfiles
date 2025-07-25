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

# install tmux configurations.
install_tmux() {
  install "tmux"

  link_file $PWD/tmux.conf $HOME/.tmux.conf

  ok "tmux"
}

install_tmux
