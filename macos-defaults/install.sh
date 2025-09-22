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

# Setup macos defaults.
install_defaults() {
  install "macos defaults"

  # Change the Rows of Launchpad.
  defaults write com.apple.dock springboard-rows -int "8"

  # Change the Columns of Launchpad.
  defaults write com.apple.dock springboard-columns -int "8"

  # Dock icon size of 36 pixels.
  defaults write com.apple.dock "tilesize" -int "36"

  # Autohide the Dock when the mouse is out.
  defaults write com.apple.dock "autohide" -bool "true"

  # Remove the Auto-Hide Dock Delay.
  defaults write com.apple.Dock "autohide-delay" -float "0"

  # Add Narrow Spaces to Left Side of the Dock to Better Organize Apps(where the Applications Are).
  defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="small-spacer-tile";}'

  # Make Hidden App Icons Translucent in the Dock.
  defaults write com.apple.dock showhidden -bool "YES"

  # Show indicator lights for open applications in the Dock.
  defaults write com.apple.dock show-process-indicators -bool "true"

  # Group windows by application.
  defaults write com.apple.dock "expose-group-apps" -bool "true"

  # Enable the status bar in Finder.
  defaults write com.apple.finder ShowStatusBar -bool "true"

  # Search the current folder by default.
  defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"

  # Automatically empty bin after 30 days.
  defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"

  # Enable Text Selection in Quick Look Windows.
  defaults write com.apple.finder QLEnableTextSelection -bool "true"

  # Empty Trash securely by default
  defaults write com.apple.finder EmptyTrashSecurely -bool "true"

  # Always show expanded save dialogs
  defaults write -g NSNavPanelExpandedStateForSaveMode -bool "true"

  # Set the format of Menu Bar digital clock to "EEE d MMM HH:mm:ss".
  defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE d MMM HH:mm:ss\""

  # Dragging with three finger drag.
  defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"

  # Repeats the key as long as it is held down.
  defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "false"

  # Show the build duration in the Xcode's toolbar.
  defaults write com.apple.dt.Xcode "ShowBuildOperationDuration" -bool "true"

  killall Dock
  killall Finder

  ok "macos defaults"
}

install_defaults
