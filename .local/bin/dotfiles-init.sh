#!/bin/bash
set -e -o pipefail

# A function to install a list of packages if they are not already installed, via apt
# Usage: install_deps "package1 package2 package3"
install_deps() {
  local packages="$1"
  local missing_packages=""
  # Verify this is a debian-based system
  if ! command -v apt > /dev/null; then
    echo "This script is only for Debian-based systems"
    exit 1
  fi

  for package in $packages; do
    if ! dpkg -l | grep -q $package; then
      missing_packages="$missing_packages $package"
    fi
  done
  
  if [ -n "$missing_packages" ]; then
    # sudo only if not root
    if [ $EUID -ne 0 ]; then
      APT_CMD="sudo apt"
    else
      APT_CMD="apt"
    fi
    echo "Installing missing packages: $missing_packages"
    $APT_CMD update
    $APT_CMD install -y $missing_packages
  fi
}

# First, install some basic packages
install_deps "aptitude sudo zsh git curl wget yadm nano htop tmux mosh jq bat fzf ripgrep fd-find zstd neofetch tree"
# Multiverse: lsd eza yq

# Change shell to zsh
if [ "$SHELL" != "/bin/zsh" ]; then
  sudo chsh -s $(which zsh) $USER
fi

# If this is a fresh install, initialize yadm
if [ ! -d $HOME/.local/share/yadm ]; then
  yadm clone https://github.com/gavento/dotfiles 
fi

