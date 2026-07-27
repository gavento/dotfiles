# gavento's dotfiles

Configs for zsh, tmux, git, ssh and vim, in two tiers:

- **base** — anything with `zsh` on it. No plugins, no binaries, no plugin
  manager. Drops onto a strange server and works.
- **rich** — laptop, devboxes, containers. Adds vendored zsh plugins and
  pinned tools (fzf, uv, gitleaks).

`$HOME` *is* the work tree, managed with a **vendored** `yadm`. That means
files are live where they belong: no symlinks, no source directory, no apply
step, and `dotfiles add ~/.foo` tracks a file without moving it.

## Install

Needs `git`. `zsh` too, if you want the shell.

```sh
curl -fL https://raw.githubusercontent.com/gavento/dotfiles/main/bootstrap.sh | bash
```

Useful flags — `--system` installs base packages first (needs root/sudo),
`--class rich` selects the rich tier, `--no-tools` skips the binary installs:

```sh
curl -fL .../bootstrap.sh | bash -s -- --system --class rich
```

The script clones the repo, extracts just the machinery (`yadm`, `dotfiles`,
`tools.tsv`), installs the pinned tools, and then checks out the rest of
`$HOME`. That checkout **refuses to overwrite any pre-existing file**: git
names every path that is in the way and changes nothing. Move those aside —

```sh
mv ~/.zshrc ~/.zshrc.pre-dotfiles
dotfiles checkout
```

— and the checkout finishes. Nothing you already had is lost by running the
bootstrap.

`bootstrap.sh` does not download yadm. yadm lives in this repo at
`.local/bin/yadm`, and a yadm repo is just a bare git repo with three config
settings — so plain `git` lays it down and the checkout produces yadm itself.

## Day to day

```sh
dotfiles status              # modified files, NEW files in managed dirs, upstream drift
dotfiles update              # show what upstream will overwrite, then fast-forward
dotfiles add ~/.config/zsh/70-thing.zsh
dotfiles commit -m "..."     # anything unrecognised falls through to yadm
dotfiles class rich          # set this machine's tier
dotfiles tools list          # pinned vs installed
dotfiles tools install       # install/refresh pinned binaries
dotfiles tools outdated      # check upstream for newer releases
```

`status` is precise because `.gitignore` is an **allowlist**: `/*` ignores all
of `$HOME`, then managed paths are re-included. So a new file appearing in
`~/.config/zsh/` is reported, while `~/Downloads` and `~/dev` stay silent.

## Layout

```
.zshrc                     loader: numbered fragments, then rich/, then local
.config/zsh/
  10-history  15-functions  20-completion  30-prompt
  40-aliases  50-keybindings  60-tmux-over-ssh          base, always sourced
  rich/70-plugins  rich/90-syntax-highlighting          rich tier only
  plugins/                                              vendored, plain `source`
  local.zsh                                             gitignored
.tmux.conf                 per-window repo:branch labels in the status bar
.gitconfig .ssh/config .vimrc
.local/bin/
  yadm                     vendored 3.5.0
  dotfiles                 the CLI above
  tmux-window-label        status-bar helper
  jsctl  i  ipython-session.py
.local/share/dotfiles/tools.tsv    pinned versions + sha256, per arch
bootstrap.sh
```

## Two override mechanisms, kept separate

| | Mechanism | Example |
|---|---|---|
| **class** (tier) | `~/.config/dotfiles/class`, set by `dotfiles class` | tmux picks `tmux-256color` vs `screen-256color` |
| **machine** | gitignored local files | `~/.config/zsh/local.zsh`, `~/.ssh/config.d/*`, `~/.config/git/local`, `~/.config/tmux/host-<hostname>.conf`, `~/.tmux_local.conf` |

Per-machine variation is done with small gitignored include files, never by
editing a tracked one. Every config here has an include hook: zsh sources
`local.zsh` last, ssh includes `config.d/*` first (that is also where each
machine's default `IdentityFile` lines live), git includes
`~/.config/git/local`, and tmux sources `host-<hostname>.conf` — a per-machine
status-bar colour, so you can tell at a glance which box you are on — with
`~/.tmux_local.conf` as the general escape hatch. yadm's `##class.*`
alternates are configured (`alt-copy = true`) and remain available for a
format with no include mechanism of its own, but none are in use: `yadm alt`
overwrites its targets silently, so an include beats an alternate whenever
there is a choice.

## Plugins

No plugin manager. Three plugins are vendored as plain files under
`.config/zsh/plugins/` and sourced directly — see `plugins/VENDORED.md` for
provenance and how to refresh them. fzf's key bindings come from `fzf --zsh`.

Previously this was zimfw with 441 vendored files; it is now 6.
