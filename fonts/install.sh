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

# Install fonts.
install_fonts() {
  install "fonts"

  # remove all fonts from ~/Library/Fonts that start with "Monaspace"
  rm -rf ~/Library/Fonts/Monaspace*

  # copy all fonts from ./fonts to ~/Library/Fonts
  cp ./fonts/* ~/Library/Fonts

  ok "fonts"
}

install_fonts
