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

host="$(hostname -s)"

echo ""
echo "› System:"
echo "  › Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false

echo "  › Use AirDrop over every interface"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo "  › Set a really fast key repeat"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "  › Show scrollbars automatically"
defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"

echo "  › Clicking the scrollbar jumps to the spot that was clicked"
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true

echo "  › Double-clicking a title bar fills the window"
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Fill"

echo "  › Tint window background with wallpaper color"
defaults write NSGlobalDomain AppleReduceDesktopTinting -bool false

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

echo "  › Set accent color to blue"
defaults write -g AppleAccentColor -int 4
defaults write -g AppleAquaColorVariant -int 1

echo "  › Save to disk by default, instead of iCloud"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "  › Keep menu bar visible"
defaults write NSGlobalDomain _HIHideMenuBar -bool false

echo "  › Show Bluetooth icon in menu bar"
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

echo "  › Set springing delay to 0"
defaults write -g "com.apple.springing.delay" -float 0.0

echo "  › Set up trackpad & mouse speed"
defaults write -g com.apple.trackpad.scaling -float 1.5
defaults write -g com.apple.mouse.scaling -float 2.5
defaults write -g com.apple.trackpad.forceClick -bool true

echo "  › Trackpad: no tap-to-click, no three-finger drag, two-finger right click"
for domain in com.apple.AppleMultitouchTrackpad \
  com.apple.driver.AppleBluetoothMultitouch.trackpad; do
  defaults write "$domain" Clicking -bool false
  defaults write "$domain" Dragging -bool false
  defaults write "$domain" DragLock -bool false
  defaults write "$domain" TrackpadThreeFingerDrag -bool false
  defaults write "$domain" TrackpadThreeFingerTapGesture -int 0
  defaults write "$domain" TrackpadRightClick -bool true
  defaults write "$domain" TrackpadCornerSecondaryClick -int 0
  defaults write "$domain" TrackpadHandResting -bool true
done

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

echo "  › Don't reduce motion"
defaults write com.apple.universalaccess reduceMotion -bool false

echo "  › Don't reduce transparency"
defaults write com.apple.universalaccess reduceTransparency -bool false

echo "  › Globe/fn key switches input source"
defaults write com.apple.HIToolbox AppleFnUsageType -int 1

echo "  › Enable U.S. and U.S. International - PC keyboard layouts"
defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
  "<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>0</integer><key>KeyboardLayout Name</key><string>U.S.</string></dict>" \
  "<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>15000</integer><key>KeyboardLayout Name</key><string>USInternational-PC</string></dict>" \
  "<dict><key>Bundle ID</key><string>com.apple.CharacterPaletteIM</string><key>InputSourceKind</key><string>Non Keyboard Input Method</string></dict>" \
  "<dict><key>Bundle ID</key><string>com.apple.PressAndHold</string><key>InputSourceKind</key><string>Non Keyboard Input Method</string></dict>"

echo "  › Show AM/PM and day of week in the menu bar clock, but not the date"
defaults write com.apple.menuextra.clock ShowAMPM -bool true
defaults write com.apple.menuextra.clock ShowDate -int 0
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true

echo "  › Show battery, clock, wi-fi and focus modes in the menu bar"
defaults write com.apple.controlcenter "NSStatusItem VisibleCC Battery" -bool true
defaults write com.apple.controlcenter "NSStatusItem VisibleCC Clock" -bool true
defaults write com.apple.controlcenter "NSStatusItem VisibleCC WiFi" -bool true
defaults write com.apple.controlcenter "NSStatusItem VisibleCC FocusModes" -bool true
defaults write com.apple.controlcenter "NSStatusItem VisibleCC BentoBox-0" -bool true

echo "  › No margins around tiled windows"
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

echo "  › Hide desktop icons until the wallpaper is clicked"
defaults write com.apple.WindowManager HideDesktop -bool true

# CleanShot handles screenshots, so the built-in shortcuts are freed up:
# 28/29 = whole screen (file/clipboard), 30/31 = selection (file/clipboard),
# 184 = the screenshot & recording UI (shift-cmd-5). 164 is the Quick Note
# hot corner, which fires by accident far too often.
echo "  › Disable the built-in screenshot shortcuts and the Quick Note hot corner"
disable_hotkey() {
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$1" \
    "<dict><key>enabled</key><false/><key>value</key><dict><key>type</key><string>standard</string><key>parameters</key><array><integer>$2</integer><integer>$3</integer><integer>$4</integer></array></dict></dict>"
}
disable_hotkey 28 51 20 1179648
disable_hotkey 29 51 20 1441792
disable_hotkey 30 52 21 1179648
disable_hotkey 31 52 21 1441792
disable_hotkey 184 53 23 1179648
disable_hotkey 164 65535 65535 0

