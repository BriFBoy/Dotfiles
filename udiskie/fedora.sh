#!/bin/sh
install() {
  sudo dnf -y install udiskie
}

uninstall() {
  sudo dnf -y remove udiskie
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
