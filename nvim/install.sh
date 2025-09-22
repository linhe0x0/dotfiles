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

# install neovim configurations.
install_nvim() {
  install "neovim"

  link_file $PWD $HOME/.config/nvim

  ok "neovim"
}

install_nvim
