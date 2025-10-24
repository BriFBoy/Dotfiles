
[[ $- != *i* ]] && return

. "$HOME/.cache/wal/colors.sh"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fastfetch='fastfetch --color-title "$foreground" --logo-color-1 "$color1" --logo-color-2 "$color1"'
alias wallpaper="sh ~/.dotfiles/Scripts/wallpapermenu.sh"

PS1='\[\e[96m\]\W\[\e[0m\] \[\e[38;5;244m\]>\[\e[0m\]'

fastfetch

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
