#!/bin/sh
install() {
  sudo dnf -y install dunst
}

uninstall() {
  sudo dnf -y remove dunst
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
