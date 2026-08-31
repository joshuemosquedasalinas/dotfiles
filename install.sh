#!/usr/bin/env bash
# Dotfiles installer — works on Linux and macOS.
# Creates symlinks from ~/.config into this repo.

set -e  # stop on any error

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Installing dotfiles from: $DOTFILES"

# Regenerate the theme files (palette.sh + the two palette.lua) from palette.json.
if command -v python3 >/dev/null 2>&1; then
  python3 "$DOTFILES/theme/build.py"
else
  echo "warning: python3 not found — using committed theme files as-is"
fi

mkdir -p ~/.config/nvim
mkdir -p ~/.config/wezterm

ln -sf  "$DOTFILES/nvim/init.lua"        ~/.config/nvim/init.lua
ln -sf  "$DOTFILES/nvim/lazy-lock.json"  ~/.config/nvim/lazy-lock.json
ln -sfn "$DOTFILES/nvim/lua"             ~/.config/nvim/lua
ln -sf  "$DOTFILES/wezterm/wezterm.lua"  ~/.config/wezterm/wezterm.lua
ln -sfn "$DOTFILES/wezterm/lua"          ~/.config/wezterm/lua

# music: fuzzy Apple Music control (macOS only, no-ops elsewhere)
mkdir -p ~/.local/bin
ln -sf "$DOTFILES/bin/music"            ~/.local/bin/music

# Note: zsh/.zshrc and zsh/.p10k.zsh are symlinked by hand on the main
# machine (~/.zshrc -> this repo) but intentionally left out here.

echo "Done. Symlinks created."
echo "Open Neovim and run :Lazy sync to install plugins."
