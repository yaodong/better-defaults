# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# Per-user mise tools: mise loads mise/config.<whoami>.toml on top of config.toml
export MISE_ENV="${MISE_ENV:-$(whoami)}"

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
alias vi=nvim
alias vim=nvim

# Source machine-local overrides
[ -f "$HOME/.bashrc_local" ] && source "$HOME/.bashrc_local"

# Ghostty: every new tab/window gets a fresh tmux session. Closing that session
# closes the tab, instead of switching to another session (tmux.conf sets
# detach-on-destroy off globally, as Omarchy does).
if [ "$TERM_PROGRAM" = "ghostty" ] && [ -z "$TMUX" ] && command -v tmux >/dev/null 2>&1; then
  exec tmux new-session -c "$HOME/Developer" \; set-option detach-on-destroy on
fi
