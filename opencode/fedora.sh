#!/bin/sh
install() {
  curl -fsSL https://opencode.ai/v2/install | bash -s -- --no-modify-path
}

uninstall() {
  rm -f "${HOME}/.opencode/bin/opencode" "${HOME}/.opencode/bin/opencode2"
}

if [ "$1" = "install" ]; then
  install
elif [ "$1" = "uninstall" ]; then
  uninstall
fi
