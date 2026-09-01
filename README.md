# dotfiles

My Neovim, WezTerm, and zsh setup. Runs on macOS and on Linux (Pop!_OS).

Everything shares one color theme I call New Wave, in a light and a dark mode.
The terminal background is a barely-there gradient with a bit of per pixel noise
so it reads a little like paper (near white in light mode, near black in dark),
and the foreground colors stay fairly muted so they sit calmly on it. The palette
lives in one file, `theme/palette.json`, with a `light` and a `dark` block.
`theme/build.py` renders each mode into the forms every tool needs
(`theme/palette.{light,dark}.sh` for zsh, `wezterm/lua/palette_{light,dark}.lua`
and `nvim/lua/palette_{light,dark}.lua` for the Lua configs). Hand-written shims
(`theme/palette.sh`, `wezterm/lua/palette.lua`, `nvim/lua/palette.lua`) pick the
active mode at runtime, so WezTerm, the Neovim colorscheme, Powerlevel10k, and
zsh syntax highlighting all read the same values.

The `theme` command flips between the modes: `theme` prints the current mode,
`theme light` / `theme dark` set one, `theme toggle` flips. It writes a marker
file (`$XDG_CACHE_HOME/dotfiles/theme-mode`); WezTerm watches it and reloads,
Neovim watches it and re-applies its colorscheme live, and the current zsh shell
re-themes and redraws its prompt. New shells and windows just read the marker.

Edit `palette.json`, run `theme/build.py` (or just `install.sh`), reload. Each
accent color keeps the same meaning everywhere:

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

`install.sh` regenerates the theme files from `theme/palette.json`, symlinks the
Neovim and WezTerm configs into `~/.config` (including the `lua/` module dirs),
drops `bin/music` and `bin/theme` into `~/.local/bin`, and seeds the theme mode
marker at `$XDG_CACHE_HOME/dotfiles/theme-mode`. It does not touch the zsh files.
I symlink `~/.zshrc` and `~/.p10k.zsh` by hand on my main machine and left them
out of the installer on purpose; `.zshrc` sources `zsh/theme.zsh` (which sources
`theme/palette.sh`) and `.p10k.zsh` sources `theme/palette.sh` directly.

After that, open Neovim and run `:Lazy sync` to pull plugins.

## Requirements

- Neovim 0.11 or newer
- WezTerm
- IBM Plex Mono (WezTerm asks for it; it falls back to a bundled symbols font for status bar glyphs)
- A clipboard provider (`wl-clipboard` on Linux, built in on macOS)
- `ripgrep`, `fd`, `fzf` for fuzzy finding
- Node.js and Go for the language servers Mason installs
- Python 3 for `theme/build.py` (install.sh falls back to the committed theme files if it is missing) and, on macOS, the `music` script
- Optional: `fastfetch` for the shell greeting, `lazygit` for the `lg` alias

## What is in here

### WezTerm (`wezterm/wezterm.lua` + `wezterm/lua/`)

`wezterm.lua` is a thin entrypoint that wires modules together. The modules live in
`wezterm/lua/`:

| File | What it does |
| ---- | ------------ |
| `palette.lua` | shim that returns `palette_light`/`palette_dark` for the active mode |
| `platform.lua` | renderer, Wayland, the `pop-os` SSH domain |
| `appearance.lua` | font, window, paper background, color table, tab bar |
| `status.lua` | the bottom status bar and its once-a-second background refresh |
| `music.lua` | Apple Music transport + the fuzzy-search prompt (macOS) |
| `keybinds.lua` | leader key and all keybindings |

Each module returns a table with an `apply(config, ctx)` (or `setup`) function;
`ctx` just carries `is_mac`. WezTerm only puts the config dir itself on
`package.path`, so `wezterm.lua` prepends `lua/` and adds it to the reload watch
list.

