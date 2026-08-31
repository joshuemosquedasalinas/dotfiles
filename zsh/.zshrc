# Allow console output (fastfetch greeting) with p10k instant prompt
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Powerlevel10k Instant Prompt (must stay at top) 
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh 
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  extract
  web-search
  zsh-autosuggestions
  zsh-syntax-highlighting  # must stay last
)

# Custom completions (must be on fpath before oh-my-zsh runs compinit)
fpath=("$HOME/dotfiles/zsh/completions" $fpath)

source "$ZSH/oh-my-zsh.sh"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# "Deep Archival Inks" palette — generated from ~/dotfiles/theme/palette.json
# (theme/build.py). THEME_* vars.
source ~/dotfiles/theme/palette.sh

# zsh-syntax-highlighting — themed to the palette.
# Must run after the plugin is sourced by oh-my-zsh above.
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

# Bracketed paste highlighting — ink text on paper... er, dark bg (reverts when unhighlighted)
typeset -ga zle_highlight
zle_highlight=(paste:"bg=${THEME_FG},fg=${THEME_SURFACE}")

# Environment
export EDITOR="nvim"
export VISUAL="nvim"

# PATH 
_add_path() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}
_add_path "$HOME/.local/bin"

# History
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# Shell Behavior
setopt AUTO_CD

# Greeting — adapts to pane width
if [[ -o interactive ]] && command -v fastfetch &>/dev/null; then
  export COLORTERM=truecolor
  if [[ $COLUMNS -ge 100 ]]; then
    fastfetch --pipe false --logo macos
  else
    fastfetch --pipe false --logo macos_small
  fi
fi

# z (jump navigation)
[ -f ~/.config/z/z.sh ] && . ~/.config/z/z.sh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Node: NVM (lazy-loaded, single source of truth) ─────────
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ]          && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
node() { nvm; node "$@"; }
npm()  { nvm; npm  "$@"; }
npx()  { nvm; npx  "$@"; }

#  pnpm 
export PNPM_HOME="$HOME/Library/pnpm"
_add_path "$PNPM_HOME"

# Quick-edit config files, e.g. `config wezterm`
config() {
  case "$1" in
    wezterm) nvim ~/dotfiles/wezterm/wezterm.lua ;;
    nvim)    nvim ~/dotfiles/nvim/init.lua ;;
    zsh)     nvim ~/dotfiles/zsh/.zshrc ;;
    p10k)    nvim ~/.p10k.zsh ;;
    theme)   nvim ~/dotfiles/theme/palette.json ;;
    *)       echo "Usage: config [wezterm|nvim|zsh|p10k|theme]" ;;
  esac
}

#  Aliases
alias zs="source ~/.zshrc"
alias reload="exec zsh"
alias path='echo $PATH | tr ":" "\n"'
alias ..="cd .."
alias ...="cd ../.."
alias nn="nvim ."
alias gs="git status"
alias gd="git diff"
alias gp="git push"
alias gbo_main="git branch -u origin/main && git pull"
alias lg="lazygit"


# Added by Antigravity CLI installer
export PATH="/Users/joshue/.local/bin:$PATH"
