#!/usr/bin/env sh
notify-send "Setting Wallpaper"

wal -i $1

swww img $1 --transition-fps 60 --transition-type outer --transition-duration 5

. "$HOME/.cache/wal/colors.sh"
export background foreground cursor color0 color1 color2 color3 color4 color5 color6 color7 color8 color9 color10 color11 color12 color13 color14 color15
envsubst < ~/.config/dunst/dunstrc.template > ~/.config/dunst/dunstrc
killall dunst && dunst &

notify-send "Wallpaper Set"
