### History

HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt inc_append_history   # write each command as it is entered (supersedes append_history)
setopt extended_history     # record timestamp and duration alongside the command
setopt hist_ignore_all_dups # a repeated command removes the older copy
setopt hist_find_no_dups    # don't offer duplicates when searching
setopt hist_save_no_dups    # don't write duplicates to the file
setopt hist_reduce_blanks   # normalise whitespace before storing
setopt hist_verify          # expand !! onto the line for review, don't run it blind

# share_history stays off on purpose: concurrent shells keep separate histories
# and only merge via the file, which is what you want with many tmux windows.
