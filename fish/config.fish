###
# Environments
###
# You may need to manually set your language environment
set -gx LANG 'en_US.UTF-8'

# Edit files by neovim
set -gx EDITOR 'nvim'

# Set go path
set -gx GOPATH "$HOME/.go"

# Set $PATH
fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/bin
fish_add_path $HOME/.go/bin
fish_add_path $HOME/.cargo/bin

# Proxy brew source with tsinghua.
# Doc: https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
set -gx HOMEBREW_API_DOMAIN 'https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api'
set -gx HOMEBREW_BOTTLE_DOMAIN 'https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles'
set -gx HOMEBREW_BREW_GIT_REMOTE 'https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git'

# Set theme for bat syntax highlighting.
# Or just call bat with the --theme=DarkNeon option
set -gx BAT_THEME 'DarkNeon'

# Set fzf layout: https://github.com/junegunn/fzf#layout
set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --style full --info=inline --border --preview="bat --color=always --style=numbers --line-range=:100 {}" --preview-window="right:60%" --bind "up:preview-up,down:preview-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down"'
set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

# Set up fzf key bindings and fuzzy completion. See https://github.com/junegunn/fzf#setting-up-shell-integration for more details.
if command -q fzf
  fzf --fish | source
end

# Set up zoxide. See https://github.com/ajeetdsouza/zoxide for more details.
if command -q zoxide
  zoxide init fish | source
end

# Set up direnv. See https://github.com/direnv/direnv/blob/master/docs/hook.md for more details.
if command -q direnv
  direnv hook fish | source
end
