git clone https://github.com/vinceliuice/grub2-themes
cd grub2-themes
./install.sh --slaze

cp ./backgrounds/1080p/background-slaze.jpg /usr/share/images/desktop-base/
grep "GRUB_BACKGROUND=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_BACKGROUND=/d' /etc/default/grub
echo "GRUB_BACKGROUND=\"/usr/share/images/desktop-base/background-slaze.jpg\"" >> /etc/default/grub
update-grub
