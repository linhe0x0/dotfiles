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

  npm install -g --registry=https://registry.npmmirror.com --ignore-scripts \
    cspell \
    prettier \
    skills \
    sql-formatter \
    @earendil-works/pi-coding-agent

  npm list -g

  ok "npm"
}

install_npm
