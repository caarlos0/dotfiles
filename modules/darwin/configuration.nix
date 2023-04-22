{ pkgs, ... }: {
  services = { nix-daemon = { enable = true; }; };
  nix.package = pkgs.nix;

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "airflow"
      "blackhole-2ch"
      "cleanshot"
      "dash5"
      "deckset"
      "discord"
      "google-chrome"
      "hammerspoon"
      "iina"
      "imageoptim"
      "keybase"
      "ledger-live"
      "monodraw"
      "notion"
      "rar"
      "sensei"
      "signal"
      "slack"
      "soulver"
      "subtitles"
      "telegram"
      "wezterm"
      "whatsapp-beta"
      "yubico-yubikey-manager"
      "zoom"
    ];
  };

  system = {
    defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        orientation = "left";
        tilesize = 42;
        showhidden = true;
        show-recents = true;
        show-process-indicators = true;
        expose-animation-duration = 0.1;
        expose-group-by-app = true;
        launchanim = false;
        mineffect = "scale";
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
      };
      finder = {
        FXPreferredViewStyle = "Nlsv";
        # ShowExternalHardDrivesOnDesktop = false;
        # ShowRemovableMediaOnDesktop = false;
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
        AppleShowAllFiles = true;
        ShowStatusBar = true;
        ShowPathbar = true;
      };
    };
  };

}
