# gavento's dotfiles

Dotfiles for dev-containers and remote servers; mostly zsh, git, tmux, etc. config.

## Install

Requires `git` and `zsh` first, so you may need `apt update && apt install -y git zsh sudo` first in some minimal containers.

```
cd
git clone https://github.com/gavento/dotfiles --bare .dotfiles
git --git-dir=.dotfiles --work-tree=. checkout
git --git-dir=.dotfiles --work-tree=. submodule update --init --recommend-shallow
zsh -c "source ~/.zshrc && dot-install" # Changes shell to zsh and tries to `sudo apt install` basic tools
```

## ZSH

* Various personal settings (path, history, ...)
* Richer `la`, `ll`, ... via `lsd`, `exa`, or just `ls`
* `z`-command (pure-zsh impl)
* Local aliases for some machines
 
