#!/bin/sh
install() {
  sudo dnf -y install git
}

uninstall() {
  :
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
