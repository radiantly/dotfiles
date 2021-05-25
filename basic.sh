#!/usr/bin/bash

# This script is meant to install basic config (aliases, nvim) on debian/
# ubuntu installations.

# -e Exit on error
# -o Exit on pipefail
# -x Debug mode
set -eox

# Don't use sudo if we're root user
sudo() {
    [[ $EUID = 0 ]] || set -- command sudo "$@"
    "$@"
}

# Check if apt exists
command -v apt

# Install some essentials
sudo apt update
sudo apt install -yy git tmux neovim wget curl

git clone https://github.com/radiantly/dotfiles.git /tmp/dotfiles

# Copy configs
mkdir -p ~/.config
cp -r /tmp/dotfiles/.config/nvim ~/.config/
cp /tmp/dotfiles/common.sh ~/
rm -rf /tmp/dotfiles
curl -fSsL https://github.com/rupa/z/raw/master/z.sh -o ~/z.sh

SOURCE_CMDS=$(cat << EOF
type z > /dev/null 2>&1 || source ~/z.sh
type md > /dev/null 2>&1 || source ~/common.sh
EOF
)

# Source
[[ -f ~/.bashrc ]] && echo "$SOURCE_CMDS" >> ~/.bashrc
[[ -f ~/.zshrc ]] && echo "$SOURCE_CMDS" >> ~/.zshrc
