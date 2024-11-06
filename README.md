# gavento's dotfiles

Dotfiles for dev-containers and remote servers; mostly config for zsh, git, tmux, etc.

Managed with `yadm` (downloaded or distro-provided), ZSH modules managed by `zimfw` (in-tree), with all modlues kept in-tree and updated only explicitly. 

## Install

### Apt-based systems with root or sudo

Requires `curl`. Also installs `zsh`, `git`, and bunch of extra useful tools via apt. Sets your shell to `zsh`.

```
curl https://raw.githubusercontent.com/gavento/dotfiles/refs/heads/main/.local/bin/dotfiles-install.sh | sh
```

### Without root or apt

Requires `curl`, `git` and `zsh`, does not change your shell.

```
# Install yadm if not installed globally
curl -fLo ~./local/bin/yadm https://raw.githubusercontent.com/yadm-dev/yadm/refs/tags/3.2.2/yadm && chmod a+x ~./local/bin/yadm
~./local/bin/yadm clone https://github.com/gavento/dotfiles
```

TODO: chech yadm hash?

### Devpod

Explicitly:
```sh
devpod up . --dotfiles https://github.com/gavento/dotfiles --dotfiles-script .local/bin/dotfiles-install.sh
```

Automated (included in dotfile devpod config):
```
devpod context set-options -o DOTFILES_URL=https://github.com/gavento/dotfiles                                                                                                              
devpod context set-options -o DOTFILES_SCRIPT=.local/bin/dotfiles-install.sh
```

