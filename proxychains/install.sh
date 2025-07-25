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

# install proxychains configurations.
install_proxychains() {
  install "proxychains"

  link_file $PWD/proxychains.conf $HOMEBREW_PREFIX/etc/proxychains.conf

  ok "proxychains"
}

install_proxychains