# The whole array is replaced, so every replacement has to be listed here.
echo "  › Set up text replacements"
defaults delete -g NSUserDictionaryReplacementItems >/dev/null 2>&1
add_replacement() {
  defaults write -g NSUserDictionaryReplacementItems -array-add \
    "<dict><key>on</key><integer>1</integer><key>replace</key><string>$1</string><key>with</key><string>$2</string></dict>"
}
add_replacement "hmm" "🤔"
add_replacement "lol:" "🤣"
add_replacement "/shit" "💩"
add_replacement "/dufi" "🗑🔥"
add_replacement "/dafuq" "ಠ_ಠ"
add_replacement "/fuck" "❨╯°□°❩╯︵┻━┻"
add_replacement "/rs" "( ͡° ͜ʖ ͡°)"
add_replacement "/shrug" "¯\\_(ツ)_/¯"
add_replacement "/blog" "https://carlosbecker.com"
add_replacement "/contacts" "https://caarlos0.dev"
add_replacement "/email" "carlos@becker.software"
add_replacement "/gorel" "https://github.com/goreleaser/goreleaser"
add_replacement "omw" "On my way!"
add_replacement "eac" "Estou a caminho!"
add_replacement "lmk" "let me know"
add_replacement "np" "no problem"
add_replacement "blz" "beleza"
add_replacement "msm" "mesmo"
add_replacement "msma" "mesma"
add_replacement "nao" "não"
add_replacement "nd" "nada"
add_replacement "tbm" "também"
add_replacement "vc" "você"
add_replacement "voce" "você "
# These two expand to themselves, purely to stop autocorrect mangling them.
add_replacement "bosta" "bosta"
add_replacement "mais" "mais"

echo "  › Set solid black wallpaper"
osascript -e 'tell application "System Events" to tell every desktop to set picture to "/System/Library/Desktop Pictures/Solid Colors/Black.png"'

#############################

echo ""
echo "› Finder:"
echo "  › Always open everything in Finder's icon view"
defaults write com.apple.finder FXPreferredViewStyle -string "icnv"

echo "  › Sort folders before files"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo "  › New windows open in the home folder"
defaults write com.apple.finder NewWindowTarget -string "PfHm"

echo "  › Search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

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

echo "  › Don't show hard drives on desktop"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

echo "  › Don't show external hard drives on desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

echo "  › Don't show removable media on desktop"
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

echo "  › Don't keep the desktop and documents in iCloud Drive"
defaults write com.apple.finder FXICloudDriveDesktop -bool false

echo "  › Keep the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool true

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

echo "  › Don't show recent applications in Dock"
defaults write com.apple.dock show-recents -bool false

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

# The app list lives in macos/dock.<host>.txt because the personal and work
# machines don't dock the same apps. Missing apps are skipped rather than
# leaving a "?" tile behind.
dock_list="$(dirname "$0")/dock.$host.txt"
if [ -f "$dock_list" ]; then
  echo "  › Set Dock apps from dock.$host.txt"
  defaults delete com.apple.dock persistent-apps >/dev/null 2>&1
  while IFS= read -r app; do
    case "$app" in '' | '#'*) continue ;; esac
    if [ ! -e "$app" ]; then
      echo "    › Skipping $app, not installed"
      continue
    fi
    defaults write com.apple.dock persistent-apps -array-add \
      "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
  done <"$dock_list"

  echo "  › Keep only Downloads in the Dock's folder section"
  defaults delete com.apple.dock persistent-others >/dev/null 2>&1
  defaults write com.apple.dock persistent-others -array-add \
    "<dict><key>tile-type</key><string>directory-tile</string><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$HOME/Downloads/</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
else
  echo "  › No dock.$host.txt, leaving Dock apps alone"
fi

#############################

echo ""
echo "› Terminals:"
echo "  › Remap 'Hide Ghostty' to F11 (so Super+H can be used for split navigation)"
defaults write com.mitchellh.ghostty NSUserKeyEquivalents -dict-add "Hide Ghostty" "\\UF70E"
echo "  › Remap 'Hide rio' to F11 (so Super+H can be used for split navigation)"
defaults write com.raphaelamorim.rio NSUserKeyEquivalents -dict-add "Hide rio" "\\UF70E"

#############################

echo ""
echo "› Safari:"
# Safari's prefs live in its sandbox container, so these writes silently do
# nothing unless the terminal running this script has Full Disk Access.
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
  "ControlCenter" "Dock" "Finder" "Ghostty" "Mail" "Messages" "Safari" \
  "SystemUIServer" "Terminal" "Photos" "Image Capture"; do
  killall "$app" >/dev/null 2>&1
done
set -e

echo "Done. Some changes (keyboard shortcuts, input sources) need a log out to take effect."
