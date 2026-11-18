#!/usr/bin/env bash
# tmux: Fedora install/uninstall hook (stub).
# doty runs this as: fedora.sh install | fedora.sh uninstall
# Keep it idempotent and scoped to this package only.
set -euo pipefail
case "${1:-install}" in
  install)   : ;;
  uninstall) : ;;
  *) echo "usage: $0 {install|uninstall}" >&2; exit 1 ;;
esac
