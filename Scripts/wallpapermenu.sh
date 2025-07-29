#!/bin/bash

wallpaper_dir="$HOME/Pictures/Wallpapers"

wallpapers=$(find "$wallpaper_dir" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) -printf "%P\n")
selected=$(echo "$wallpapers" | rofi -dmenu -p "Choose Wallpaper")

if [ -n "$selected" ]; then
  sh ~/.dotfiles/Scripts/setWallpaper.sh $wallpaper_dir/$selected
fi

