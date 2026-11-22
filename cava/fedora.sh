#!/bin/sh
install() {
  sudo dnf -y install cava
}

uninstall() {
  sudo dnf -y remove cava
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
