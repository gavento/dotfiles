### Listing aliases
#
#   ll  long
#   la  long, including dotfiles
#   lS  as la, sorted by size, largest LAST (nearest the prompt)
#   lT  as la, sorted by mtime, newest LAST
#   lU  as lS but with recursive directory totals (lsd/eza only)
#
# Sorting puts the interesting entries at the bottom, next to the prompt.
# Backend preference: lsd, then eza, then plain ls.

if (( $+commands[lsd] )); then
    _ls="lsd --icon=never --size bytes"
    alias ll="$_ls -l"
    alias la="$_ls -la"
    alias lS="$_ls -la -Sr"
    alias lU="$_ls -la -Sr --total-size"
    alias lT="$_ls -la -tr"
elif (( $+commands[eza] )); then
    # -B alone, deliberately: combined with -b, the binary prefixes silently
    # win and sizes stop being plain bytes. Bare --hyperlink is a no-op in
    # current eza; it needs =always.
    _ls="eza -B --git --icons=never --hyperlink=always --time-style=relative"
    alias ll="$_ls -l"
    alias la="$_ls -la"
    alias lS="$_ls -la -ssize"
    alias lU="$_ls -la -ssize --total-size"
    alias lT="$_ls -la -snewest"
else
    _ls="ls --color=auto"
    alias ll="$_ls -l"
    alias la="$_ls -la"
    alias lS="$_ls -la -Sr"
    alias lT="$_ls -la -tr"
    # No lU: plain ls cannot compute recursive directory sizes.
fi
unset _ls

# No bat/batcat alias by design -- on Debian the binary is `batcat`, elsewhere
# it is `bat`, and aliasing across that difference previously ended up
# shadowing a real `bat` with `cat` on non-Debian systems.

alias grep='grep --color=auto'
