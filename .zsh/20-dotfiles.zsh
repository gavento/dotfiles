### Settingf for managing the dot files

alias dot-git="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

function dot-install() {
    sudo chsh -s $(which zsh) $USER
    sudo apt update && sudo apt install -y bat mosh lsd ripgrep tmux fzf tldr mc htop jq

}
