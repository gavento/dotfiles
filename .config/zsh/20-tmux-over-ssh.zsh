# If not in TMUX, if over ssh, and tmux is available, attach to or create a session named "main"

if [[ -z "${TMUX}" && -n "${SSH_CONNECTION}" && -x "$(command -v tmux)" ]]; then
    # Attempt to attach to existing session named "main" or create it
    tmux attach-session -t main || tmux new-session -s main
fi