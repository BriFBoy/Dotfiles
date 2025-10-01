#!/bin/bash

echo "+================================================================================+"
echo "| ____       _ _____ ____              _       ____        _    __ _ _           |"
echo "|| __ ) _ __(_)  ___| __ )  ___  _   _( )___  |  _ \  ___ | |_ / _(_) | ___  ___ |"
echo "||  _ \| '__| | |_  |  _ \ / _ \| | | |// __| | | | |/ _ \| __| |_| | |/ _ \/ __||"
echo "|| |_) | |  | |  _| | |_) | (_) | |_| | \__ \ | |_| | (_) | |_|  _| | |  __/\__ \|"
echo "||____/|_|  |_|_|   |____/ \___/ \__, | |___/ |____/ \___/ \__|_| |_|_|\___||___/|"
echo "|                                |___/                                           |"
echo "+================================================================================+"
echo ""

echo "This script will install BriFBoy's dotfiles and DELETE the allready existing ones. Make sure you havea backup!"
sleep 2
echo "Do you want to continue? [y/n]"
read continue
if [ "$continue" != "y" ]; then
  exit
fi


DOTFILES_DIR="~/.dotfiles"


echo "Do you want candy stuff? [y/n] (cava, fastfetch, etc)"
read docandy

echo ""
echo "Starting installation in 3"
sleep 1; echo 2
sleep 1; echo 1

# Installing packages for hyprland and the display manager
yay -S --needed --onconfirm hyprland hypridle hyprshot hyprlock wlogout ly

# Installing other packages
yay -S --needed -onconfirm neovim ghostty dolphin firefox stow

# Installs the candy packages if needed
if [ "$docandy" = "y" ]; then 
  yay -S --needed cava fastfetch
fi

# Starting the systemd service for the display manager
sudo systemctl enable ly.service

# Copies the dotifles to the .dotfiles dir and
# uses stow to create a symlink to the correct config directory
if [ -d $DOTFILES_DIR ]; then
  cp . $DOTFILES_DIR
else 
  mkdir $DOTFILES_DIR
  cp . $DOTFILES_DIR
fi
stow -d $DOTFILES_DIR hyprland ghostty bash rofi waybar dunst neovim
if [ "$docandy" = "y" ]; then
  stow -d $DOTFILES_DIR cava fastfetch
fi

echo "Done!"
echo "Reboot to apply changes"
