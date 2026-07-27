# Sourced for ALL zsh invocations (interactive, non-interactive, scripts).
# Keep this light; interactive config belongs in .zshrc / .config/zsh/.

# Debian/Ubuntu's /etc/zsh/zshrc runs compinit unless this is set; we run our
# own compinit in 20-completion.zsh. Unread (and harmless) on other distros.
skip_global_compinit=1

# typeset -U keeps `path` deduplicated, so nested shells don't grow $PATH.
typeset -U path
path=("$HOME/.local/bin" $path)
export PATH

export EDITOR=nano
export VISUAL=nano
