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

# install zed configurations.
install_zed() {
  install "zed"

  mkdir -p $HOME/.config/zed
  link_file $PWD/settings.json $HOME/.config/zed/settings.json

  ok "zed"
}

install_zed
