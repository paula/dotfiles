#!/usr/bin/env bash
set -euo pipefail

DOTFILES_PATH="$HOME/dotfiles"

# Symlink dotfiles to the root within your workspace
find $DOTFILES_PATH -type f -path "$DOTFILES_PATH/.*" |
while read df; do
  link=${df/$DOTFILES_PATH/$HOME}
  mkdir -p "$(dirname "$link")"
  ln -sf "$df" "$link"
done

sudo apt-get update && sudo apt-get install -y cowsay
sudo apt-get install -y fzf

# Install fzf keybindings + completion (if available)
[ -f /usr/share/doc/fzf/examples/install ] && /usr/share/doc/fzf/examples/install --key-bindings --completion --no-update-rc || true
