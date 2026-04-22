# setup-macos

Idempotent macOS setup. Safe to run on a fresh machine or re-run anytime.

## What it does

1. Installs Xcode Command Line Tools
2. Installs Homebrew
3. Installs [chezmoi](https://chezmoi.io) and applies dotfiles
4. Installs Homebrew packages and casks (`Brewfile`)
5. Installs VSCode extensions (`vscode/extensions.txt`)
6. Applies macOS system preferences (`macos/defaults.sh`)
7. Checks that FileVault is enabled
8. Generates an SSH key, adds it to the macOS keychain, and configures it for commit signing

## What's configured

**Shell**
- zsh with sensible history, completion, and key binding defaults
- [mise](https://mise.jdx.dev) for runtime version management and installing global packages
- [Starship](https://starship.rs) for prompt customization
- Aliases for navigation, git, filesystem, and macOS utilities
- `.editorconfig` for consistent default formatting across editors
- `.inputrc` for readline improvements (python REPL, psql, etc.)

**Git**
- Aliases, sensible defaults, SSH commit signing

**Vim**
- Theme and plugins via vim-plug (auto-installs on first launch)

**SSH**
- Ed25519 key generated on first run, added to macOS keychain
- `~/.ssh/config` with ForwardAgent, UseKeychain, and identity file configured

**VSCode**
- Color and icon themes, settings, and keybindings synced via chezmoi

**macOS**
- Preferences for Finder, Dock, keyboard, trackpad, screenshot, security, and more
- Desktop wallpaper and user avatar
- Computer name (set on first run)

## Usage

```sh
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/cbracco/setup-macos/main/bootstrap.sh)"
```

This clones the repo to your local dev directory, runs setup from there, and prompts you for your:

- Full name
- Email address
- Computer name

To apply changes after editing:

```sh
chezmoi apply
```

## Compatibility

This has only been tested on **macOS Ventura 13 (and later), on Apple Silicon**. The Homebrew path is hardcoded to `/opt/homebrew` which is Apple Silicon only.

Intel Macs are not officially supported.
