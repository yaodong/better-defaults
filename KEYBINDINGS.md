# Keybindings

Every key this repo defines or changes, in one place. Stock defaults are not
repeated here — see [Other references](#other-references) for those.

Keep this file in sync when you add, change, or remove a binding.

- **Mac ⌘ = Omarchy Super.** Option = Alt on macOS (Ghostty `macos-option-as-alt`).
- Omarchy is the baseline; macOS is shaped to match it.

## Contents

- [Window manager and app launchers](#window-manager-and-app-launchers)
- [Ghostty](#ghostty)
- [tmux](#tmux)
- [Shell](#shell)
- [Neovim](#neovim)
- [IdeaVim (JetBrains)](#ideavim-jetbrains)
- [Other references](#other-references)

## Window manager and app launchers

### Omarchy (Hyprland) — `hypr/bindings.lua`

Mac-style Super shortcuts on top of Omarchy's defaults. Most are sent on to the
focused app as the Ctrl equivalent; in terminals the GUI ones do nothing, since
Ctrl+Z / Ctrl+A mean something else there.

| Key | Action | Replaces Omarchy default |
|-----|--------|--------------------------|
| `Super+W` | Close tab (browser) / close window (elsewhere) | Close window |
| `Super+Q` | Close window | |
| `Super+A` | Select all (`Ctrl+A`) | |
| `Super+Z` / `Super+Shift+Z` | Undo / redo | |
| `Super+R` | Reload (`Ctrl+R`) | |
| `Super+N` | New window (`Ctrl+N`) | |
| `Super+F` | Find (`Ctrl+F`) | Full screen |
| `Super+S` | Save (`Ctrl+S`) | Scratchpad |
| `Super+Shift+T` | Reopen closed tab (browser) | |
| `Super+[` / `Super+]` | Back / forward (browser) | |
| `Super+Return` | Open in new tab (browser, `Alt+Return`) | Terminal |
| `Super+Shift+Return` | Terminal | Browser |
| `Super+Ctrl+F` | Full screen | Tiled full screen |
| `Super+Alt+S` | Toggle scratchpad | Move window to scratchpad |
| `Super+Shift+Alt+S` | Move window to scratchpad | |

Not in this repo (machine-local `~/.config/hypr/input.lua`): **Caps Lock = Ctrl**;
both Shifts together toggle real Caps Lock.

### macOS (skhd) — `skhd/skhdrc`

App launchers mirroring Omarchy's `Super+Shift` launchers. They override the key
in every app.

| Key | Opens | Omarchy equivalent |
|-----|-------|--------------------|
| `⌘+Return` | Ghostty | ⚠️ `Super+Shift+Return` (terminal) |
| `⌘+Shift+Return` | Chrome | ⚠️ `Super+Shift+B` (browser); `Super+Shift+Return` is the terminal on Omarchy |
| `⌘+Shift+B` | Chrome | `Super+Shift+B` |
| `⌘+Shift+F` | Finder at `~` | `Super+Shift+F` (file manager) |
| `⌘+Shift+E` | Gmail | `Super+Shift+E` (email) |
| `⌘+Shift+C` | Calendar | `Super+Shift+C` |
| `⌘+Shift+L` | Slack | — |
| `⌘+Shift+/` | 1Password | `Super+Shift+/` (passwords) |

⚠️ = the terminal/browser keys differ between the two machines.

## Ghostty

`ghostty/config`, `macos.conf`, `omarchy.conf`. Tabs and splits otherwise use
Ghostty's defaults (Omarchy: `Ctrl+Shift+T` new tab; macOS: `⌘+T`).

| Key | Action | Platform |
|-----|--------|----------|
| `Shift+Enter` | Sent as CSI-u so TUIs can tell it from Enter | both |
| `Alt+Shift+Enter` | Sent as CSI-u so tmux sees `M-S-Enter` | both |
| `Shift+Insert` / `Ctrl+Insert` | Paste / copy | Omarchy |
| `Super+Ctrl+Shift+Alt+Arrows` | Resize split | Omarchy |
| `⌘+D`, `⌘+Shift+D`, `⌘+Shift+Enter`, `⌘+[`, `⌘+]`, `⌘+Ctrl+=` | Unbound (splits live in tmux) | macOS |

## tmux

`tmux/tmux.conf` — Omarchy's tmux bindings, prefix changed to `C-j`
(`C-Space` switches the input method). `C-j ?` lists everything (Omarchy only).

### No prefix (Alt layer)

| Key | Action |
|-----|--------|
| `M-1` … `M-9` | Go to window N |
| `M-Left` / `M-Right` | Previous / next window |
| `M-S-Left` / `M-S-Right` | Move window left / right |
| `M-Up` / `M-Down` | Previous / next session |
| `M-Enter` / `M-S-Enter` | Split down / right |
| `M-Escape` | Kill pane |
| `C-M-Arrows` | Focus pane |
| `C-M-S-Arrows` | Resize pane |

### With prefix `C-j`

| Key | Action |
|-----|--------|
| `C-j` | Send `C-j` to the app |
| `h` / `v` | Split down / right |
| `x` | Kill pane |
| `c` / `r` / `k` | New / rename / kill window |
| `C-p` / `C-n` | Previous / next window *(ours, not Omarchy's)* |
| `C` / `R` / `K` | New / rename / kill session |
| `P` / `N` | Previous / next session |
| `q` | Reload config |
| `?` | Show all bindings (Omarchy only) |
| `y` / `Y` | Copy command line / current directory (tmux-yank) |
| `I` / `U` / `M-u` | Install / update / clean plugins (tpm) |

### Copy mode (vi)

| Key | Action |
|-----|--------|
| `v` | Begin selection |
| `y` | Copy to system clipboard (tmux-yank) |
| `Y` | Copy and paste into the command line (tmux-yank) |

## Shell

Omarchy's bash (`bash/.bashrc`) and macOS zsh (`zsh/.zshrc`) share the same keys
and aliases; zsh gets them from `zsh/omarchy/`.

| Key | Action | Platform |
|-----|--------|----------|
| `Up` / `Down` | Search history for what you've typed | both |
| `Ctrl+R` | fzf history search | both |
| `Ctrl+T` | fzf file picker | both |
| `Alt+C` | fzf directory jump | both |
| `Tab Tab` / `Shift+Tab` | Accept autosuggestion | macOS (zsh only) |

Handy aliases from Omarchy: `n` (nvim), `t` (tmux attach/new), `cd` (zoxide),
`ff` / `eff` (fzf find / edit), `g`, `gcm`, `ga` / `gd` (worktrees), `tdl` (tmux dev layout).

## Neovim

`nvim/` — LazyVim, leader is `Space`. Only additions and overrides are listed.

| Key | Action | File |
|-----|--------|------|
| `<leader>?` | Show all keymaps (which-key) | `plugins/editor.lua` |
| `<leader>ud` | Toggle diagnostics | `config/keymaps.lua` |
| `<leader>bb` | Buffer picker, most recent first *(overrides LazyVim)* | `config/keymaps.lua` |
| `<leader>wm` | Maximize window (close others) *(overrides LazyVim)* | `config/keymaps.lua` |
| `<leader>su` | Undo tree | `plugins/editor.lua` |
| `<leader>ha` | Harpoon: add file | `plugins/navigation.lua` |
| `<leader>hh` | Harpoon: menu | `plugins/navigation.lua` |
| `<leader>h1` … `<leader>h4` | Harpoon: go to file 1–4 | `plugins/navigation.lua` |
| `<leader>tt` / `tT` | Neotest: run file / all files | `plugins/editor.lua` |
| `<leader>tr` / `tl` | Neotest: run nearest / last | `plugins/editor.lua` |
| `<leader>ts` / `to` / `tO` | Neotest: summary / output / output panel | `plugins/editor.lua` |
| `<leader>tS` / `tw` | Neotest: stop / toggle watch | `plugins/editor.lua` |
| `<leader>tR` / `tL` | Rails test: file / line (fallback) | `config/keymaps.lua` |
| `Enter` | Accept completion (blink.cmp `enter` preset) | `plugins/completion.lua` |
| `bp` (snippet) | `binding.irb` (Ruby) / `breakpoint()` (Python) | `plugins/editor.lua` |

`C-j` is the tmux prefix, so LazyVim's `C-j` (window below) needs `C-j C-j` inside tmux.

## IdeaVim (JetBrains)

`ideavim/.ideavimrc` — leader is `Space`. macOS only.

| Key | Action |
|-----|--------|
| `<leader>w` / `<leader>q` | Save / close |
| `<leader>/` | Clear search highlight |
| `<leader>s` | Substitute word under cursor |
| `<leader>c` | Toggle line comment |
| `<leader>j` | EasyMotion jump |
| `<leader>x` | Toggle NERDTree |
| `<leader><leader>`, `<leader>fr` | Recent files |
| `<leader>ff` / `fc` / `fl` / `fs` | Go to file / find in path / recent locations / scratch file |
| `<leader>as` / `am` | Search everywhere / intention actions |
| `<leader>bn` / `bp` / `bd` | Next / previous / delete buffer |
| `<leader>wv` / `ws` / `wu` / `wm` | Split vertically / horizontally / unsplit / move editor to other group |
| `<leader>wh` / `wj` / `wk` / `wl` | Resize window (defined twice; the later resize mappings win) |
| `<leader>zc` / `zo` | Collapse / expand all regions |
| `<leader>dd` / `dz` / `df` | Distraction-free / zen / full screen |
| `<leader>rn` / `rm` / `rv` / `rf` / `rs` / `rr` | Rename / extract method / variable / field / change signature / refactor menu |
| `<leader>gd` / `gy` / `gi` / `gu` / `gt` | Go to declaration / type / implementation / usages / test |
| `<leader>gf` | Back |
| `<leader>gb` | Git branches (a later mapping overrides "forward") |
| `<leader>gc` / `gs` | Commit / VCS tool window |
| `<leader>en` / `ep` | Next / previous error |
| `<C-t>` / `<C-w>` | New tab / close tab |
| `<A-n>` / `<A-p>` | Next / previous tab |
| `[[` / `]]` | Previous / next method |
| `qj` | Run macro `q` |
| `<` / `>` (visual) | Indent, keep selection |
| `<C-j>` / `<C-k>` (insert) | Next / previous completion item |

## Other references

- **Omarchy (Hyprland):** `omarchy menu keybindings --print`, or `Super+K`.
- **tmux:** `C-j ?` (Omarchy), or `tmux list-keys -N`.
- **Neovim:** `<leader>?` or `<leader>sk` (LazyVim keymaps), and [LazyVim's keymap docs](https://www.lazyvim.org/keymaps).
- **Ghostty:** `ghostty +list-keybinds`.
