###
# alias
###
alias vim='/usr/local/bin/nvim'

# Quick start or close proxy
alias proxy='set -gx http_proxy http://proxy.internal:12345; set -gx https_proxy $http_proxy; set -gx all_proxy $http_proxy; set -gx HTTP_PROXY $http_proxy; set -gx HTTPS_PROXY $https_proxy;'
alias unproxy='set -e http_proxy; set -e https_proxy; set -e all_proxy; set -e HTTP_PROXY; set -e HTTPS_PROXY;'
alias pon='proxy'
alias poff='unproxy'

# Format changed only
abbr -a -- pretty 'prettier -w $(git diff --name-only --diff-filter=AM)'

