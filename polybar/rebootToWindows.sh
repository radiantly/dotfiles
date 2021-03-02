#!/usr/bin/zsh

# From https://askubuntu.com/questions/1202432/how-to-change-grub-timeout-only-for-the-next-reboot
sudo grub-editenv - set boot_once_timeout=0
sudo grub-reboot "$(grep -i windows /boot/grub/grub.cfg | cut -d \' -f2)" && systemctl reboot