- The paper background and the palette, plus an ANSI table where ANSI 0/7/15 (black and white) all map to the mode's primary text color, so TUIs that print black text on dark mode or white text on light mode stay readable. The bright colors are set equal to their normal versions. Switching mode with `theme` rewrites the mode marker, which is on WezTerm's reload watch list, so the whole config re-reads.
- Leader key is `Cmd+a` on macOS and `Ctrl+a` on Linux.
- Under the leader: `[` and `]` to split, arrow keys to move between panes, `h j k l` to resize, `x` to close.
- `Leader s` opens a small picker for a split that is already SSH'd into my `pop-os` box. The host is hardcoded, so change or delete that block if you are not me.
- A bottom status bar in three parts: now playing on the left, git branch and current directory centered, battery and a 12 hour clock on the right. The git and now playing values come from a short shell script that runs about once a second and writes `~/.cache/wezterm/status`, so the bar reads a file instead of blocking on `git` and `osascript`.
- Inactive panes are desaturated and dimmed a little. The effect is deliberately mild.
- Apple Music controls under the leader, macOS only: `p` play or pause, `n` next, `b` previous, `0` restart the track, `m` opens a prompt that feeds the `music` script below.

### Neovim (`nvim/init.lua`)

- One file. Options at the top, then the `new-wave` colorscheme defined inline (pulling `nvim/lua/palette.lua`, the active-mode palette), then the plugin list.
- The colorscheme sets `Normal` and friends to no background so the terminal's paper shows through, and picks `background=light`/`dark` from the palette's mode. A libuv watcher on the mode marker re-applies the colorscheme and statusline live when `theme` flips it.
- Plugins: lazy.nvim, fzf-lua, Mason with lspconfig, nvim-treesitter, render-markdown, blink.cmp, lualine.
- LSP keymaps are set on attach: `gd`, `gr`, `K`, `<leader>rn`, `<leader>ca`, `[d`, `]d`. Fuzzy finding is under `<leader>f`.
- lualine uses the same palette. The mode block on the left is the one place a saturated color sits as a solid fill.

### zsh (`zsh/.zshrc`, `zsh/.p10k.zsh`)

- Oh My Zsh with Powerlevel10k. The prompt is a single transparent line: directory, git, and the prompt character on the left; command time (only when it ran longer than 5 seconds), virtualenv, context, and the clock on the right. `TRANSIENT_PROMPT` trims old prompts after they run.
- zsh-syntax-highlighting is themed to the same palette, so a valid command turns blue as you type it and a typo turns red and underlined before you press enter. `zsh/theme.zsh` owns this wiring and the `theme` command, so a `theme` switch re-themes the highlighting and reloads the prompt in the current shell.
- NVM is lazy loaded. `config wezterm|nvim|zsh|p10k|theme` opens the matching file in Neovim.
- `theme [light|dark|toggle|status]` flips the shared light/dark mode across WezTerm, Neovim, and zsh.
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

### `theme` (`bin/theme`)

```bash
theme            # print the current mode
theme light      # switch to light
theme dark       # switch to dark
theme toggle     # flip to the other mode
```

`bin/theme` writes one line, `light` or `dark`, to
`$XDG_CACHE_HOME/dotfiles/theme-mode` (default `~/.cache/dotfiles/theme-mode`).
The palette shims for zsh, WezTerm, and Neovim read that file to decide which
generated palette to load. WezTerm has the marker on its config reload watch
list; Neovim has a libuv watcher on it; and the `theme` shell function (from
`zsh/theme.zsh`) re-sources the palette and runs `p10k reload` for the current
shell. `install.sh` seeds the file with `light`.

## Rough edges

- Neovim leans on the terminal for the actual background (it sets no `Normal` bg), so the paper look only holds together inside WezTerm with this config. In another terminal, set that terminal's background to match the active mode's `paper` color.
- A `theme` switch re-themes every WezTerm window, every Neovim watching the marker, and the one zsh shell it ran in. Other already-open shells keep their old highlighting until you run `zs` (or `theme <same-mode>`) in them; new shells and windows are fine.
- The `pop-os` SSH domain and the split picker are specific to my network.
- The zsh configs are not symlinked by `install.sh`.
