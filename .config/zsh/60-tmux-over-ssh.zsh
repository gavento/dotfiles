### Auto-tmux over SSH
#
# Model:
#   - A persistent "main" session owns the window pool and survives
#     disconnects. A hidden window running `sleep infinity` keeps it alive
#     even when no shell windows remain.
#   - Each SSH connection gets its own grouped session, sharing main's windows
#     but with an independent "current window" cursor -- so two terminals into
#     the same box scroll through windows independently.
#   - Each SSH opens a NEW window. `exit` kills that window and the grouped
#     session, which closes the SSH connection. Prefix-d detaches: the
#     grouped session is reaped on detach, while its windows live on in
#     "main" and are there again on the next connection.
#
# Not reached for non-interactive `ssh host command`, since zsh skips .zshrc
# there.

if [[ -z "$TMUX" && -n "$SSH_CONNECTION" ]] && (( $+commands[tmux] )); then
    if ! tmux has-session -t main 2>/dev/null; then
        _tmux_keeper=$(tmux new-session -d -s main -n . -P -F '#{window_id}' 'exec sleep infinity')
        # Hide the keeper window from the status bar. Target the window id:
        # with base-index 1 it is not window 0.
        tmux set-window-option -t "$_tmux_keeper" window-status-format '' 2>/dev/null
        tmux set-window-option -t "$_tmux_keeper" window-status-current-format '' 2>/dev/null
    fi

    _tmux_ses="ssh-$$-$RANDOM"
    tmux new-session -d -s "$_tmux_ses" -t main

    # When the inner zsh exits, the wrapper kills this grouped session, the
    # client detaches, exec returns, and the SSH connection closes.
    tmux new-window -t "$_tmux_ses" -c "$HOME" \
        "zsh; tmux kill-session -t '$_tmux_ses'"

    # Reap this per-connection session when its client detaches (prefix-d):
    # the shared windows live on in "main"; without this the grouped
    # sessions accumulate forever. Set as part of the attach, not before it:
    # the option is evaluated the moment it is set, and a session nobody has
    # attached to yet is unattached -- setting it any earlier deletes the
    # session out from under us.
    exec tmux attach-session -t "$_tmux_ses" \; \
         set-option -t "$_tmux_ses" destroy-unattached on
fi

# Give this window its label back. tmux stops renaming a window the moment
# something names it explicitly -- `new-window -n shell` from container
# tooling is enough -- and the window then keeps that name forever, which is
# why a whole status bar can read "1:shell 2:shell". The .tmux.conf hook
# covers windows created after the config loads; this covers the one we are
# starting in. Rename a window by hand and it stays renamed until a new shell
# starts there.
if [[ -n "$TMUX" ]] && (( $+commands[tmux] )); then
    tmux set-window-option automatic-rename on 2>/dev/null
fi
