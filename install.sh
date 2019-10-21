# Let's update package lists!
sudo apt update

packages=(zsh curl fonts-firacode git)
for package in $packages; do
	sudo apt -y install $package
done

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

rm ~/.zshrc ~/.vimrc
ln -s ./zshrc ~/.zshrc
ln -s ./vimrc ~/.vimrc

zsh -c '
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
'

