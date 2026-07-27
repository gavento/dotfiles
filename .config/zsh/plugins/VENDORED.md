# Vendored zsh plugins

Plain files, sourced directly by `.config/zsh/rich/70-plugins.zsh`. No plugin
manager. Versions are those that were in-tree under zimfw as of 2024-11.

| File | Upstream |
|---|---|
| `zsh-autosuggestions.zsh` | https://github.com/zsh-users/zsh-autosuggestions |
| `zsh-syntax-highlighting.zsh` + `highlighters/` | https://github.com/zsh-users/zsh-syntax-highlighting |
| `zsh-z.zsh` (+ `../functions/_zshz`) | https://github.com/agkozak/zsh-z |

Only the `main` and `brackets` highlighters are vendored; upstream ships seven.

To refresh one, download the single distribution file from upstream and replace
it here. Syntax-highlighting resolves `highlighters/` relative to its own path,
so that directory must stay alongside it.
