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

# install git configurations.
install_git() {
  install "git"

  mkdir -p $HOME/.config/git
  touch $HOME/.gitconfig.local
  link_file $PWD/gitconfig $HOME/.gitconfig
  link_file $PWD/gitconfig.github $HOME/.gitconfig.github
  link_file $PWD/gitignore $HOME/.config/git/gitignore
  link_file $PWD/gitmessage $HOME/.config/git/gitmessage

  ok "git"
}

install_git
