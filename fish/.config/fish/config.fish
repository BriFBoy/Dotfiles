# Installs Starship if not install
if not type -q starship
  echo "Starship not found"
  curl -sS https://starship.rs/install.sh | sh
end

# Sources the Pywal colors
source ~/.cache/wal/colors.fish

# Custom keybinds
bind \cy accept-autosuggestion

# Eye candy
fastfetch

# Enables Starship
starship init fish | source
enable_transience
