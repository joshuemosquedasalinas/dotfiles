#!/usr/bin/env bash
# Dotfiles installer — works on Linux and macOS.
# Creates symlinks from ~/.config into this repo.

set -e  # stop on any error

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Installing dotfiles from: $DOTFILES"

mkdir -p ~/.config/nvim
mkdir -p ~/.config/wezterm

ln -sf "$DOTFILES/nvim/init.lua"        ~/.config/nvim/init.lua
ln -sf "$DOTFILES/nvim/lazy-lock.json"  ~/.config/nvim/lazy-lock.json
ln -sf "$DOTFILES/wezterm/wezterm.lua"  ~/.config/wezterm/wezterm.lua

echo "Done. Symlinks created."
echo "Open Neovim and run :Lazy sync to install plugins."
