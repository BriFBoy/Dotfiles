#!/bin/sh
install() {
  curl -fsSL mise.run | sh
}

uninstall() {
  rm -f "${HOME}/.local/bin/mise"
  rm -rf "${HOME}/.local/share/mise"
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
