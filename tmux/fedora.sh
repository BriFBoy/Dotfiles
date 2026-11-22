#!/bin/sh
install() {
  sudo dnf -y install tmux
}

uninstall() {
  :
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
