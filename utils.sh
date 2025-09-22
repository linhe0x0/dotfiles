###
# Print an info-level message.
###
info() {
  printf "\r[ \033[00;34m..\033[0m ] $1\n"
}

###
# Print a warning-level message.
###
warn() {
  printf "\r[ \033[0;33m??\033[0m ] $1\n"
}

###
# Print a success-level message.
###
success() {
  printf "\r\033[2K[ \033[00;32mOK\033[0m ] $1\n"
}

###
# Print a fail-level message and exit the process by 1.
###
fail() {
  printf "\r\033[2K[\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit 1
}

# log install message.
install() {
  info "[$1] Installing..."
}

# log ok message.
ok() {
  success "[$1] OK"
}

###
# Confirm Y/n
#
# @param $1 The prompt message.
# @returns {Boolean}
#
# @example
#  if confirm "already exists, overwrite?"; then
#    echo "something"
#  fi
#
###
confirm() {
  read -p "$1 (Y/n): " resp

  if [ -z "$resp" ]; then
    response_lc="y" # empty is Yes
  else
    response_lc=$(echo "$resp" | tr '[:upper:]' '[:lower:]') # case insensitive
  fi

  [ "$response_lc" = "y" ]
}

###
# Link files
#
# @param $1 The source file path you want to link.
# @param $2 The destination file path you want to link to.
###
link_file() {
  info "Linking files: $1 => $2"

  local src=$1 dst=$2

  local action= overwrite= backup= skip=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then
    local currentSrc="$(readlink $dst)"

    if [ "$currentSrc" == "$src" ]; then
      skip=true
    else
      info "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
              [s]kip, [o]verwrite, [b]ackup?"
      read -n 1 action </dev/tty

      case "$action" in
        o)
          overwrite=true
          ;;
        b)
          backup=true
          ;;
        s)
          skip=true
          ;;
        *) ;;
      esac
    fi

    if [ "$overwrite" == "true" ]; then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]; then
      mv "$dst" "${dst}.bak"
      success "moved $dst to ${dst}.bak"
    fi

    if [ "$skip" == "true" ]; then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]; then # "false" or empty
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi

  success "Files linked"
}
