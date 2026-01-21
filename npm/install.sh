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

# Install global npm packages.
install_npm() {
  install "npm"

  npm install -g cspell prettier --registry=https://registry.npmmirror.com

  ok "npm"
}

install_npm
