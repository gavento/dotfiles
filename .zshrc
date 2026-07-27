# Interactive shell configuration.
#
# Fragments in ~/.config/zsh/ are sourced in numeric order. Machines with the
# "rich" class additionally get the rich/ set (plugins, fzf, z) -- base is pure
# zsh with no vendored code, so it works on any box that merely has zsh.
#
# Two independent override mechanisms, deliberately not overlapping:
#   class   -> ~/.config/dotfiles/class, written by `dotfiles class`
#   machine -> ~/.config/zsh/local.zsh, gitignored

zsh_conf=${XDG_CONFIG_HOME:-$HOME/.config}/zsh

for zsh_frag in $zsh_conf/[0-9][0-9]-*.zsh(N); do
    source $zsh_frag
done

if [[ -r ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/class ]] &&
   [[ "$(<${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/class)" == rich ]]; then
    for zsh_frag in $zsh_conf/rich/[0-9][0-9]-*.zsh(N); do
        source $zsh_frag
    done
fi

[[ -r $zsh_conf/local.zsh ]] && source $zsh_conf/local.zsh

unset zsh_conf zsh_frag
