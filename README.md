# Dotfiles

Tracking my own dotfiles. Those are opinionated and contains only my own personal settings.

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
