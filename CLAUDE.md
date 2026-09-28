# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal macOS development environment setup containing dotfiles and installation scripts.

## Source of Truth for AI Agents

**`Brewfile`** is the package manifest. It lists Homebrew formulae, casks, fonts, and taps used by `scripts/install`. Read this file first when setting up a new machine.

## Setup Commands

```bash
./scripts/install         # Install Homebrew packages, apps, fonts, runtimes
./scripts/link            # Symlink dotfiles into $HOME
./scripts/macos-defaults  # Apply macOS system defaults
./scripts/doctor          # Validate setup (read-only; reports failures)
```

`scripts/install` runs once: Homebrew, mise runtimes (ruby, python), overcommit, Claude statusLine. `scripts/link` is idempotent and safe to re-run. `scripts/doctor` only validates — it never modifies state.

## Dotfile Management

Each `<tool>/` directory at repo root is symlinked into `$HOME` by `scripts/link`.
Example: `nvim/` → `~/.config/nvim`

| Dotfile | Notes |
|---------|-------|
| `nvim` | LazyVim framework |
| `starship` | |
| `git` | `~/.config/git/config`. Do not set `core.excludesfile` (it would shadow `~/.config/git/ignore`). |
| `zsh` | Supports `~/.zshrc_local` for machine-local overrides |
| `ideavim` | |
| `tmux` | |
| `ghostty` | |
| `cursor` | |
| `skhd` | Global hotkeys (`~/.config/skhd/skhdrc`). Needs Accessibility permission; apply edits with `skhd --restart-service`. |

## Theme System

A unified dark/light setup follows macOS appearance. Themes: **Rose Pine Moon** (dark), **Rose Pine Dawn** (light).

- **macOS appearance** — source of truth for dark/light mode.
- **`theme-sync`** — reads macOS appearance and nudges running Neovim instances. Tmux invokes it on focus/session changes; Lazygit, Cursor, Claude Code, and Ghostty each sync themselves (see below) and are not touched by this script.
- **Tmux** — status bar uses terminal-default colors, so it inherits Ghostty's light/dark palette with no theme coupling.
- **Lazygit** — uses default terminal-aware colors; do not update Lazygit config from theme scripts.
- **Cursor** — uses built-in auto sync; do not update Cursor settings from theme scripts.
- **Claude Code** — uses built-in auto sync; do not update `~/.claude.json` from theme scripts.
- **Ghostty** and **Neovim** — follow macOS appearance from their configs; `theme-sync` nudges running Neovim instances.

When modifying themes: preserve the flow `macOS appearance -> app configs`, with `theme-sync` only nudging running Neovim instances. `appearance.lua` handles Neovim startup; Ghostty's `config` handles the terminal.

## Keybind Conventions

- **Avoid conflicts across layers.** When adding or updating keybinds in any config, check that they don't shadow keybinds in tools that run inside it (e.g., terminal keybinds must not conflict with Neovim keybinds, since Neovim runs inside the terminal).
- **Global hotkeys (skhd) sit above every app.** `skhd/skhdrc` holds app launchers, mostly mirroring Omarchy's (`cmd+enter` Ghostty, `cmd+shift+{return,b}` Chrome, `f` Finder, `n` Cursor, `e` Gmail (Chrome PWA), `c` Calendar, `l` Slack, `/` 1Password). These are deliberate overrides in every app, including Ghostty (no fullscreen toggle) — e.g. they shadow Cursor's `cmd+shift+f` search and Chrome's `cmd+shift+n` incognito. Use `~` passthrough (process-list syntax) for apps that must keep a key.

## Neovim Configuration

Uses LazyVim framework with Lua config in `nvim/`:
- `lua/config/` — Core settings (keymaps, options, autocmds)
- `lua/plugins/` — Plugin specs organized by concern: appearance, completion, copilot, editor, formatting, lsp, navigation
- Plugin lock file: `lazy-lock.json`

Key customizations on top of LazyVim defaults:
- Neotest with minitest (Rails) and Python adapters (`editor.lua`)
- Harpoon 2 for file bookmarks (`navigation.lua`)
- vim-rails for Rails-aware navigation (`navigation.lua`)
- Custom `<leader>tR`/`<leader>tL` for Rails test runner fallback (`keymaps.lua`)
- Custom snippets: `bp` → `binding.irb` (Ruby), `bp` → `breakpoint()` (Python)
