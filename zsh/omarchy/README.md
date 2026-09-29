Verbatim copies of Omarchy's bash aliases and functions
(`/usr/share/omarchy/default/bash/`), sourced by `../.zshrc` so macOS zsh
matches Omarchy's shell. Don't edit these; refresh them from an Omarchy machine:

    cp /usr/share/omarchy/default/bash/aliases zsh/omarchy/aliases
    for f in tmux worktrees ssh-reconnect ssh-port-forwarding compression; do
      cp /usr/share/omarchy/default/bash/fns/$f zsh/omarchy/fns/$f
    done

Left out (Linux-only): fns/drives, fns/rsyncing (inotifywait/setsid), fns/herdr.
Local overrides belong in `.zshrc` after the source lines.
