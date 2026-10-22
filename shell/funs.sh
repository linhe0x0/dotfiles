# Function to get the internal IP address of the current machine
#
# Automatically detects the operating system and uses appropriate commands:
# - On macOS: Uses ipconfig with the default network interface
# - On Linux: First tries hostname -I, falls back to ip route if needed
# Returns the first valid internal IP address found
#
# Usage: get_internal_ip (no arguments needed)
#
# This function is aliased as 'iip' for convenience
get_internal_ip() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # For macOS
    ipconfig getifaddr $(route get default | awk '/interface:/ {print $2}')
  else
    # For Linux
    hostname -I | awk '{print $1}' 2>/dev/null ||
      ip route get 1.2.3.4 | awk '{for(i=1;i<=NF;i++)if($i=="src")print $(i+1)}'
  fi
}

# Open a brew package's homepage in the default browser
#
# Usage: open_brew_package_home <package>
#
# Output is one line, always:
#   success -> "→ <url>"   (already open in your browser)
#   failure -> "✗ <reason>" (and a non-zero exit)
#
open_brew_package_home() {
  if (($# == 0)); then
    echo "✗ Which package?" >&2
    return 1
  fi

  local url
  url=$(brew info "$1" 2>/dev/null | awk '/^https?:\/\// {print; exit}')

  if [[ -z "$url" ]]; then
    echo "✗ '$1' not found (no formula or cask by that name)" >&2
    return 1
  fi

  open "$url" && echo "→ $url"
}

# SSH Port Forwarding Functions
#
# Usage:
#   ssh_forward_port <host> <port1> [port2] ...  - Forward local ports to remote host
#   ssh_disconnect_port <port1> [port2] ...     - Disconnect port forwarding
#   ssh_list_forwards                          - List active port forwards
#
# Aliases: fip, dip, lip
ssh_forward_port() {
  (($# < 2)) && echo "Usage: fip <host> <port1> [port2] ..." && return 1
  local host="$1"
  shift
  for port in "$@"; do
    ssh -f -N -L "$port:localhost:$port" "$host" && echo "Forwarding localhost:$port -> $host:$port"
  done
}

ssh_disconnect_port() {
  (($# == 0)) && echo "Usage: dip <port1> [port2] ..." && return 1
  for port in "$@"; do
    pkill -f "ssh.*-L $port:localhost:$port" && echo "Stopped forwarding port $port" || echo "No forwarding on port $port"
  done
}

ssh_list_forwards() {
  pgrep -af "ssh.*-L [0-9]+:localhost:[0-9]+" || echo "No active forwards"
}

# Open a dev layout in tmux: the left pane stays as a plain shell for you to
# start the AI agent manually, the right side splits into lazygit (top two
# thirds) and a terminal (bottom third). Herdr is not involved. The window
# is named dev-<slug>, where slug is the enclosing git repository's name
# (the current directory when outside a repo). Inside tmux it focuses the
# dev-<slug> window if one exists, otherwise the current window is renamed
# and the layout is built in place; outside tmux it
# creates and attaches a session named dev first (attaching to the existing
# one if it already exists).
#
# This function is aliased as 'tdl' for convenience.
tmux_dev_layout() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || root=$PWD
  local slug="${root##*/}"
  slug="${slug//[.:]/-}" # avoid '.' and ':' in tmux names
  local name="dev-$slug"

  local left right term
  if [[ -n "$TMUX" ]]; then
    if tmux list-windows -F '#{window_name}' | grep -qx "$name"; then
      tmux select-window -t "$name"
      return
    fi
    tmux rename-window "$name"
    left=$(tmux display-message -p '#{pane_id}')
  else
    if tmux has-session -t dev 2>/dev/null; then
      tmux attach -t dev
      return
    fi
    tmux new-session -d -s dev -n "$name" -c "$PWD"
    left=$(tmux list-panes -t dev: -F '#{pane_id}')
  fi

  # Layout: the left pane is left empty (run your agent there); the right
  # third splits into lazygit (top two thirds) and a terminal (bottom third).
  right=$(tmux split-window -h -l 33% -t "$left" -c "$PWD" -P -F '#{pane_id}')
  term=$(tmux split-window -v -l 33% -t "$right" -c "$PWD" -P -F '#{pane_id}')

  tmux send-keys -t "$right" 'lazygit' Enter

  tmux select-pane -t "$left"
  if [[ -z "$TMUX" ]]; then
    tmux attach -t dev
  fi
}

# Run a command while preventing idle sleep (wraps it in caffeinate -i)
#
# Usage: nosleep <command> [args...]
# Example: nosleep ./slow-build.sh
#
# Exits with the wrapped command's exit status
nosleep() {
  echo "🔋 Mac will stay awake while the command runs; sleep resumes automatically when it finishes."
  caffeinate -i "$@"
}

# Prevent idle sleep or display sleep (caffeinate wrappers)
#
# Each prints a hint, then runs caffeinate until Ctrl-C (or for a fixed time).
# Extra args are passed through, e.g. `stay ./build.sh`
stay() {
  echo "🔋 Mac will stay awake until you press Ctrl-C"
  caffeinate -i "$@"
}

screenon() {
  echo "🔋 Display will stay on until you press Ctrl-C"
  caffeinate -d "$@"
}

stay1h() {
  echo "🔋 Mac will stay awake for the next hour"
  caffeinate -i -t 3600 "$@"
}

stay2h() {
  echo "🔋 Mac will stay awake for the next 2 hours"
  caffeinate -i -t 7200 "$@"
}

stay4h() {
  echo "🔋 Mac will stay awake for the next 4 hours"
  caffeinate -i -t 14400 "$@"
}

stay8h() {
  echo "🔋 Mac will stay awake for the next 8 hours"
  caffeinate -i -t 28800 "$@"
}

# Git worktree workflow
#
# Worktrees live in a sibling directory of the main worktree, named
# "<repo>-worktree". A branch's "/" becomes "-" in its directory name:
#   repo:  ~/Sites/github.com/acme/api              (main worktree)
#   work:  ~/Sites/github.com/acme/api-worktree/feat-login
#
# Aliases: gwf gwl gwa gwn gwr gwd gwp (see aliases.sh)
git_worktree_main() {
  git worktree list --porcelain 2>/dev/null | sed -n 's/^worktree //p' | head -n 1
}

# Add a worktree and cd into it. Shared by gwa and gwn:
#   git_worktree_add <branch>     check out an existing branch
#   git_worktree_add -b <branch>  create the branch, then its worktree
git_worktree_add() {
  local create=false
  if [[ "$1" == "-b" ]]; then
    create=true
    shift
  fi
  if (($# != 1)); then
    echo "Usage: gwa <branch> | gwn <branch>" >&2
    return 1
  fi

  local branch="$1"
  if [[ "$create" == true ]] && git show-ref --verify --quiet "refs/heads/$branch"; then
    echo "✗ Branch '$branch' already exists (use gwa to check it out)" >&2
    return 1
  fi
  if [[ "$create" == false ]] && ! git show-ref --verify --quiet "refs/heads/$branch"; then
    echo "✗ Branch '$branch' not found (use gwn to create it)" >&2
    return 1
  fi

  # Never name a local 'path': in zsh it shadows the tied PATH array.
  local main parent dir
  main=$(git_worktree_main) || return 1
  parent="$(dirname "$main")/${main##*/}-worktree"
  dir="$parent/${branch//\//-}"
  mkdir -p "$parent"

  if [[ "$create" == true ]]; then
    git worktree add -b "$branch" "$dir" || return 1
  else
    git worktree add "$dir" "$branch" || return 1
  fi
  cd "$dir" && echo "→ $dir"
}

# Remove a worktree. Without arguments, pick one with fzf (the main
# worktree is excluded). Dirty worktrees are refused by git; pass a path
# and --force yourself if you really want to discard them.
git_worktree_remove() {
  if (($# == 0)); then
    local main sel list
    main=$(git_worktree_main) || return 1
    list=$(git worktree list | awk -v main="$main" '$1 != main')
    if [[ -z "$list" ]]; then
      echo "No linked worktrees"
      return 0
    fi
    sel=$(fzf --tmux center --border-label=" git worktree " --style full \
      --preview="git -C {1} status -sb" \
      --header="enter = remove, esc = cancel" <<< "$list") || return 0
    [[ -n "$sel" ]] || return 0
    set -- "${sel%% *}"
  fi
  git worktree remove "$@" && echo "→ Removed $*"
}

# Finish the work in a linked worktree: fast-forward the branch checked out
# in the main worktree to the worktree's branch, then remove the worktree,
# delete the branch, and cd back to the main worktree. Nothing is pushed.
#   git_worktree_finish            finish the current worktree, or pick one
#                                  with fzf when run from the main worktree
#   git_worktree_finish <path>     finish the worktree at that path
# A dirty worktree is refused (ignored files don't count). If the branch has
# diverged from the main worktree's branch, the merge is refused and nothing
# is cleaned up; rebase the worktree branch yourself.
git_worktree_finish() {
  git rev-parse --git-dir >/dev/null 2>&1 || { echo "✗ Not inside a git repository" >&2; return 1; }
  local main dir="$1"
  main=$(git_worktree_main) || return 1
  if [[ -n "$dir" ]]; then
    dir=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null) || { echo "✗ Not a worktree: $1" >&2; return 1; }
  else
    # Inside a linked worktree? Finish it; otherwise pick one with fzf.
    dir=$(git rev-parse --show-toplevel)
    if [[ "$dir" == "$main" ]]; then
      local sel list
      list=$(git worktree list | awk -v main="$main" '$1 != main')
      if [[ -z "$list" ]]; then
        echo "No linked worktrees (create one with gwn <branch>)"
        return 0
      fi
      sel=$(fzf --tmux center --border-label=" git worktree " --style full \
        --preview="git -C {1} status -sb" \
        --header="enter = finish, esc = cancel" <<< "$list") || return 0
      [[ -n "$sel" ]] || return 0
      dir="${sel%% *}"
    fi
  fi
  if [[ "$dir" == "$main" ]]; then
    echo "✗ $dir is the main worktree; run gwd inside a linked worktree or pass its path" >&2
    return 1
  fi

  local branch base
  branch=$(git -C "$dir" branch --show-current)
  if [[ -z "$branch" ]]; then
    echo "✗ Detached HEAD in $dir; nothing to merge" >&2
    return 1
  fi
  base=$(git -C "$main" branch --show-current)
  if [[ -z "$base" ]]; then
    echo "✗ Main worktree is in detached HEAD state; cannot merge" >&2
    return 1
  fi
  if [[ -n "$(git -C "$dir" status --porcelain)" ]]; then
    echo "✗ Worktree is dirty; commit or stash first" >&2
    return 1
  fi

  if ! git -C "$main" merge --ff-only "$branch"; then
    echo "✗ Cannot fast-forward $base to $branch; rebase the worktree branch first (worktree kept)" >&2
    return 1
  fi
  cd "$main" || return 1
  git worktree remove "$dir" || return 1
  git branch -d "$branch" &&
    echo "→ Merged $branch into $base; removed worktree and branch"
}

# Fuzzy find a linked worktree of the current repository and cd into it.
# Entries show "<branch> <path>", with paths relative to the main repo's
# root directory (e.g. ../api-worktree/feat-login); the main worktree is
# excluded. Worktrees outside that directory tree show absolute paths.
git_worktree_cd() {
  git rev-parse --git-dir >/dev/null 2>&1 || { echo "✗ Not inside a git repository" >&2; return 1; }
  local main list sel dest
  main=$(git_worktree_main) || return 1
  list=$(git worktree list |
    awk -v main="$main" -v parent="$(dirname "$main")" '$1 != main {
      branch = "(detached)"
      if (match($0, /\[[^]]+\]/))
        branch = substr($0, RSTART + 1, RLENGTH - 2)
      p = $1
      if (index(p, parent "/") == 1)
        p = "../" substr(p, length(parent) + 2)
      printf "%-28s %s\n", branch, p
    }')
  if [[ -z "$list" ]]; then
    echo "No linked worktrees (create one with gwn <branch>)"
    return 0
  fi
  sel=$(fzf --tmux center --border-label=" git worktree " --style full \
    --preview="git -C {2} status -sb" <<< "$list") || return 0
  [[ -n "$sel" ]] || return 0
  sel="${sel%%$'\n'*}" # --filter/--multi can emit several lines; keep the best-ranked one
  # Relative entries are anchored to the main repo's root, not $PWD.
  dest="${sel##* }"
  [[ "$dest" == /* ]] || dest="$main/$dest"
  cd "$dest"
}
