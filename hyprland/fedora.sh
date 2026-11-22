#!/bin/sh
install() {
  sudo dnf -y copr enable lionheartp/Hyprland
  sudo dnf -y install hyprland hyprland-guiutils
}

uninstall() {
  sudo dnf -y remove hyprland hyprland-guiutils
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
