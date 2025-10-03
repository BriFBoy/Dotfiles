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

echo "Do you want candy stuff? [y/n] (cava, fastfetch, etc)"
read docandy

echo ""
echo "Starting installation in 3"
sleep 1; echo 2
sleep 1; echo 1

isyayinstalled=$(pacman -Q yay | awk "{print $1}")
if [ isyayinstalled != "yay" ]; then
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay
  makepkg -si
  cd ~/.dotfiles
fi

# Uses stow to create a symlink to the correct config directory
yay -S --needed stow python-pywal16
stow hyprland ghostty bash rofi waybar dunst neovim
if [ "$docandy" = "y" ]; then
  stow cava fastfetch
fi

# Creates pywal colors and uses them for dunst
wal -i ./default_wallpaper.jpg
. "$HOME/.cache/wal/colors.sh"
export background foreground color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15
envsubst < ~/.config/dunst/dunstrc.template > ~/.config/dunst/dunstrc

# Installing packages for hyprland and the display manager
yay -S --needed hyprland hypridle hyprshot hyprlock wlogout ly waybar swww

# Installing other packages
yay -S --needed neovim ghostty dolphin firefox 

# Installs the candy packages if needed
if [ "$docandy" = "y" ]; then 
  yay -S --needed cava fastfetch
fi

# Starting the systemd service for the display manager
sudo systemctl enable ly.service


echo "Done!"
echo "Reboot to apply changes"
