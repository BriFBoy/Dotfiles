#!/bin/sh
install() {
  sudo dnf -y install rofi
}

uninstall() {
  sudo dnf -y remove rofi
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
