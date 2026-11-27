# Commit Scopes

Conventional commit messages in this repository use a scope that names the affected software. Each top-level directory holds one piece of software, so the scope is the directory name.

```
feat(zed): open CLI-launched projects in a new window
fix(nvim): correct telescope keybinding
chore(brew): update packages
```

## Valid scopes

The valid scope is the exact, lowercase directory name. Hyphens are part of the name (`macos-defaults`, never `macos`).

| Scope | Covers |
| --- | --- |
| `brew` | Homebrew packages (`Brewfile`, `update.sh`) |
| `direnv` | direnv configuration |
| `fish` | fish shell configuration |
| `ghostty` | Ghostty terminal configuration |
| `git` | git configuration (`gitconfig`, `gitignore`) |
| `glow` | glow configuration |
| `macos-defaults` | macOS system defaults |
| `npm` | global npm packages |
| `nvim` | Neovim configuration |
| `proxychains` | proxychains configuration |
| `raycast` | Raycast scripts |
| `rex` | rex configuration |
| `shell` | POSIX shell scripts shared by zsh (`aliases.sh`, `env.sh`) |
| `skills` | skill installs |
| `starship` | starship prompt configuration |
| `tmux` | tmux configuration |
| `vim` | Vim configuration (`vimrc`) |
| `zed` | Zed editor settings |
| `zsh` | zsh configuration (`zshrc`) |

A new top-level directory becomes a new scope with the same name.

## Root-level and repo-wide changes

Use `*` when a change touches repository-level files or the whole repo, such as `install.sh`, `utils.sh`, the `Makefile`, `README.md`, or `.gitignore`:

```
chore(*): remove sql-formatter
```

## Multiple scopes

When one change spans several directories, list their scopes comma-separated without spaces, in alphabetical order:

```
feat(shell,tmux): add status helpers
```

Prefer one commit per scope. Reach for multiple scopes only when the change is genuinely one unit of work across those directories.
