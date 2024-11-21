# gavento's dotfiles

Dotfiles for dev-containers and remote servers; mostly config for zsh, git, tmux, etc.

Managed with `yadm` (downloaded or distro-provided), ZSH modules managed by `zimfw` (in-tree), with all modlues kept in-tree and updated only explicitly. 

## Install

There is an install script `.local/bin/dotfiles` (bash) to be called locally or via `curl ... | bash`. You may want to change your shell to `zsh`.

### Local bootstrap

Requires `curl`, `git` and `zsh` to be installed. Also installs recent versions of `yadm`, `fzf`, and `uv` locally.

```
curl -fL https://raw.githubusercontent.com/gavento/dotfiles/refs/heads/main/.local/bin/dotfiles | bash -s - bootstrap
```

### Apt-based systems with root or sudo

Requires `curl` and `apt-get`. Installs `zsh`, `git`, and few other useful tools via apt, then runs the local bootstrap.

```
curl -fL https://raw.githubusercontent.com/gavento/dotfiles/refs/heads/main/.local/bin/dotfiles | bash -s - bootstrap-apt
```

### Devpod

TODO: Update

Explicitly:
```sh
devpod up . --dotfiles https://github.com/gavento/dotfiles --dotfiles-script .local/bin/dotfiles-install-via-apt.sh
```

Automated (included in dotfile devpod config):
```
devpod context set-options -o DOTFILES_URL=https://github.com/gavento/dotfiles                                                                                                              
devpod context set-options -o DOTFILES_SCRIPT=.local/bin/dotfiles-install-via-apt.sh
```

