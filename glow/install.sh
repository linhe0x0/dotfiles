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

  mkdir -p $HOME/Library/Preferences/glow
  link_file $PWD/glow.yml $HOME/Library/Preferences/glow/glow.yml

  ok "git"
}

install_git
