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

#
# Function declaration
#
yayInstallation () {
  if ! command -v yay >/dev/null; then
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git ~/yay
    cd ~/yay
    makepkg -si
    cd ~/.dotfiles
  fi
  
}
stowDotfilesSetup() {
  # Uses stow to create a symlink to the correct config directory
  yay -S --needed --noconfirm stow python-pywal16
  if command -v stow >/dev/null; then
    rm -rf ~/.bashrc # removes the allready existing .bashrc file
    stow hyprland ghostty bash rofi waybar dunst neovim
    [ "$docandy" = "y" ] && stow cava fastfetch
  else
    exit; echo "stow not installed"
  fi
}
pywalSetup() {
  # Creates pywal colors and uses them for dunst
  wal -i ./default_wallpaper.jpg
  . "$HOME/.cache/wal/colors.sh"
  export background foreground color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15
  envsubst < ~/.config/dunst/dunstrc.template > ~/.config/dunst/dunstrc
}
# Starts up the swww-daemon just too quickly set det wallpaer before killing it
setDefaultWallpaper() {
  swww-daemon & 
  sleep 4
  swww img ~/.dotfiles/default_wallpaper.jpg
  killall swww-daemon 
}

echo "Do you want candy stuff? [y/n] (cava, fastfetch, etc)"
read docandy

echo ""
echo "Starting installation in 3"
sleep 1; echo 2
sleep 1; echo 1

yayInstallation

stowDotfilesSetup 

pywalSetup 


packages=(
  # Installing packages for hyprland and the display manager
  hyprland
  hypridle 
  hyprshot 
  hyprlock 
  wlogout 
  ly 
  waybar 
  swww 
  ttf-jetbrains-mono-nerd
  # Installing other packages
  neovim 
  ghostty 
  dolphin 
  firefox
)
yay -S --needed --noconfirm "$packages"

# Installs the candy packages if needed
if [ "$docandy" = "y" ]; then 
  yay -S --needed --noconfirm cava fastfetch
fi

setDefaultWallpaper 

# Starting the systemd service for the display manager
sudo systemctl enable ly.service

echo "Done!"
echo "Reboot to apply changes"
