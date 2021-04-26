#!/usr/bin/zsh

set -ex

# Script working directory
SCRIPT=$(realpath $0)
CWD=$(dirname $SCRIPT)

# pacman -S bspwm sxhkd zsh rofi neovim kitty dunst feh

mv ~/.zshrc ~/.vimrc ~/.tmux.conf /tmp || true
ln -s "$CWD/.zshrc" "$CWD/.vimrc" "$CWD/.tmux.conf" ~/

mv ~/.config/bspwm ~/.config/dunst ~/.config/gtk-3.0 ~/.config/kitty ~/.config/nvim ~/.config/picom ~/.config/polybar ~/.config/rofi ~/.config/sxhkd ~/.config/wallpapers /tmp || true
ln -s "$CWD/bspwm" "$CWD/dunst" "$CWD/gtk-3.0" "$CWD/kitty" "$CWD/nvim" "$CWD/picom" "$CWD/polybar" "$CWD/rofi" "$CWD/sxhkd" "$CWD/wallpapers" ~/.config

# Grub theme
sudo mkdir -p /boot/grub/themes
sudo cp -r "$CWD/grub/themes/virtuaverse" /boot/grub/themes
# Manual step: Add GRUB_THEME="/boot/grub/themes/virtuaverse/theme.txt" to /etc/default/grub
# After adding the above line, run sudo grub-mkconfig -o /boot/grub/grub.cfg
