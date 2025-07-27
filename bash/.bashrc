
[[ $- != *i* ]] && return

. ".cache/wal/colors.sh"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fastfetch='fastfetch --color-title "$foreground" --logo-color-1 "$color1" --logo-color-2 "$color1"'
alias wallpaper="sh ~/.dotfiles/Scripts/setWallpaper.sh"

PS1='\[\e[96m\]\W\[\e[0m\] \[\e[38;5;244m\]>\[\e[0m\]'

fastfetch
