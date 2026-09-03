# Dotfiles

Cross-platform configuration for Neovim, WezTerm, and Zsh on macOS and Linux (Pop!_OS).

## Architecture & Theming

All components share a unified dual-mode palette (`New Wave`) defined in `theme/palette.json`.

- **Backgrounds**: `#F4F4F4` (Light Mode) and `#1A1A1A` (Dark Mode).
- **Code Generation**: `theme/build.py` compiles `palette.json` into:
  - Zsh shell variables (`theme/palette.{light,dark}.sh`)
  - Lua tables for Neovim and WezTerm (`*/lua/palette_{light,dark}.lua`)
  - Claude Code themes (`claude/themes/new-wave{,-dark}.json`)
- **Runtime Mode Switching**: `theme` writes the resolved mode to `$XDG_CACHE_HOME/dotfiles/theme-mode`. WezTerm, Neovim (via libuv file watcher), and Zsh (a `precmd` hook) dynamically reload without restarting.
- **Follow the OS**: a second marker, `theme-source`, is `manual` (pinned) or `system`. In `system` mode WezTerm notices macOS light/dark changes (it reloads its config on appearance change) and runs `theme --sync`, which rewrites `theme-mode` so Neovim, Zsh and Claude Code follow. `theme light` / `dark` / `toggle` set `manual` and stop following. If no WezTerm window is open the sync lands the next time one opens.

### Semantic Color Mapping

| Color | Semantic Role |
| :--- | :--- |
| `red` | Errors, deletions, failed prompt indicators |
| `green` | Success, additions, string literals |
| `yellow` | Warnings, diff modifications, search highlights, long execution alerts |
| `blue` | Functions, active directory, Vim normal mode |
| `magenta` | Keywords, git ahead/behind state, Vim command mode |
| `cyan` | Types, git branch names, file paths |
| `orange` | Numbers, constants, cursor accent |

## Installation

```bash
git clone https://github.com/joshuemosquedasalinas/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Installation Details

`install.sh` performs the following automated setup:
1. Compiles theme files via `theme/build.py`.
2. Symlinks Neovim and WezTerm configurations to `~/.config/`.
3. Symlinks helper scripts (`bin/music`, `bin/theme`) to `~/.local/bin/`.
4. Initializes the theme mode marker to `light`.
5. Symlinks Claude Code custom themes to `~/.claude/themes/` if `~/.claude/` exists.

Post-installation steps:
- **Neovim Plugins**: Run `:Lazy sync` inside Neovim.
- **Zsh Configuration**: Manually link or source `zsh/.zshrc` and `zsh/.p10k.zsh`.
- **Claude Code**: Set `"theme": "custom:new-wave"` in `~/.claude/settings.json`.

## Requirements

- **Editor**: Neovim 0.11+
- **Terminal**: WezTerm
- **Typography**: IBM Plex Mono
- **CLI Tools**: `ripgrep`, `fd`, `fzf`
- **Runtimes**: Python 3, Node.js, Go (for Mason LSP servers)
- **System**: `wl-clipboard` (Linux only)
- **Optional**: `fastfetch` (shell banner), `lazygit`

## Component Details

### WezTerm (`wezterm/`)
- Modular configuration located in `wezterm/lua/` (`appearance`, `status`, `keybinds`, `music`, `platform`).
- **Leader Key**: `Cmd+a` (macOS) / `Ctrl+a` (Linux).
- **Window Management**: `[` / `]` to split, arrow keys to navigate, `h/j/k/l` to resize, `x` to close pane.
- **Status Bar**: Asynchronous background caching (`~/.cache/wezterm/status`) for Git branch, working directory, battery, and music playback.

### Neovim (`nvim/`)
- Minimalist `init.lua` structure with native `new-wave` colorscheme integration.
- Transparent background inheriting terminal canvas.
- Plugin stack: `lazy.nvim`, `fzf-lua`, `mason.nvim`, `nvim-treesitter`, `blink.cmp`, `lualine.nvim`, `render-markdown`.
- Key mappings: `gd` (definition), `gr` (references), `K` (hover), `<leader>rn` (rename), `<leader>ca` (code actions), `<leader>f` (fuzzy find).

### Zsh (`zsh/`)
- Powerlevel10k single-line transient prompt.
- Syntax highlighting dynamically tied to the active palette (valid commands blue, syntax errors red).
- Lazy-loaded NVM and custom aliases (`config <tool>`, `lg`).

## Utility Scripts

### Theme Manager (`theme`)
```bash
theme            # Display current mode and source, e.g. "dark (system)"
theme light      # Pin to light
theme dark       # Pin to dark
theme toggle     # Flip to the other mode (and pin)
theme system     # Follow the macOS light/dark setting from now on
```

### Apple Music Controller (`music`, macOS only)
Controls local Music.app playback via AppleScript without window activation.
```bash
music shuffle              # Shuffle entire library
music <artist>             # Fuzzy match artist and shuffle songs
music <track>              # Fuzzy match track and play
music -a <query>           # Match artist specifically
music -s <query>           # Match song specifically
music --reindex            # Rebuild local cache (~/.cache/music/index.tsv)
```

## Configuration Notes

- **Terminal Background**: Neovim leaves `Normal` background transparent; colorscheme contrast depends on terminal background rendering.
- **Multi-Shell Sync**: Running `theme` reloads the active shell and GUI instances immediately. Every other open shell re-themes on its next prompt (a `precmd` hook that compares `theme-mode` to the shell's `THEME_MODE`).
- **SSH Domains**: WezTerm includes pre-configured SSH domains for `pop-os` reachable via Tailscale/local network.
