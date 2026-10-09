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
  nvim --headless "+Lazy! sync" +qa

  ok "neovim"
}

# skip installation when nvim is not available.
if command -v nvim > /dev/null 2>&1; then
  install_nvim
else
  error "nvim command not found. Please install Neovim first: https://github.com/neovim/neovim#install-from-package"
fi
