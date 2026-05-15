#!/bin/zsh
#
# bootstrap.sh
#
# Idempotent Mac setup. Safe to run on a fresh machine or re-run anytime.
#
# Usage (new machine):
#   /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/cbracco/setup-macos/main/bootstrap.sh)"
#
# Usage (already cloned):
#   ./bootstrap.sh

set -e

REPO="https://github.com/cbracco/setup-macos.git"
CHEZMOI_SOURCE="$HOME/Development/www/setup-macos"

log()  { printf "\n\033[1;34m▶ %s\033[0m\n" "$1"; }
ok()   { printf "  \033[1;32m✓ %s\033[0m\n" "$1"; }
info() { printf "  \033[0;37m%s\033[0m\n" "$1"; }

# ---------------------------------------------------------------------------
# 1. Xcode Command Line Tools
# ---------------------------------------------------------------------------
log "Xcode Command Line Tools"
if xcode-select -p &>/dev/null; then
    ok "Already installed"
else
    info "Triggering installer — re-run this script when it completes."
    xcode-select --install
    exit 0
fi

# ---------------------------------------------------------------------------
# 2. Homebrew
# ---------------------------------------------------------------------------
log "Homebrew"
if command -v brew &>/dev/null; then
    ok "Already installed"
else
    info "Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# ---------------------------------------------------------------------------
# 3. chezmoi
# ---------------------------------------------------------------------------
log "chezmoi"
if command -v chezmoi &>/dev/null; then
    ok "Already installed"
else
    info "Installing..."
    brew install chezmoi
fi

# ---------------------------------------------------------------------------
# 4. Dotfiles
# ---------------------------------------------------------------------------
log "Dotfiles"
if [[ -d "$CHEZMOI_SOURCE/.git" ]]; then
    info "Repo already exists at $CHEZMOI_SOURCE — pulling latest..."
    git -C "$CHEZMOI_SOURCE" pull --ff-only
    ok "Up to date"
else
    info "Cloning to $CHEZMOI_SOURCE..."
    mkdir -p "$(dirname "$CHEZMOI_SOURCE")"
    git clone "$REPO" "$CHEZMOI_SOURCE"
fi
chezmoi init --source "$CHEZMOI_SOURCE"
chezmoi apply
ok "Applied"

# ---------------------------------------------------------------------------
# 5. Homebrew packages
# ---------------------------------------------------------------------------
log "Homebrew packages"
brew bundle --file="$CHEZMOI_SOURCE/Brewfile" --no-lock
ok "Done"

# ---------------------------------------------------------------------------
# 6. VSCode extensions
# ---------------------------------------------------------------------------
log "VSCode extensions"
if command -v code &>/dev/null; then
    while IFS= read -r ext || [[ -n "$ext" ]]; do
        [[ -z "$ext" || "$ext" == \#* ]] && continue
        code --install-extension "$ext" --force &>/dev/null
        ok "$ext"
    done < "$CHEZMOI_SOURCE/vscode/extensions.txt"
else
    info "Skipping — 'code' CLI not found. Open VSCode and run: Shell Command: Install 'code' in PATH"
fi

# ---------------------------------------------------------------------------
# 7. macOS defaults
# ---------------------------------------------------------------------------
log "macOS defaults"
CHEZMOI_COMPUTER_NAME="$(chezmoi data --format=json 2>/dev/null | python3 -c 'import sys,json; print(json.load(sys.stdin).get("computername",""))' 2>/dev/null || true)"
export CHEZMOI_COMPUTER_NAME
source "$CHEZMOI_SOURCE/macos/defaults.sh"
ok "Applied"

# ---------------------------------------------------------------------------
# 9. FileVault
# ---------------------------------------------------------------------------
log "FileVault"
if fdesetup status | grep -q "FileVault is On"; then
    ok "Already enabled"
else
    info "FileVault is OFF. Enable it in: System Settings → Privacy & Security → FileVault"
fi

# ---------------------------------------------------------------------------
# 10. SSH key
# ---------------------------------------------------------------------------
log "SSH key"
SSH_KEY="$HOME/.ssh/id_ed25519"
if [[ -f "$SSH_KEY" ]]; then
    ok "Already exists at $SSH_KEY"
else
    info "Generating Ed25519 key..."
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f "$SSH_KEY" -N ""
    ok "Generated $SSH_KEY"
fi
ssh-add -l 2>/dev/null | grep -q "$SSH_KEY" || ssh-add --apple-use-keychain "$SSH_KEY" &>/dev/null || true

ALLOWED_SIGNERS="$HOME/.ssh/allowed_signers"
GIT_EMAIL="$(git config --global user.email 2>/dev/null || true)"
PUB_KEY="$(cat "${SSH_KEY}.pub")"
if [[ -n "$GIT_EMAIL" ]] && ! grep -qF "$PUB_KEY" "$ALLOWED_SIGNERS" 2>/dev/null; then
    echo "$GIT_EMAIL $PUB_KEY" >> "$ALLOWED_SIGNERS"
    chmod 600 "$ALLOWED_SIGNERS"
    ok "Added key to $ALLOWED_SIGNERS"
fi

info "Public key — add to GitHub as both an SSH key and a signing key:"
cat "${SSH_KEY}.pub"

# ---------------------------------------------------------------------------
log "Bootstrap complete"
info "Next: add the SSH public key above to GitHub → https://github.com/settings/ssh/new"
info "Then restart your terminal to apply shell changes."
