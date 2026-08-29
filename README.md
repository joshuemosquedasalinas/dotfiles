# dotfiles

My Neovim, WezTerm, and zsh setup. Runs on macOS and on Linux (Pop!_OS).

Everything shares one color theme I call Deep Archival Inks. It is a light theme.
The terminal background is a near white gradient with a bit of per pixel noise so
it reads a little like paper, and every foreground color is dark and fairly muted
so it stays legible on that background. WezTerm, the Neovim colorscheme,
Powerlevel10k, and zsh syntax highlighting all pull from the same short palette,
and each accent color keeps the same meaning everywhere:

| Color   | Where it shows up |
| ------- | ----------------- |
| red     | errors, deletions, a failed prompt |
| green   | success, string literals, additions |
| yellow  | warnings, diff changes, search matches, long command times |
| blue    | functions, the directory you are in, normal mode |
| magenta | keywords, git ahead/behind, command mode |
| cyan    | types, git branch, paths |
| orange  | numbers, constants, the cursor |

There is a longer writeup of the palette and the reasoning behind it in my notes,
outside this repo.

## Install

```bash
git clone https://github.com/joshuemosquedasalinas/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` symlinks the Neovim and WezTerm configs into `~/.config` and drops
`bin/music` into `~/.local/bin`. It does not touch the zsh files. I symlink
`~/.zshrc` and `~/.p10k.zsh` by hand on my main machine and left them out of the
installer on purpose.

After that, open Neovim and run `:Lazy sync` to pull plugins.

## Requirements

- Neovim 0.11 or newer
- WezTerm
- IBM Plex Mono (WezTerm asks for it; it falls back to a bundled symbols font for status bar glyphs)
- A clipboard provider (`wl-clipboard` on Linux, built in on macOS)
- `ripgrep`, `fd`, `fzf` for fuzzy finding
- Node.js and Go for the language servers Mason installs
- Python 3 on macOS for the `music` script
- Optional: `fastfetch` for the shell greeting, `lazygit` for the `lg` alias

## What is in here

### WezTerm (`wezterm/wezterm.lua`)

- The paper background and the palette, plus an ANSI table where white maps to dark ink rather than paper, so TUIs that print white text stay readable. The bright colors are set equal to their normal versions, because lightening a color on a light background only costs you contrast.
- Leader key is `Cmd+a` on macOS and `Ctrl+a` on Linux.
- Under the leader: `[` and `]` to split, arrow keys to move between panes, `h j k l` to resize, `x` to close.
- `Leader s` opens a small picker for a split that is already SSH'd into my `pop-os` box. The host is hardcoded, so change or delete that block if you are not me.
- A bottom status bar in three parts: now playing on the left, git branch and current directory centered, battery and a 12 hour clock on the right. The git and now playing values come from a short shell script that runs about once a second and writes `~/.cache/wezterm/status`, so the bar reads a file instead of blocking on `git` and `osascript`.
- Inactive panes are desaturated and dimmed a little. The effect is deliberately mild.
- Apple Music controls under the leader, macOS only: `p` play or pause, `n` next, `b` previous, `0` restart the track, `m` opens a prompt that feeds the `music` script below.

### Neovim (`nvim/init.lua`)

- One file. Options at the top, then the `archival-inks` colorscheme defined inline, then the plugin list.
- The colorscheme sets `Normal` and friends to no background so the terminal's paper shows through. If your terminal background is dark, this will look wrong.
- Plugins: lazy.nvim, fzf-lua, Mason with lspconfig, nvim-treesitter, render-markdown, blink.cmp, lualine.
- LSP keymaps are set on attach: `gd`, `gr`, `K`, `<leader>rn`, `<leader>ca`, `[d`, `]d`. Fuzzy finding is under `<leader>f`.
- lualine uses the same palette. The mode block on the left is the one place a saturated color sits as a solid fill.

### zsh (`zsh/.zshrc`, `zsh/.p10k.zsh`)

- Oh My Zsh with Powerlevel10k. The prompt is a single transparent line: directory, git, and the prompt character on the left; command time (only when it ran longer than 5 seconds), virtualenv, context, and the clock on the right. `TRANSIENT_PROMPT` trims old prompts after they run.
- zsh-syntax-highlighting is themed to the same palette, so a valid command turns blue as you type it and a typo turns red and underlined before you press enter.
- NVM is lazy loaded. `config wezterm|nvim|zsh|p10k` opens the matching file in Neovim.
- The greeting runs `fastfetch` and picks the full or small logo based on terminal width.

### `music` (`bin/music`, macOS only)

`bin/music` searches your Apple Music library, not the catalog, and starts
playback in the background through AppleScript. No windows, no focus stealing.
The installer symlinks it to `~/.local/bin/music`.

```bash
music shuffle              # shuffle the whole library
music majo                 # fuzzy match an artist, then shuffle their songs
music ojos verdes          # fuzzy match a song and play it
music -a <query>           # force artist
music -s <query>           # force song
music --reindex            # rebuild the library cache
```

Typos are fine. It plays the closest match and prints what it picked. For artist
shuffle it builds and overwrites a playlist named `▶︎ music` (set
`MUSIC_QUEUE_PLAYLIST` to rename it). The library index lives at
`~/.cache/music/index.tsv` and is rebuilt once it is a day old. Music.app has to
be open the first time. In WezTerm, `Leader m` opens a prompt that runs the same
thing.

## Rough edges

- The theme is built for one specific light background. It will not work on a dark terminal without redoing the palette.
- The `pop-os` SSH domain and the split picker are specific to my network.
- The zsh configs are not symlinked by `install.sh`.
- Neovim leans on the terminal for the actual background, so the paper look only holds together inside WezTerm with this config.
