
# My Dev Setup

Personal development environment for macOS and [Omarchy](https://omarchy.org/) (Arch Linux + Hyprland). Both machines share the same keyboard experience; on Omarchy the configs stay as close to Omarchy's defaults as possible, and macOS is set up to match.

## Setup

```bash
git clone --depth=1 https://github.com/yaodong/better-defaults.git ~/.better
cd ~/.better
```

```bash
./install         # One-time setup (Homebrew + Brewfile on macOS), then link
./link            # Symlink dotfiles into $HOME (safe to re-run)
./doctor          # Validate the setup (read-only)
```

`link` detects the platform and backs up any existing file or folder it replaces to `<name>.bak`. Homebrew packages (macOS) are declared in `Brewfile`; Omarchy already ships the CLI tools.

## Keybindings

Every key this repo defines or changes — Hyprland/skhd, Ghostty, tmux, shell, Neovim, IdeaVim — is listed in **[KEYBINDINGS.md](KEYBINDINGS.md)**.

## What's Included

### Dotfiles

Each `<tool>/` directory at repo root is symlinked into `$HOME` by `link`. Example: `nvim/` becomes `~/.config/nvim`.

| Dotfile | Platform | Description |
|---------|----------|-------------|
| `nvim` | both | Neovim with [LazyVim](https://github.com/LazyVim/LazyVim); follows the Omarchy theme on Omarchy, Rose Pine on macOS |
| `tmux` | both | Tmux with Omarchy's key bindings (prefix `C-j`); status bar uses terminal colors |
| `ghostty` | both | [Ghostty](https://ghostty.org/) terminal; shared `config` plus `macos.conf` / `omarchy.conf` |
| `git` | both | Global git config (Omarchy's defaults) and ignore; email goes in `~/.config/git/config.local` |
| `starship` | both | [Starship](https://starship.rs/) prompt (Omarchy's); hostname shown over SSH |
| `mise` | both | [mise](https://github.com/jdx/mise) global tools; auto-install disabled. per-user tools in `config.<whoami>.toml` via `MISE_ENV` (JVM tools only for `yaodong.z`) |
| `claude` | both | Claude Code statusline |
| `hypr` | Omarchy | Hyprland `bindings.lua`: Mac-style `Super` shortcuts on top of Omarchy's defaults |
| `bash` | Omarchy | Omarchy's `.bashrc`; supports `~/.bashrc_local` for machine-local overrides |
| `zsh` | macOS | Zsh set up to match Omarchy's bash (its aliases and functions are copied into `zsh/omarchy/`); supports `~/.zshrc_local` |
| `ideavim` | macOS | [IdeaVim](https://github.com/JetBrains/ideavim) config for JetBrains IDEs |
| `skhd` | macOS | [skhd](https://github.com/asmvik/skhd) global app-launcher hotkeys modeled on Omarchy (`cmd+enter` Ghostty, `cmd+shift+b` Chrome, …) |
| `bin` | macOS | `theme-sync` (nudges Neovim when macOS appearance changes) |

### CLI Tools

Installed via Homebrew on macOS (full manifest in `Brewfile`); shipped by Omarchy on Linux.

[ripgrep](https://github.com/BurntSushi/ripgrep) | [fd](https://github.com/sharkdp/fd) | [bat](https://github.com/sharkdp/bat) | [eza](https://github.com/eza-community/eza) | [fzf](https://github.com/junegunn/fzf) | [zoxide](https://github.com/ajeetdsouza/zoxide) | [gum](https://github.com/charmbracelet/gum) | [btop](https://github.com/aristocratos/btop) | [fastfetch](https://github.com/fastfetch-cli/fastfetch) | [mise](https://github.com/jdx/mise) | [lazydocker](https://github.com/jesseduffield/lazydocker) | [gh](https://cli.github.com/)

## Theme System

On **Omarchy**, the Omarchy theme picker is the source of truth: Ghostty loads the current theme's colors, Neovim switches colorscheme through `nvim/lua/plugins/theme.lua`, and Omarchy updates running tmux sessions.

On **macOS**, system appearance is the source of truth for dark/light mode. Apps follow it directly where possible; `theme-sync` only nudges running Neovim instances that do not always receive the system notification.

| Tool | Omarchy | macOS dark | macOS light | Mechanism |
|------|---------|------------|-------------|-----------|
| Ghostty | Omarchy theme | Rose Pine Moon | Rose Pine Dawn | `omarchy.conf` includes the theme; `macos.conf` follows macOS |
| Neovim | Omarchy theme | Rose Pine Moon | Rose Pine Dawn | Omarchy hot-reload; macOS reads appearance at startup, `theme-sync` nudges |
| Tmux | terminal colors | terminal colors | terminal colors | ANSI colors inherit the terminal palette |
| Lazygit | terminal colors | terminal colors | terminal colors | Uses Lazygit defaults |
| Claude Code | auto | dark | light | Uses built-in auto sync |

## License

This project is open source and available under the MIT License.
