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

# install rex configurations.
install_rex() {
  install "rex"

  link_file $PWD $HOME/.config/rex

  if command -v rex >/dev/null 2>&1; then
    if rex config check; then
      rex config reload || warn "rex config reload failed. Run it manually later."
    else
      error "rex config check failed. Run 'rex config check' for details."
    fi
  else
    warn "rex command not found. Skipped config check and reload."
  fi

  ok "rex"
}

install_rex
