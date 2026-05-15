# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
