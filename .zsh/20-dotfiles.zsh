### Settingf for managing the dot files

alias dot-git="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

function dot-install() {
    chsh -s $(which zsh)
    sudo apt update && sudo apt install -y bat mosh lsd ripgrep tmux fzf tldr mc htop

}
