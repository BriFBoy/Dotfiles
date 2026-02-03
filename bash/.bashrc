[[ $- != *i* ]] && return
. "$HOME/.cache/wal/colors.sh"


# Makes yazi change the CWD
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

alias ls='ls --color=auto'
alias y="yazi"
alias grep='grep --color=auto'
alias fastfetch='fastfetch --color-title "$foreground" --logo-color-1 "$color1" --logo-color-2 "$color1"'
alias wallpaper="sh ~/.dotfiles/Scripts/wallpapermenu.sh"
alias tmux="tmux attach-session -t Main || tmux new-session -s Main"

PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'
PS1='\[\e[0;33m\]\w ${PS1_CMD1}\n-> \[\e[0m\]'

fastfetch

# Used for the Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Enviroment Variables
export TERMINAL=ghostty
