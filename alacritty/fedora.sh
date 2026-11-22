#!/bin/sh
install() {
  sudo dnf -y install alacritty
}

uninstall() {
  sudo dnf -y remove alacritty
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
