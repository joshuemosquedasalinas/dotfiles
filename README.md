# dotfiles

Personal Neovim + WezTerm config. Cross-platform (Linux + macOS).

## Install on a new machine
​```
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
​```
Then open Neovim and run `:Lazy sync` to install plugins.

## Requires
- Neovim 0.11+
- WezTerm
- Clipboard provider (`wl-clipboard` on Linux; built into macOS)
- `ripgrep`, `fd`, `fzf` for fuzzy finding
- Node.js and Go for language servers
