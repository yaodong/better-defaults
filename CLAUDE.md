# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal development environment for macOS and Omarchy (Arch Linux + Hyprland), containing dotfiles and installation scripts. Goal: the same keyboard experience on both machines.

**Match Omarchy by default.** On Omarchy, keep configs as close to Omarchy's own defaults as possible; deviate only for a hard conflict (e.g. `C-Space` is the input-method switch) or when the user asks. macOS configs are shaped to match Omarchy. Omarchy's defaults live read-only in `/usr/share/omarchy/` — read them, never edit them.

## Source of Truth for AI Agents

**`Brewfile`** is the macOS package manifest. It lists Homebrew formulae, casks, fonts, and taps used by `install`. Omarchy ships the CLI tools itself.

## Setup Commands

```bash
./install         # One-time setup: Homebrew + Brewfile (macOS), link, mise tools, overcommit, git email, tmux plugins, Claude statusLine
./link            # Symlink dotfiles into $HOME for this platform
./doctor          # Validate setup (read-only; reports failures)
```

All three detect the platform (`macos`, `omarchy`, or plain `linux`). `link` is idempotent and safe to re-run; it moves an existing real file or directory to `<target>.bak` before linking. `doctor` only validates — it never modifies state.

## Dotfile Management

Each `<tool>/` directory at repo root is symlinked into `$HOME` by `link`.
Example: `nvim/` → `~/.config/nvim`

| Dotfile | Platform | Notes |
|---------|----------|-------|
| `nvim` | both | LazyVim framework |
| `tmux` | both | Plugins (tpm, tmux-yank, tmux-battery) install into `tmux/plugins/` (gitignored) |
| `ghostty` | both | Shared `config` includes `platform.conf`, a gitignored link `link` points at `macos.conf` or `omarchy.conf` |
| `git` | both | `~/.config/git/config` and `ignore`. Do not set `core.excludesfile` (it would shadow `~/.config/git/ignore`). `user.email` lives in machine-local `~/.config/git/config.local`. |
| `starship` | both | Omarchy's prompt config |
| `mise` | both | Global tools. Auto-install is disabled — install with `mise install`. Never use `mise exec`/`mise x` as a probe: naming a tool installs every missing tool regardless of settings; use `mise where`. claude/codex are `os = ["linux"]`. The whole `mise/` dir is linked to `~/.config/mise`; per-user tools go in `mise/config.<whoami>.toml`, loaded via `MISE_ENV="$(whoami)"` (exported in `bash/.bashrc`, `zsh/.zshrc`, `./install`). Java (Temurin 21) is global; the other JVM tools (coursier, sbt, scala) are in `config.yaodong.z.toml`. |
| `claude` | both | `statusline.sh` → `~/.claude/statusline.sh`; `install-claude-statusline` wires it into `~/.claude/settings.json` |
| `hypr` | Omarchy | `bindings.lua` only → `~/.config/hypr/bindings.lua` (the rest of `~/.config/hypr` stays machine-local). Edits auto-reload; validate with `hyprctl configerrors`. |
| `bash` | Omarchy | Omarchy's `.bashrc` plus `vi`/`vim` aliases; supports `~/.bashrc_local` |
| `zsh` | macOS | Mirrors Omarchy's bash. `zsh/omarchy/` holds verbatim copies of Omarchy's aliases and functions (see its README); don't edit them. Supports `~/.zshrc_local`. |
| `ideavim` | macOS | |
| `skhd` | macOS | Global hotkeys (`~/.config/skhd/skhdrc`). Needs Accessibility permission; apply edits with `skhd --restart-service`. |
| `bin` | macOS | `theme-sync` → `~/.local/bin/theme-sync` |

## Theme System

**Omarchy:** the Omarchy theme picker is the source of truth.
- **Ghostty** — `omarchy.conf` includes `~/.local/state/omarchy/current/theme/ghostty.conf`.
- **Neovim** — `nvim/lua/plugins/theme.lua` (gitignored link created by `link`) points at the current Omarchy theme; `omarchy-theme-hotreload.lua` reapplies it live.
- **Tmux** — `omarchy-theme-set-tmux` sets `window-style`/`window-active-style` on theme change, so `tmux.conf` sets those two options only inside its macOS (`Darwin`) block.

