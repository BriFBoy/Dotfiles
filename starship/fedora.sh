#!/bin/sh
install() {
  sudo dnf -y copr enable atim/starship
  sudo dnf -y install starship
}

uninstall() {
  sudo dnf -y remove starship
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
