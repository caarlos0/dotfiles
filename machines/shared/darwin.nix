{ pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
  };
  services = { nix-daemon = { enable = true; }; };
  nix.package = pkgs.nix;
  nix.settings.trusted-users = [ "root" "carlos" ];
  system.stateVersion = 5;

  users.users.carlos = {
    name = "carlos";
    home = "/Users/carlos";
  };

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "appcleaner"
      "cleanshot"
      "deckset"
      "discord"
      # "contexts"
      "figma"
      "font-jetbrains-mono"
      "font-jetbrains-mono-nerd-font"
      "google-chrome"
      "hammerspoon"
      "imageoptim"
      "ledger-live"
      "monodraw"
      "signal"
      "slack"
      "soulver"
      "telegram"
      "vlc"
      "whatsapp"
      "zoom"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Lungo" = 1263070803;
      # "Today •" = 2146219664; always fails for some reason
    };
  };

  system = {
    defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        orientation = "bottom";
        tilesize = 42;
        showhidden = true;
        show-recents = true;
        show-process-indicators = true;
        expose-animation-duration = 0.1;
        expose-group-by-app = true;
        launchanim = false;
        mineffect = "scale";
        mru-spaces = false;
        persistent-apps = [
          "/System/Applications/Reminders.app"
          "/System/Applications/Notes.app"
          "/System/Applications/Calendar.app"
          "/System/Cryptexes/App/System/Applications/Safari.app"
          "/Applications/Ghostty.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Messages.app"
          "/Applications/Discord.app"
          "/System/Applications/Music.app"
        ];
      };
      NSGlobalDomain = {
        ApplePressAndHoldEnabled = false;
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        AppleShowScrollBars = "Always";
        NSWindowResizeTime = 0.1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        AppleInterfaceStyle = "Dark";
        NSDocumentSaveNewDocumentsToCloud = false;
        _HIHideMenuBar = false;
        "com.apple.springing.delay" = 0.0;
      };
      finder = {
        FXPreferredViewStyle = "Nlsv";
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
        AppleShowAllFiles = true;
        ShowStatusBar = true;
        ShowPathbar = true;
      };
      CustomUserPreferences = {
        "com.apple.NetworkBrowser" = { BrowseAllInterfaces = true; };
        "com.apple.screensaver" = {
          askForPassword = true;
          askForPasswordDelay = 0;
        };
        "com.apple.trackpad" = { scaling = 2; };
        "com.apple.mouse" = { scaling = 2.5; };
        "com.apple.desktopservices" = { DSDontWriteNetworkStores = false; };
        "com.apple.LaunchServices" = { LSQuarantine = true; };
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
          WarnOnEmptyTrash = false;
        };
        "NSGlobalDomain" = {
          NSNavPanelExpandedStateForSaveMode = true;
          NSTableViewDefaultSizeMode = 1;
          WebKitDeveloperExtras = true;
        };
        "com.apple.ImageCapture" = { "disableHotPlug" = true; };
        "com.apple.mail" = {
          DisableReplyAnimations = true;
          DisableSendAnimations = true;
          DisableInlineAttachmentViewing = true;
          AddressesIncludeNameOnPasteboard = true;
          InboxViewerAttributes = {
            DisplayInThreadedMode = "yes";
            SortedDescending = "yes";
            SortOrder = "received-date";
          };
          NSUserKeyEquivalents = {
            Send = "@\U21a9";
            Archive = "@$e";
          };
        };
        "com.apple.dock" = {
          size-immutable = true;
        };
        "com.apple.Safari" = {
          IncludeInternalDebugMenu = true;
          IncludeDevelopMenu = true;
          WebKitDeveloperExtrasEnabledPreferenceKey = true;
          ShowFullURLInSmartSearchField = true;
          AutoOpenSafeDownloads = false;
          HomePage = "";
          AutoFillCreditCardData = false;
          AutoFillFromAddressBook = false;
          AutoFillMiscellaneousForms = false;
          AutoFillPasswords = false;
          "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
          AlwaysRestoreSessionAtLaunch = 1;
          ExcludePrivateWindowWhenRestoringSessionAtLaunch = 1;
          ShowBackgroundImageInFavorites = 0;
          ShowFrequentlyVisitedSites = 1;
          ShowHighlightsInFavorites = 1;
          ShowPrivacyReportInFavorites = 1;
          ShowRecentlyClosedTabsPreferenceKey = 1;
        };
      };
    };
  };
}
