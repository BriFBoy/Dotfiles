
# Installs Starship if not install
if not type -q starship
  echo "Starship not found"
  curl -sS https://starship.rs/install.sh | sh
end
source ~/.cache/wal/colors.fish


fastfetch

# Enables Starship
starship init fish | source

