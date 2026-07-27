### Prompt
#
#   user@host ~/dev/dotfiles %
#
# The path collapses to its last $PROMPT_SHOW_COMPONENTS components once it is
# deeper than $PROMPT_PATH_DEPTH. Override any of these in local.zsh.

: ${PROMPT_PATH_DEPTH:=4}
: ${PROMPT_SHOW_COMPONENTS:=3}
: ${PROMPT_USER_HOST_COLOR:=yellow}

setopt prompt_subst

# Root gets '#', everyone else '%'. Resolved once at startup rather than with
# zsh's %#, which treats "holds any capability at all" as privileged and so
# shows '#' inside containers that merely have e.g. CAP_SYS_CHROOT.
if (( EUID == 0 )); then
    _prompt_sigil='#'
else
    _prompt_sigil='%%'   # renders as a literal %
fi

# Rebuild the path spec only when the directory changes. The previous version
# called this through $(...) inside PROMPT, forking a subshell on every redraw.
# Prompt escapes survive being stored in a variable: PROMPT_SUBST expands
# parameters first, and the result is then scanned for % escapes.
_prompt_set_path() {
    local depth=$PROMPT_PATH_DEPTH
    # Under $HOME the leading ~ counts as one component, so allow one more.
    [[ $PWD == $HOME* ]] && (( depth++ ))
    _prompt_path="%(${depth}~|.../%${PROMPT_SHOW_COMPONENTS}~|%~)"
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _prompt_set_path
_prompt_set_path

# Recompute at the first prompt as well: local.zsh is sourced after this
# file and may override the PROMPT_* knobs above.
_prompt_set_path_once() {
    _prompt_set_path
    add-zsh-hook -d precmd _prompt_set_path_once
    unfunction _prompt_set_path_once
}
add-zsh-hook precmd _prompt_set_path_once

PROMPT='%F{$PROMPT_USER_HOST_COLOR}%n@%m%f %F{blue}${_prompt_path}%f %(?.%f.%F{red})${_prompt_sigil}%f '
