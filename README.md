# gavento's dotfiles

Dotfiles for dev-containers and remote servers; mostly config for zsh, git, tmux, etc.

Managed with `yadm` (downloaded or distro-provided), ZSH modules managed by `zimfw` (in-tree), with all modlues kept in-tree and updated only explicitly. 

## Install

### Apt-based systems with root or sudo

Requires `curl`. Also installs `zsh`, `git`, and bunch of extra useful tools via apt. Sets your shell to `zsh` and installs recent `fzf` locally.

```
curl -fL https://raw.githubusercontent.com/gavento/dotfiles/refs/heads/main/.local/bin/dotfiles-install-via-apt.sh | bash
```

### Without root or apt

Requires `curl`, `git` and `zsh`, does not change your shell. Also installs `yadm` locally if not provided, and installs recent `fzf` locally.

```
curl -fL https://raw.githubusercontent.com/gavento/dotfiles/refs/heads/main/.local/bin/dotfiles-install-via-yadm.sh | bash
```

### Devpod

Explicitly:
```sh
devpod up . --dotfiles https://github.com/gavento/dotfiles --dotfiles-script .local/bin/dotfiles-install-via-apt.sh
```

Automated (included in dotfile devpod config):
```
devpod context set-options -o DOTFILES_URL=https://github.com/gavento/dotfiles                                                                                                              
devpod context set-options -o DOTFILES_SCRIPT=.local/bin/dotfiles-install-via-apt.sh
```