**macOS:** a unified dark/light setup follows macOS appearance. Themes: **Rose Pine Moon** (dark), **Rose Pine Dawn** (light).
- **macOS appearance** — source of truth for dark/light mode.
- **`theme-sync`** — reads macOS appearance and nudges running Neovim instances. Tmux invokes it on focus/session changes (a no-op where it isn't installed); Lazygit, Claude Code, and Ghostty each sync themselves and are not touched by this script.
- **Ghostty** and **Neovim** — follow macOS appearance from `macos.conf` and `appearance.lua`; `theme-sync` nudges running Neovim instances.

**Both:**
- **Tmux** — status bar uses ANSI color names, so it inherits the terminal palette with no theme coupling. The accent (`@accent`) is blue on Omarchy; macOS keeps its own look (cyan accent, dimmed inactive panes, heavy borders with pane-number badges).
- **Lazygit** — uses default terminal-aware colors; do not update Lazygit config from theme scripts.
- **Claude Code** — uses built-in auto sync; do not update `~/.claude.json` from theme scripts.

When modifying themes: on macOS preserve the flow `macOS appearance -> app configs`, with `theme-sync` only nudging running Neovim instances; on Omarchy leave theming to Omarchy. Theme customization in `appearance.lua` applies on macOS only.

## Keybind Conventions

**`KEYBINDINGS.md` is the central list of every key this repo defines or changes.** Update it in the same change whenever you add, change, or remove a binding in any config.

- **Avoid conflicts across layers.** When adding or updating keybinds in any config, check that they don't shadow keybinds in tools that run inside it (e.g., terminal keybinds must not conflict with Neovim keybinds, since Neovim runs inside the terminal).
- **Tmux uses Omarchy's bindings** (Omarchy's prefix keys, plus its `C-M-Arrows`/`C-M-S-Arrows` pane keys with no prefix), except the prefix is `C-j` — `C-Space` switches the input method, and `C-b` is not a second prefix so the shell and Neovim keep it. Its no-prefix `M-1`…`M-9` (window N) are kept too, with Omarchy's Ghostty `Alt+1`…`9` goto-tab defaults unbound so tmux gets them. Previous/next window is `M-{`/`M-}` (`Alt+Shift+[`/`]`, which Ghostty sends by physical key), mirroring `Cmd+Shift+[`/`]` for tabs; Omarchy's `M-Left/Right` and `M-S-Left/Right` are left out so Alt+arrows keep moving by word. Extras: `prefix C-p`/`C-n` for previous/next window, `prefix Tab` for last window, and the common vim-style pane keys (`h/j/k/l` focus, `H/J/K/L` resize, `|`/`-` split), which replace Omarchy's `prefix h` split and `prefix K` kill-session. Omarchy's session switching (`prefix P`/`N`, `M-Up/Down`) is dropped: each Ghostty tab is its own session, so switch tabs instead. The rest of Omarchy's no-prefix Alt layer (`M-Enter` splits, `M-Escape`) is left out so those Alt keys reach the shell and Neovim.
- **Hyprland (Omarchy) owns `SUPER`.** `hypr/bindings.lua` holds the user's deliberate Mac-style overrides; don't add new ones to mimic macOS unless asked — the user adapts to Omarchy first.
- **Global hotkeys (skhd, macOS) sit above every app.** `skhd/skhdrc` holds app launchers, mostly mirroring Omarchy's (`cmd+shift+return` Ghostty, `cmd+shift+b` Dia (Chrome if Dia is missing), `f` Finder, `e` HEY (Gmail Chrome PWA if HEY is missing), `c` Calendar, `l` Slack (Discord if Slack is missing), `/` 1Password). These are deliberate overrides in every app, e.g. they shadow Chrome's `cmd+shift+b` bookmarks bar. `cmd+enter` is deliberately not bound globally, so apps keep it. Use `~` passthrough (process-list syntax) for apps that must keep a key.
- **Ghostty on macOS** sets `macos-option-as-alt`, so Option works as Alt (tmux's `M-1`…`9` and `C-M-Arrows`; shell `Alt+C`, word movement).

## Neovim Configuration

Uses LazyVim framework with Lua config in `nvim/`:
- `lua/config/` — Core settings (keymaps, options, autocmds); `platform.lua` detects macOS / Linux / Omarchy for the files below
- `lua/plugins/` — Plugin specs organized by concern: appearance, completion, copilot, editor, formatting, lsp, navigation
- Copied from Omarchy's nvim config: `all-themes.lua`, `omarchy-theme-hotreload.lua`, `plugin/after/transparency.lua` (Omarchy only), `config/remote_clipboard.lua` (Linux only), `disable-news-alert.lua`, `snacks-animated-scrolling-off.lua` (both)
- Plugin lock file `lazy-lock.json` is gitignored (per machine)

Key customizations on top of LazyVim defaults:
- Omarchy defaults: format-on-save off (`vim.g.autoformat = false`; format with `<leader>cf`), neo-tree explorer, no news popups, no smooth scrolling
- Neotest with minitest (Rails) and Python adapters (`editor.lua`)
- Harpoon 2 for file bookmarks (`navigation.lua`)
- vim-rails for Rails-aware navigation (`navigation.lua`)
- Custom `<leader>tR`/`<leader>tL` for Rails test runner fallback (`keymaps.lua`)
- Custom snippets: `bp` → `binding.irb` (Ruby), `bp` → `breakpoint()` (Python)
