### Command-line syntax highlighting (rich class only)
#
# MUST be sourced last: it wraps the ZLE widgets that exist at load time, so
# anything defining widgets afterwards will not be highlighted. Hence 90-, the
# highest-numbered fragment.
#
# Upstream ships seven highlighters; only `main` and `brackets` are vendored.
# The highlighters/ directory is resolved relative to the plugin file, so the
# two must stay together.

plugins_dir=${XDG_CONFIG_HOME:-$HOME/.config}/zsh/plugins

if [[ -r $plugins_dir/zsh-syntax-highlighting.zsh ]]; then
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
    source $plugins_dir/zsh-syntax-highlighting.zsh
fi

unset plugins_dir
