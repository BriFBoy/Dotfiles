#!/bin/sh
install() {
  sudo dnf -y copr enable scottames/ghostty
  sudo dnf -y install ghostty
}

uninstall() {
  sudo dnf -y remove ghostty
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
