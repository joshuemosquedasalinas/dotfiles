# Hand-written shim (NOT generated). Sourced by zsh/.zshrc and zsh/.p10k.zsh.
# Reads the active mode marker and sources that mode's generated THEME_* vars.
# Switch modes with the `theme` command (bin/theme).

_theme_mode_file="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/theme-mode"
_theme_mode=light
if [ -r "$_theme_mode_file" ]; then
  read -r _theme_mode < "$_theme_mode_file" || _theme_mode=light
fi
[ "$_theme_mode" = "dark" ] || _theme_mode=light

. "$HOME/dotfiles/theme/palette.${_theme_mode}.sh"

unset _theme_mode_file _theme_mode
