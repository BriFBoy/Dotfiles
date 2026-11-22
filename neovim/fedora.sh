#!/bin/sh
install() {
  sudo dnf -y install neovim
}

uninstall() {
  sudo dnf -y remove neovim
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
