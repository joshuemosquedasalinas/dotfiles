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

source "$ZSH/oh-my-zsh.sh"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh-syntax-highlighting — "Deep Archival Inks" (see ~/Vault/3. Winner - Gemini Pro.md)
# Must run after the plugin is sourced by oh-my-zsh above.
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=#204a87,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#204a87,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#204a87,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#204a87,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#752c61,bold'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#8f2727,underline'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#752c61'
ZSH_HIGHLIGHT_STYLES[path]='fg=#175e5e,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#175e5e'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#225e31'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#225e31'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#9c4314'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#9c4314'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#705214,bold'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=#175e5e'
ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=#175e5e'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#404040,italic'

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
    *)       echo "Usage: config [wezterm|nvim|zsh|p10k]" ;;
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
