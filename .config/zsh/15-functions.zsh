### Autoloaded functions and completions
#
# Must run before compinit (20-completion.zsh) so these directories are on
# $fpath when the completion system scans it.
#
#   ~/.config/zsh/functions      own functions, tracked in the repo
#   ~/.local/share/zsh/functions installed completions (e.g. yadm's _yadm)

functions_dir=${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions
fpath=($functions_dir $HOME/.local/share/zsh/functions $fpath)

# Autoload everything in functions/ that is not a completion (_foo) or hidden.
functions_list=($functions_dir/[^._]*(N:t))
(( $#functions_list )) && autoload -Uz $functions_list

unset functions_dir functions_list
