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

# install fish configurations.
install_fish() {
  install "fish"

  mkdir -p $HOME/.config/fish
  mkdir -p $HOME/.config/fish/conf.d
  link_file $PWD/config.fish $HOME/.config/fish/config.fish
  link_file $PWD/conf.d/alias.fish $HOME/.config/fish/conf.d/alias.fish
  link_file $PWD/conf.d/startup.fish $HOME/.config/fish/conf.d/startup.fish

  ok "zsh"
}

install_fish
