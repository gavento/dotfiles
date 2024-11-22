# gavento's dotfiles

Dotfiles for dev-containers and remote servers; mostly my configs for zsh, git, tmux, etc.

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
curl -fL https://raw.githubusercontent.com/gavento/dotfiles/refs/heads/main/.local/bin/dotfiles | bash -s - bootstrap-system
```

### Devpod

Devpod first clones the repo before calling `./bootstrap.sh` or similar, so that script is located in the `gavento/dotfiles-bootstrap` repo.

Calling devpod explicitly:
```sh
devpod up . --dotfiles https://github.com/gavento/dotfiles-bootstrap
```

Automated (included in dotfile devpod config):
```
devpod context set-options -o DOTFILES_URL=https://github.com/gavento/dotfiles-bootstrap
```

