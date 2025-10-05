#!/bin/bash

killall waybar
sleep 1
waybar &
notify-send "Reloaded Waybar"
