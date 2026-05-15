#!/bin/zsh
#
# macos/defaults.sh
#
# Apply sensible macOS defaults. Safe to re-run.
# A logout/restart is required for some settings to take effect.

# Close System Preferences to prevent conflicts
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true

###############################################################################
# Computer name
###############################################################################

COMPUTER_NAME="${CHEZMOI_COMPUTER_NAME:-}"
if [[ -n "$COMPUTER_NAME" ]]; then
    sudo scutil --set ComputerName "$COMPUTER_NAME"
    sudo scutil --set HostName "$COMPUTER_NAME"
    sudo scutil --set LocalHostName "$COMPUTER_NAME"
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"
fi

###############################################################################
# General UI/UX
###############################################################################

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Save to disk (not iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

###############################################################################
# Input — Keyboard & Trackpad
###############################################################################

# Set fast key repeat rate (1 = fastest, 2 is also fast)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Enable tap-to-click for trackpad
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable full keyboard access for all controls (tab through dialog buttons)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

###############################################################################
# Screen
###############################################################################

# Require password immediately after sleep or screen saver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to Desktop as PNG
defaults write com.apple.screencapture location -string "${HOME}/Desktop"
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder
###############################################################################

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable extension change warning
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show status bar and path bar
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path in Finder title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Default to column view
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view for all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

###############################################################################
# Dock
###############################################################################

# Set icon size to 48px
defaults write com.apple.dock tilesize -int 48

# Enable spring loading for Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Minimize windows into their application icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator dots for open applications
defaults write com.apple.dock show-process-indicators -bool true

# Don't show recently used apps in Dock
defaults write com.apple.dock show-recents -bool false

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Remove the auto-hide delay
defaults write com.apple.dock autohide-delay -float 0

# Speed up the auto-hide animation
defaults write com.apple.dock autohide-time-modifier -float 0.5

# Hot corners
# Possible values: 0=no-op, 2=Mission Control, 3=Application Windows,
#   4=Desktop, 5=Start Screen Saver, 6=Disable Screen Saver,
#   7=Dashboard, 10=Put Display to Sleep, 11=Launchpad, 12=Notification Center
defaults write com.apple.dock wvous-tl-corner -int 2   # top-left: Mission Control
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 4   # top-right: Desktop
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 5   # bottom-left: Screen Saver
defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Safari
###############################################################################

# macOS Sonoma+ sandboxes Safari — must write to the container preferences path
SAFARI_PREFS="$HOME/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari"
if [[ -d "$(dirname "$SAFARI_PREFS")" ]]; then
    defaults write "$SAFARI_PREFS" IncludeDevelopMenu -bool true
    defaults write "$SAFARI_PREFS" WebKitDeveloperExtrasEnabledPreferenceKey -bool true
    defaults write "$SAFARI_PREFS" AutoOpenSafeDownloads -bool false
    defaults write "$SAFARI_PREFS" ShowFullURLInSmartSearchField -bool true
else
    echo "  Skipping Safari defaults: container not found (open Safari once, then re-run)"
fi

###############################################################################
# TextEdit
###############################################################################

# Use plain text by default
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Activity Monitor
###############################################################################

# Show the main window when launching
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# User Avatar
###############################################################################

ASSETS_DIR="${CHEZMOI_SOURCE:-${0:A:h:h}}/assets"
USER_PICTURE="$ASSETS_DIR/UserPicture.jpg"
USER_PICTURE_DEST="/Library/User Pictures/$(whoami).jpg"

if [[ -f "$USER_PICTURE" ]]; then
    sudo mkdir -p "$(dirname "$USER_PICTURE_DEST")"
    sudo cp "$USER_PICTURE" "$USER_PICTURE_DEST"
    sudo chmod 644 "$USER_PICTURE_DEST"

    # Clear existing picture data then import new one
    sudo dscl . delete /Users/"$(whoami)" JPEGPhoto 2>/dev/null || true
    sudo dscl . delete /Users/"$(whoami)" Picture 2>/dev/null || true

    DSIMPORT_FILE="$(mktemp /tmp/$(whoami)_dsimport.XXXXXX)"
    printf "0x0A 0x5C 0x3A 0x2C dsRecTypeStandard:Users 2 dsAttrTypeStandard:RecordName externalbinary:dsAttrTypeStandard:JPEGPhoto\n%s:%s" \
        "$(whoami)" "$USER_PICTURE_DEST" > "$DSIMPORT_FILE"
    sudo /usr/bin/dsimport "$DSIMPORT_FILE" /Local/Default M
    rm -f "$DSIMPORT_FILE"
else
    echo "  Skipping avatar: $USER_PICTURE not found"
fi

###############################################################################
# Desktop Wallpaper
###############################################################################

DESKTOP_BG="$ASSETS_DIR/DesktopBackground.jpg"

DESKTOPPR="$(command -v desktoppr 2>/dev/null || echo /opt/homebrew/bin/desktoppr)"
if [[ -f "$DESKTOP_BG" ]] && [[ -x "$DESKTOPPR" ]]; then
    "$DESKTOPPR" "$DESKTOP_BG"
else
    echo "  Skipping wallpaper: file or desktoppr not found"
fi

###############################################################################
# Restart affected apps
###############################################################################

for app in "Dock" "Finder" "Safari" "SystemUIServer"; do
    killall "$app" &>/dev/null || true
done

echo "macOS defaults applied. Some changes require a logout or restart."
