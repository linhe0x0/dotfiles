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

# install zsh configurations.
install_zsh() {
  install "zsh"

  link_file $PWD/zshrc $HOME/.zshrc

  ok "zsh"
}

install_zsh
