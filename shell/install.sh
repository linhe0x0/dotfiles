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

# Check what shell is being used
SH="${HOME}/.bashrc"
ZSHRC="${HOME}/.zshrc"
SHELL_DIR="$HOME/.shell"

INSTALL_FILE="install.sh"

if [ -f "$ZSHRC" ]; then
  SH="$ZSHRC"
fi

# install shells
install_shell() {
  if [[ ! -d "$SHELL_DIR" ]]; then
    mkdir $SHELL_DIR
  fi

  for file in *.sh; do
    if [[ $file != *$INSTALL_FILE ]]; then
      if [[ -f "$file" ]]; then
        local filename src dst

        filename=$(basename "$file")
        src=$(realpath "$file")
        dst="$SHELL_DIR/$filename"

        if [[ -e "$dst" ]]; then
          if confirm "${filename} already exists, overwrite?"; then
            ln -sf $src $dst
          fi
        else
          ln -s $src $dst
        fi

        if ! $(grep ".shell/$filename" $SH >/dev/null 2>&1); then
          echo "
if [ -f ~/.shell/$filename ]; then
  . ~/.shell/$filename
fi" >>"$SH"
        fi
      fi
    fi
  done

  ok "shell"
}

install_shell
