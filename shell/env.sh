# Set editor to nvim.
export EDITOR="nvim"

# Setup go path
export GOPATH="$HOME/.go"
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.go/bin:$HOME/.cargo/bin:/opt/homebrew/bin:/usr/local/sbin:$PATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# https://github.com/pstadler/keybase-gpg-github#optional-setting-up-tty
GPG_TTY=$(tty)
export GPG_TTY

# Proxy brew source with tsinghua.
# Doc: https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"

# Set theme for bat syntax highlighting.
# Or just call bat with the --theme=DarkNeon option
export BAT_THEME="Solarized (dark)"

# Set fzf layout: https://github.com/junegunn/fzf#layout
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --style full --info=inline --border --preview="bat --color=always --style=numbers --line-range=:100 {}" --preview-window="right:60%" --bind "up:preview-up,down:preview-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down"'
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --follow --exclude .git --exclude dist'

# Activate delta side-by-side view by default
export DELTA_FEATURES=+side-by-side

# Load private environment variables.
if [[ -f "$HOME/.env.private" ]]; then
  source $HOME/.env.private
fi
