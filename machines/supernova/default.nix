{ pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
  };
  services = { nix-daemon = { enable = true; }; };
  nix.package = pkgs.nix;
  nix.settings.trusted-users = [ "root" "carlos" ];

  users.users.carlos = {
    name = "carlos";
    home = "/Users/carlos";
  };

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "blackhole-2ch"
      "cleanshot"
      "dash5"
      "deckset"
      "discord"
      "font-jetbrains-mono"
      "font-jetbrains-mono-nerd-font"
      "google-chrome"
      "hammerspoon"
      "imageoptim"
      "keybase"
      "ledger-live"
      "monodraw"
      "sensei"
      "signal"
      "slack"
      "soulver"
      "telegram"
      "whatsapp"
      "zoom"
    ];
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
        "com.apple.NetworkBrowser" = { "BrowseAllInterfaces" = true; };
        # "WebAutomaticTextReplacementEnabled" = true;
        "com.apple.screensaver" = {
          "askForPassword" = true;
          "askForPasswordDelay" = 0;
        };
        "com.apple.trackpad" = { "scaling" = 2; };
        "com.apple.mouse" = { "scaling" = 2.5; };
        "com.apple.desktopservices" = { "DSDontWriteNetworkStores" = false; };
        "com.apple.LaunchServices" = { "LSQuarantine" = true; };
        "com.apple.finder" = {
          "ShowExternalHardDrivesOnDesktop" = false;
          "ShowRemovableMediaOnDesktop" = false;
          "WarnOnEmptyTrash" = false;
        };
        "NSGlobalDomain" = {
          "NSNavPanelExpandedStateForSaveMode" = true;
          "NSTableViewDefaultSizeMode" = 1;
          "WebKitDeveloperExtras" = true;
        };
        "com.apple.ImageCapture" = { "disableHotPlug" = true; };
        # "com.apple.Safari" = {
        #   "IncludeInternalDebugMenu" = true;
        #   "IncludeDevelopMenu" = true;
        #   "WebKitDeveloperExtrasEnabledPreferenceKey" = true;
        #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" =
        #     true;
        # };
      };
    };
  };
}
