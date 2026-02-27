#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    read -p "$dst already exists. Overwrite? [y/N] " answer
    [[ "$answer" =~ ^[Yy]$ ]] || return
  fi
  ln -sfn "$src" "$dst"
}

# Home directory symlinks
for name in .bash .bash_profile .bashrc .emacs.d; do
  link "$DOTFILES/$name" "$HOME/$name"
done

# Claude Code config - symlink individual files into existing ~/.claude/
mkdir -p "$HOME/.claude"
for file in CLAUDE.md .claudeignore settings.json statusline-command.sh; do
  link "$DOTFILES/.claude/$file" "$HOME/.claude/$file"
done
