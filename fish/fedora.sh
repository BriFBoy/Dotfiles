#!/bin/sh
install() {
  sudo dnf -y install fish
}

uninstall() {
  sudo dnf -y remove fish
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
