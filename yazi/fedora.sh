#!/bin/sh
install() {
  sudo dnf -y copr enable lihaohong/yazi
  sudo dnf -y install yazi
}

uninstall() {
  sudo dnf -y remove yazi
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
