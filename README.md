# Dotfiles

Tracking my own dotfiles. Those are opinionated and contains only my own personal settings.

Commit messages follow [Conventional Commits](https://www.conventionalcommits.org) with the scope named after the affected top-level directory. See [docs/commit-message-guidelines.md](docs/commit-message-guidelines.md).

After installing, open a new terminal window to see the effects.

## Installation

Run the `./install.sh` to copy files over. It will prompt you before replacing if the files already exist.

```sh
git clone git@github.com/linhe0x0/dotfiles ~/.dotfiles
cd ~/.dotfiles
chmod u+x ./install.sh
./install.sh
```

To install brew packages:

```
cd brew && brew bundle
```
