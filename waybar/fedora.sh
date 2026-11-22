#!/bin/sh
install() {
  sudo dnf -y install waybar
}

uninstall() {
  sudo dnf -y remove waybar
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
