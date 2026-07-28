### Listing aliases
#
#   ll  long, dotfiles included -- but not . and .. (-A, not -a)
#   la  as ll, plus . and .. (the only view that shows them)
#   lS  as ll, sorted by size, largest LAST (nearest the prompt)
#   lT  as ll, sorted by mtime, newest LAST
#   lU  as lS but with recursive directory totals (lsd/eza only)
#
# The sorted views use -A too: `..` in a size-sorted listing is noise, and
# with --total-size it makes lU walk the parent directory as well.
#
# Sorting puts the interesting entries at the bottom, next to the prompt.
# Backend preference: lsd, then eza, then plain ls.

if (( $+commands[lsd] )); then
    _ls="lsd --icon=never --size bytes"
    alias ll="$_ls -lA"
    alias la="$_ls -la"
    alias lS="$_ls -lA -Sr"
    alias lU="$_ls -lA -Sr --total-size"
    alias lT="$_ls -lA -tr"
elif (( $+commands[eza] )); then
    # -B alone, deliberately: combined with -b, the binary prefixes silently
    # win and sizes stop being plain bytes. Bare --hyperlink is a no-op in
    # current eza; it needs =always.
    _ls="eza -B --git --icons=never --hyperlink=always --time-style=relative"
    alias ll="$_ls -lA"
    alias la="$_ls -la"
    alias lS="$_ls -lA -ssize"
    alias lU="$_ls -lA -ssize --total-size"
    alias lT="$_ls -lA -snewest"
else
    _ls="ls --color=auto"
    alias ll="$_ls -lA"
    alias la="$_ls -la"
    alias lS="$_ls -lA -Sr"
    alias lT="$_ls -lA -tr"
    # No lU: plain ls cannot compute recursive directory sizes.
fi
unset _ls

# No bat/batcat alias by design -- on Debian the binary is `batcat`, elsewhere
# it is `bat`, and aliasing across that difference previously ended up
# shadowing a real `bat` with `cat` on non-Debian systems.

alias grep='grep --color=auto'
