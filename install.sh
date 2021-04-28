#!/usr/bin/zsh

set -ex

# Script working directory
SCRIPT=$(realpath $0)
CWD=$(dirname $SCRIPT)

# pacman -S bspwm sxhkd zsh rofi neovim kitty dunst feh

for file in .tmux.conf .vimrc .zprofile .zshrc; do
  [[ -f ~/"$file" ]] && mv ~/"$file" /tmp
  ln -s "$CWD/$file" ~/
done

for dir in bspwm dunst gtk-3.0 kitty nvim picom polybar rofi sxhkd wallpapers xsettingsd; do
  [[ -d ~/".config/$dir" ]] && mv ~/".config/$dir" /tmp
  ln -s "$CWD/$dir" ~/.config
done

# # Grub theme
# sudo mkdir -p /boot/grub/themes
# sudo cp -r "$CWD/grub/themes/virtuaverse" /boot/grub/themes
# # Manual step: Add GRUB_THEME="/boot/grub/themes/virtuaverse/theme.txt" to /etc/default/grub
# sudo grub-mkconfig -o /boot/grub/grub.cfg
