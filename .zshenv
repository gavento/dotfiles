# Hack: prevent Ubuntu's /etc/zsh/zshrc initializing compinit
skip_global_compinit=1
# Add local bin to path
export PATH="$HOME/.local/bin:$PATH"
