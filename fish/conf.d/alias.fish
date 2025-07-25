###
# alias
###
alias vim='/usr/local/bin/nvim'

# Quick start or close proxy
alias pon='set -gx http_proxy http://proxy.internal:5451 && set -gx https_proxy $http_proxy && set -gx all_proxy $http_proxy'
alias poff='set -e http_proxy && set -e https_proxy && set -e all_proxy'
alias proxy='set -gx http_proxy http://proxy.internal:5451 && set -gx https_proxy $http_proxy && set -gx all_proxy $http_proxy'
alias unproxy='set -e http_proxy && set -e https_proxy && set -e all_proxy'

# Format changed only
abbr -a -- pretty 'prettier -w $(git diff --name-only --diff-filter=AM)'

