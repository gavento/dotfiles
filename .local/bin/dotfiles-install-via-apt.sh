#!/bin/bash
set -e -o pipefail

# Installs yadm and other tools via apt if not present (system/apt)
# Sets shell to zsh
# Clones dotfiles with YADM if not present already
# Installs a newer fzf locally if not present

install_deps() {
  local packages="$1"
  local missing_packages=""

  # Verify this is a apt-based system
  if ! command -v apt-get > /dev/null; then
    echo "This script is only for Debian-based systems"
    exit 1
  fi

  for package in $packages; do
    if ! dpkg-query -W $package > /dev/null; then
      missing_packages="$missing_packages $package"
    fi
  done
  
  if [ -n "$missing_packages" ]; then
    # sudo only if not root
    if [ $EUID -ne 0 ]; then
      APT_CMD="sudo apt-get"
    else
      APT_CMD="apt-get"
    fi
    echo "Installing missing packages: $missing_packages"
    $APT_CMD update
    $APT_CMD install -y $missing_packages
  fi
}

# First, install some basic packages
install_deps "sudo zsh git curl nano htop tmux mosh yadm"
# Bonus packages: jq bat ripgrep fd-find zstd neofetch tree
# Multiverse: lsd eza yq

# Change shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  sudo chsh -s $(which zsh) $USER
fi

# If this is a fresh install, initialize yadm
if [ ! -d $HOME/.local/share/yadm ]; then
  yadm clone https://github.com/gavento/dotfiles 
fi

# Install a recent fzf
$HOME/.local/bin/dotfiles-install-fzf.sh
