#!/bin/sh
# Sets reasonable macOS defaults.
#
# Derived from Nix darwin defaults configuration:
# https://github.com/caarlos0/dotfiles/blob/2025.6.2/machines/shared/darwin.nix
#
# Run ./macos/set-defaults.sh and you'll be good to go.

if [ "$(uname -s)" != "Darwin" ]; then
  exit 0
fi

set +e

sudo -v

echo ""
echo "› System:"
echo "  › Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false

echo "  › Use AirDrop over every interface"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo "  › Set a really fast key repeat"
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

echo "  › Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

echo "  › Increase the window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.1

echo "  › Disable smart quotes, smart dashes, capitalization, period substitution, and auto-correct"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "  › Disable web automatic spelling correction"
defaults write -g WebAutomaticSpellingCorrectionEnabled -bool false

echo "  › Set dark interface style"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

echo "  › Set accent color to graphite"
defaults write -g AppleAccentColor -int 0

echo "  › Save to disk by default, instead of iCloud"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "  › Keep menu bar visible"
defaults write NSGlobalDomain _HIHideMenuBar -bool false

echo "  › Show Bluetooth icon in menu bar"
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

echo "  › Set springing delay to 0"
defaults write -g "com.apple.springing.delay" -float 0.0

echo "  › Set up trackpad & mouse speed"
defaults write -g com.apple.trackpad.scaling -int 2
defaults write -g com.apple.mouse.scaling -float 2.5

echo "  › Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "  › Don't avoid creating .DS_Store files on network volumes"
# Note: This is different from the typical setup - allows .DS_Store on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool false

echo "  › Keep quarantine enabled for the 'Are you sure you want to open this application?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool true

echo "  › Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo "  › Set sidebar icon size to small"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

echo "  › Enable WebKit developer extras"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

#############################

echo ""
echo "› Finder:"
echo "  › Always open everything in Finder's list view"
defaults write com.apple.Finder FXPreferredViewStyle -string "Nlsv"

echo "  › Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "  › Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "  › Show all files"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "  › Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true

echo "  › Show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo "  › Don't show external hard drives on desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

echo "  › Don't show removable media on desktop"
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

echo "  › Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

#############################

echo ""
echo "› Photos:"
echo "  › Disable it from starting every time a device is plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

#############################

echo ""
echo "› Mail:"
echo "  › Set email addresses to copy as 'Foo Bar <foo@example.com>'"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool true

echo "  › Display emails in threaded mode, sorted by date (newest at the top)"
defaults write com.apple.mail InboxViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail InboxViewerAttributes -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail InboxViewerAttributes -dict-add "SortOrder" -string "received-date"

echo "  › Disable inline attachments (just show the icons)"
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

echo "  › Disable send and reply animations in Mail.app"
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true

#############################

echo ""
echo "› Dock:"
echo "  › Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo "  › Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0

echo "  › Set Dock orientation to bottom"
defaults write com.apple.dock orientation -string "bottom"

echo "  › Setting the icon size of Dock items to 42 pixels"
defaults write com.apple.dock tilesize -int 42

echo "  › Show hidden apps in the Dock"
defaults write com.apple.dock showhidden -bool true

echo "  › Show recent applications in Dock"
defaults write com.apple.dock show-recents -bool true

echo "  › Show process indicators in Dock"
defaults write com.apple.dock show-process-indicators -bool true

echo "  › Speed up Mission Control animations and group windows by application"
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock expose-group-apps -bool true

echo "  › Don't animate opening applications from the Dock"
defaults write com.apple.dock launchanim -bool false

echo "  › Set Dock mineffect to scale"
defaults write com.apple.dock mineffect -string "scale"

echo "  › Don't automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

echo "  › Make Dock size immutable"
defaults write com.apple.dock size-immutable -bool true

#############################

echo ""
echo "› Ghostty:"
echo "  › Remap 'Hide Ghostty' to F11 (so Super+H can be used for split navigation)"
defaults write com.mitchellh.ghostty NSUserKeyEquivalents -dict-add "Hide Ghostty" "\\UF70E"

#############################

echo ""
echo "› Safari:"
echo "  › Set up Safari for development"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo "  › Show full URL in Smart Search field"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

echo "  › Don't automatically open safe downloads"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

echo "  › Set Safari homepage to blank"
defaults write com.apple.Safari HomePage -string ""

echo "  › Disable Safari auto-fill"
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false

echo "  › Configure Safari session restoration"
defaults write com.apple.Safari AlwaysRestoreSessionAtLaunch -int 1
defaults write com.apple.Safari ExcludePrivateWindowWhenRestoringSessionAtLaunch -int 1

echo "  › Configure Safari favorites"
defaults write com.apple.Safari ShowBackgroundImageInFavorites -int 0
defaults write com.apple.Safari ShowFrequentlyVisitedSites -int 1
defaults write com.apple.Safari ShowHighlightsInFavorites -int 1
defaults write com.apple.Safari ShowPrivacyReportInFavorites -int 1
defaults write com.apple.Safari ShowRecentlyClosedTabsPreferenceKey -int 1

#############################

echo ""
echo "› Restart related apps"
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Ghostty" "Mail" "Messages" "Safari" "SystemUIServer" \
  "Terminal" "Photos" "Image Capture"; do
  killall "$app" >/dev/null 2>&1
done
set -e

echo "Done. Some changes need a restart to take effect."
