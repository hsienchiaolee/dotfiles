# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing Emacs configuration, Bash shell customizations, and development environment setup for macOS.

## Structure

- `.emacs.d/` - Emacs configuration with modular settings files
  - `init.el` - Main entry point that loads all settings modules
  - `settings/` - Individual feature configurations (setup-*.el, shortcut-*.el, misc.el, utils.el)
  - `custom.el` - Emacs custom variables (auto-generated)
- `.bash/` - Modular Bash configuration files
  - Loaded by `.bash_profile` in order: exports, path, bash_prompt, aliases, functions, extra
- `.config/mise/config.toml` - mise global tool versions (symlinked to `~/.config/mise/config.toml`)
- `.gitconfig` - Git configuration
- `direnv/` - direnv configuration templates

## Emacs Configuration

### Package Management

Uses `use-package` for declarative package configuration. Packages are installed from GNU ELPA, MELPA, and MELPA Stable.

Key packages:
- `no-littering` - Keeps `.emacs.d/` clean by organizing auto-save and backup files in `.emacs.d/var/`
- `lsp-mode` with `lsp-ui` - Language Server Protocol support
- `company` - Auto-completion
- `claude-code` - Claude Code integration via `monet` server
- `apheleia` - Auto-formatting (currently configured for Python with ruff)

### Editing Existing Settings

When modifying Emacs configuration:
1. Settings are organized by feature in `settings/` (setup-*.el for features, shortcut-*.el for keybindings)
2. Each settings file must end with `(provide 'filename)` matching the filename
3. `init.el` loads settings with `(require 'filename)`
4. After making changes, test by evaluating the buffer or restarting Emacs

### Language Support

Configured languages in `setup-prog-mode.el`:
- **Go**: Uses `lsp-mode` with gopls, auto-formats on save
  - Dependency: `go install golang.org/x/tools/gopls@latest`
- **Python**: Uses `lsp-pyright` with `apheleia` + ruff for formatting
  - Dependencies: `uv add --dev pyright ruff` (in project directories)
  - Python and uv are managed by mise
- **Scala**: Uses `lsp-metals`
- **Rust**: Auto-formats on save via `rust-mode`
- **Others**: Swift, Terraform, YAML, Markdown, Protobuf

## Tool Version Management

Uses `mise` to manage all language runtimes (node, ruby, python, go, rust, java) and tools like `uv`.

- Global config: `~/.config/mise/config.toml` (symlinked from `.config/mise/config.toml` in this repo)
- Per-project versions: `.mise.toml` in project root
- `mise use <tool>@<version>` to set versions
- `mise install` to install all configured tools

## Python Development Setup

Uses `mise` for Python version management and `uv` (installed via mise) for Python packages.

### Installing Python Versions
```bash
mise use python@VERSION
```

### Project Setup with direnv

One-time setup (enables `use mise` in `.envrc` files):
```bash
mkdir -p ~/.config/direnv
mise direnv activate > ~/.config/direnv/direnvrc
```

Copy the template from `direnv/python-project/.envrc`:
```bash
use mise
export VIRTUAL_ENV=".venv"
layout python
```

Then run:
```bash
direnv allow
```

This auto-activates mise tool versions and the virtualenv when entering the directory.

### Adding Dev Dependencies
```bash
uv add --dev pyright ruff
```

## Making Changes

### Adding a New Emacs Package

1. Add configuration to appropriate `settings/setup-*.el` file (or create new one)
2. Use `use-package` format:
   ```elisp
   (use-package package-name
     :ensure t
     :config
     ;; configuration here
     )
   ```
3. If creating a new settings file, add `(require 'setup-filename)` to `init.el`

### Adding Bash Functionality

- Aliases: Add to `.bash/aliases`
- Functions: Add to `.bash/functions`
- PATH modifications: Add to `.bash/path`
- Environment variables: Add to `.bash/exports`

All files in `.bash/` are automatically sourced by `.bash_profile`.

## Claude Code Integration

This repository has Claude Code integration set up in Emacs via:
- `claude-code.el` package
- `monet` server for Emacs interaction
- `vterm` as terminal backend

