# macOS zsh, set up to match Omarchy's bash (/usr/share/omarchy/default/bash).
# Omarchy's aliases and functions are copied verbatim into ./omarchy/.

ZSH_CONFIG_DIR="${${(%):-%x}:A:h}"

# --- Environment (Omarchy: envs) ---
export EDITOR=nvim
export SUDO_EDITOR="$EDITOR"
export BAT_THEME=ansi

# Color man pages with bat
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

export LANG=en_US.UTF-8

# Per-user mise tools: mise loads mise/config.<whoami>.toml on top of config.toml
export MISE_ENV="${MISE_ENV:-$(whoami)}"

export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$HOME/.bun/bin:$PATH"

# --- Shell (Omarchy: shell, inputrc) ---
# History: append, skip duplicates and space-prefixed commands (bash's ignoreboth)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=32768
SAVEHIST=$HISTSIZE
setopt append_history hist_ignore_dups hist_ignore_space

# Completion: case-insensitive, list all matches at once
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ''
setopt no_list_ambiguous

# Emacs keys, like bash/readline
bindkey -e

# Arrow keys match what you've typed so far against your command history
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search

# --- Aliases and functions (Omarchy: aliases, fns/*) ---
# Loaded in ksh emulation so bash-isms (0-based arrays, word splitting) behave
# as they do in bash; zsh keeps that emulation whenever the functions run.
emulate ksh -c "source '$ZSH_CONFIG_DIR/omarchy/aliases'"
for f in "$ZSH_CONFIG_DIR"/omarchy/fns/*; do
  emulate ksh -c "source '$f'"
done
unset f

# Omarchy's open() wraps xdg-open; macOS has its own open.
unfunction open 2>/dev/null

alias vi=nvim
alias vim=nvim

# --- Tools (Omarchy: init) ---
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

if [[ ${TERM:-} != "dumb" ]] && command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# fzf: Ctrl+R history, Ctrl+T files, Alt+C directories
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

# --- zsh-only extra: autosuggestions ---
if command -v brew &>/dev/null && [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
bindkey '^I^I' autosuggest-accept # tab + tab
bindkey '^[[Z' autosuggest-accept # shift + tab

# Source machine-local overrides
[ -f "$HOME/.zshrc_local" ] && source "$HOME/.zshrc_local"
