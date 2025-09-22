#!/usr/bin/env bash

#
# This script is designed to install and apply configurations.
#

set -e

if [[ "${TRACE-0}" == "1" ]]; then
  set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
  echo 'A script to install dotfiles. After installing, open a new terminal window to see the effects.

Usage:
  ./install.sh [name]

Example:
  To install all:         ./install.sh
  To install shell only:  ./install.sh shell
'
  exit
fi

cd "$(dirname "$0")"

# source utils
source "utils.sh"

WORKING_DIR=$(pwd)

# Prepare
CONFIG_DIR=$HOME/.config

if [[ ! -d "$CONFIG_DIR" ]]; then
  mkdir -p $CONFIG_DIR
fi

# Run installers
install_all() {
  for file in "${WORKING_DIR}"/*/install.sh; do
    sh -c "${file}"
  done

  echo ""
  echo "All done!"
}

if [[ -z "$1" ]]; then
  install_all
else
  sh -c "./$1/install.sh"
fi
