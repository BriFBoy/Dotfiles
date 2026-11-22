#!/bin/sh
install() {
  sudo dnf -y install pipx
  pipx install pywal16
  pipx install pywalfox
}

uninstall() {
  pipx uninstall pywal16
  pipx uninstall pywalfox
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
