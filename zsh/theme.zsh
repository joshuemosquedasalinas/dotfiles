# Sourced by zsh/.zshrc, after oh-my-zsh (so zsh-syntax-highlighting is loaded).
# Owns the "New Wave" palette wiring and the `theme` light/dark switch command.

# Load THEME_* vars for the active mode and (re)apply everything that reads them.
_theme_apply() {
  source ~/dotfiles/theme/palette.sh   # sets/export THEME_* for the current mode

  typeset -gA ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]="fg=${THEME_BLUE},bold"
  ZSH_HIGHLIGHT_STYLES[builtin]="fg=${THEME_BLUE},bold"
  ZSH_HIGHLIGHT_STYLES[function]="fg=${THEME_BLUE},bold"
  ZSH_HIGHLIGHT_STYLES[alias]="fg=${THEME_BLUE},bold"
  ZSH_HIGHLIGHT_STYLES[precommand]="fg=${THEME_MAGENTA},bold"
  ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=${THEME_RED},underline"
  ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=${THEME_MAGENTA}"
  ZSH_HIGHLIGHT_STYLES[path]="fg=${THEME_CYAN},underline"
  ZSH_HIGHLIGHT_STYLES[path_prefix]="fg=${THEME_CYAN}"
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=${THEME_GREEN}"
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=${THEME_GREEN}"
  ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]="fg=${THEME_ORANGE}"
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=${THEME_ORANGE}"
  ZSH_HIGHLIGHT_STYLES[globbing]="fg=${THEME_YELLOW},bold"
  ZSH_HIGHLIGHT_STYLES[command-substitution]="fg=${THEME_CYAN}"
  ZSH_HIGHLIGHT_STYLES[process-substitution]="fg=${THEME_CYAN}"
  ZSH_HIGHLIGHT_STYLES[comment]="fg=${THEME_FG_MUTED},italic"

  # Bracketed paste: invert to the mode's ink/surface pair.
  typeset -ga zle_highlight
  zle_highlight=(paste:"bg=${THEME_FG},fg=${THEME_SURFACE}")
}
_theme_apply

# theme [light|dark|toggle|status] — flip the shared light/dark theme.
# The bin/theme worker writes the marker (WezTerm + Neovim pick it up on their
# own); here we also re-theme the current shell and redraw the prompt.
theme() {
  command theme "$@" || return
  case "${1:-status}" in
    light | dark | toggle)
      _theme_apply
      (( ${+functions[p10k]} )) && p10k reload
      ;;
  esac
}
