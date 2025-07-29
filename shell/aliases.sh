alias vim="$(command -v nvim)"

alias ls='ls -G'              # Enable colorized output by default
alias la='ls -G --all'        # Create `la` as a shortcut for `ls --all`
alias diff='diff -u'          # diff file changes
alias cdiff='colordiff -y'    # colorize diff output.

# Get ip as soon as possible.
alias ip='curl -s https://httpbin.org/ip | jq ".origin"' # Get the external IP address
alias iip='get_internal_ip'                              # Get the internal IP address

# Quick start or close proxy
alias pon='export http_proxy=http://proxy.internal:5451;export https_proxy=$http_proxy; export all_proxy=$http_proxy;'
alias poff='unset http_proxy;unset https_proxy; unset all_proxy;'
alias proxy='export http_proxy=http://proxy.internal:5451;export https_proxy=$http_proxy; export all_proxy=$http_proxy;'
alias unproxy='unset http_proxy;unset https_proxy; unset all_proxy;'

# Format changed only
alias pretty='prettier -w $(git diff --name-only --diff-filter=AM)'

alias runx='pnpm run $(jq -r ".scripts|to_entries[]|.key" package.json | fzf --tmux center --border-label=" pnpm run " --style full --preview="jq -r '\''.scripts.\"{}\"'\'' package.json | bat -l bash")'
alias runs='cat package.json | jq ".scripts"'

# Alias for open_brew_package_home function
# Shortcut to quickly open a brew package's homepage
alias brew_home='open_brew_package_home'

# Better `ls`
alias lsx='eza'
