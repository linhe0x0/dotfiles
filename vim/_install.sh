#!/usr/bin/env bash

set -o errexit
set -o pipefail

if [[ "${TRACE-0}" == "1" ]]; then
  set -o xtrace
fi

cd "$(dirname "$0")"

# source utils
source "../utils.sh"

# install vim configurations.
install_vim() {
  install "vim"

  link_file $PWD/vimrc $HOME/.vimrc

  ok "vim"
}

# install vim basic configurations.
install_vim_basic() {
  install "vim_basic"

  link_file $PWD/vimrc-basic $HOME/.vimrc

  ok "vim-basic"
}

if [[ -z "$1" ]]; then
  install_vim
elif [ $1 -eq "vim" ]; then
  install_vim
elif [ $1 -eq "vim-basic" ]; then
  install_vim_basic
fi
