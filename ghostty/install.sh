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

# install ghostty configurations.
install_ghostty() {
  install "ghostty"

  mkdir -p $HOME/.config/ghostty
  link_file $PWD/config $HOME/.config/ghostty/config

  mkdir -p $HOME/.config/ghostty/shaders
  link_file $PWD/config/shaders/cursor_smear.glsl $HOME/.config/ghostty/shaders/cursor_smear.glsl

  ok "ghostty"

  info "See https://ghostty.org/docs/help/terminfo to get information on how to setup Terminfo if needed."
}

install_ghostty
