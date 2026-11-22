#!/bin/sh
install() {
  sudo dnf -y install noctalia
}

uninstall() {
  sudo dnf -y remove noctalia
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
