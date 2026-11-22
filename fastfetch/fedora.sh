#!/bin/sh
install() {
  sudo dnf -y install fastfetch
}

uninstall() {
  sudo dnf -y remove fastfetch
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
