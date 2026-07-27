### Completion

autoload -Uz compinit
mkdir -p ~/.cache/zsh
# -u: don't interrogate directory ownership before loading completions. These
# are all single-user machines we own; the alternative is an interactive
# "ignore insecure directories?" prompt on every new shell. Drop the -u if a
# box is ever shared.
compinit -u -d ~/.cache/zsh/zcompdump

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.cache/zsh/zcompcache

# TAB behaviour: insert the longest unambiguous prefix and LIST the candidates.
# Never open a cycling menu -- a second TAB just re-lists.
#
# auto_menu is what made the second TAB start cycling; zimfw additionally set
# `menu select` at a five-colon specificity that beat any plain override.
unsetopt auto_menu
unsetopt menu_complete
zstyle ':completion:*' menu no
# List immediately even when a prefix was just inserted -- by default zsh
# stays silent on the TAB that inserts and only lists on the next one.
unsetopt list_ambiguous

# Completing on the text before the cursor (ignoring the rest of the word) is
# handled by the expand-or-complete-prefix widget in 50-keybindings.zsh, not by
# complete_in_word -- the two would fight over where the cursor ends up.

# Case-insensitive: typed lowercase also matches uppercase candidates.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Most distros only export LS_COLORS to bash (via /etc/profile.d); generate
# it if absent so the listing below and ls get their colours.
if [[ -z $LS_COLORS ]] && (( $+commands[dircolors] )); then
    eval "$(dircolors -b)"
fi
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true          # offer ./ and ../
zstyle ':completion:*:git-checkout:*' sort false  # keep git's own ordering

setopt glob_dots        # complete dotfiles without typing the leading dot
setopt auto_param_slash # a completed directory gets a real trailing /

# Note: the `/` you see against directories in the completion LISTING comes
# from LIST_TYPES (on by default) and is a type marker, like `ls -F` -- it is
# decoration, never part of the inserted text. When several candidates share a
# prefix only that prefix is inserted, so there is no slash to add yet.
