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

OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
  # macOS (laptop)
  if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Install it from https://brew.sh first."
    exit 1
  fi

  brew install cowsay fzf

  # Install fzf keybindings + completion
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc

elif [[ "$OS" == "Linux" ]]; then
  # Linux (remote container)
  sudo apt-get update && sudo apt-get install -y cowsay fzf

  # Install fzf keybindings + completion (if available)
  [ -f /usr/share/doc/fzf/examples/install ] && \
    /usr/share/doc/fzf/examples/install --key-bindings --completion --no-update-rc || true

else
  echo "Unsupported OS: $OS"
  exit 1
fi
