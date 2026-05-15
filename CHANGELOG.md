# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.16] - 2026-05-15

### Added
- `.chezmoiignore` — prevent `bootstrap.sh`, `Brewfile`, `CHANGELOG.md`, `README.md`, `assets/`, `macos/`, and `vscode/` from being copied to `$HOME` by `chezmoi apply`

### Fixed
- `bootstrap.sh` — export `CHEZMOI_SOURCE` so `defaults.sh` inherits the correct value
- `bootstrap.sh` — pass `--force` to `chezmoi apply` to always overwrite without prompting
- `macos/defaults.sh` — write Safari defaults to the sandboxed container path (macOS Sonoma+) instead of `com.apple.Safari`, which was failing silently
- `macos/defaults.sh` — derive assets directory from the script's own location when `CHEZMOI_SOURCE` is not set, fixing avatar and wallpaper skips
- `macos/defaults.sh` — look for `desktoppr` at `/opt/homebrew/bin/desktoppr` as a fallback when it is not yet on `$PATH`

## [1.0.15] - 2026-05-15

### Added
- `Brewfile` — add `claude-code` cask

## [1.0.14] - 2026-05-15

### Fixed
- `vscode/extensions.txt` — correct Vue extension ID from `vue.vue-official` to `vue.volar`

## [1.0.13] - 2026-05-15

### Fixed
- `bootstrap.sh` — wrap `chezmoi data` with `set +e`/`set -e` to prevent zsh from propagating `errexit` through command substitution
- `bootstrap.sh` — wrap each VSCode extension install in an `if` block so a single failure prints a warning and continues instead of silently exiting the loop

## [1.0.12] - 2026-05-15

### Fixed
- `bootstrap.sh` — run `defaults.sh` in a subshell instead of sourcing it so errors inside don't silently exit the bootstrap via `set -e`

## [1.0.11] - 2026-05-15

### Fixed
- `Brewfile` — move `desktoppr` from formula to cask

## [1.0.10] - 2026-05-15

### Changed
- `Brewfile` — remove deprecated `homebrew/cask-fonts` tap; fonts are now available directly from the main `homebrew/cask` tap

## [1.0.9] - 2026-05-15

### Fixed
- `bootstrap.sh` — remove manual chezmoi config writing; let chezmoi handle config creation via `.chezmoi.yaml.tmpl` and `promptStringOnce`, which resolves both the multiple config file conflict and re-prompting on re-runs

## [1.0.8] - 2026-05-15

### Fixed
- `bootstrap.sh` — prompt for name, email, and computer name on first run and write them directly to `~/.config/chezmoi/chezmoi.yaml`; reuse stored values on re-runs instead of relying on `chezmoi init` to prompt

## [1.0.7] - 2026-05-15

### Fixed
- `bootstrap.sh` — use `chezmoi init --source` to process `.chezmoi.yaml.tmpl` and write config, avoiding multiple config file conflict; remove redundant `--source` from `chezmoi data` since init sets it up

## [1.0.6] - 2026-05-15

### Fixed
- `bootstrap.sh` — write `~/.config/chezmoi/chezmoi.toml` with `sourceDir` before running `chezmoi apply` so chezmoi knows where the source is without relying on the default path

## [1.0.5] - 2026-05-15

### Fixed
- `bootstrap.sh` — remove `chezmoi init` call entirely; apply dotfiles directly with `chezmoi apply --source` since the repo clone is managed by the script itself

## [1.0.4] - 2026-05-15

### Fixed
- `bootstrap.sh` — pass `--source` explicitly to `chezmoi apply` to avoid falling back to default path

## [1.0.3] - 2026-05-15

### Fixed
- `bootstrap.sh` — pull latest changes from GitHub when repo already exists instead of skipping silently

## [1.0.2] - 2026-05-15

### Added
- `assets/UserPicture.jpg` and `assets/DesktopBackground.jpg` — commit user avatar and desktop background assets to the repository

## [1.0.1] - 2026-04-28

### Changed
- `dot_claude/settings.json` — add `showThinkingSummaries`, `autoUpdatesChannel`, `cleanupPeriodDays`, `tui`, `viewMode`, `defaultMode`, and `additionalDirectories` settings

## [1.0.0] - 2026-04-22

### Added
- `bootstrap.sh` — idempotent setup script
- `Brewfile` — Homebrew packages and casks
- `macos/defaults.sh` — macOS system preferences, wallpaper, and avatar
- `vscode/extensions.txt` — VSCode extensions
- Dotfiles: `.zshrc`, `.zprofile`, `.gitconfig`, `.gitignore_global`, `.editorconfig`, `.inputrc`, `.vimrc`, `.hushlogin`
- `dot_config/mise/config.toml` — runtime version management
- `dot_config/starship/starship.toml` — shell prompt
- `dot_ssh/config` — SSH configuration
- `dot_default-npm-packages`, `dot_default-python-packages` — global runtime packages
- VSCode `settings.json` and `keybindings.json`
