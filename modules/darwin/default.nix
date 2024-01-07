{ ... }: {
  home.homeDirectory = "/Users/carlos";

  # targets.darwin.defaults = {
  #   "com.apple.Safari.SandboxBroker".ShowDevelop = true;
  #   "com.apple.Safari".AutoFillPasswords = false;
  #   "com.apple.Safari".IncludeDevelopMenu = true;
  #   "com.apple.Safari".ShowOverlayStatusBar = true;
  #   "com.apple.Safari".AutoOpenSafeDownloads = false;
  #   "com.apple.Safari".AutoFillCreditCardData = false;
  # };

  services = {
    discord-applemusic-rich-presence.enable = true;
    xdg-open-svc.enable = true;
  };

  programs.fish.shellInit = ''
    fish_add_path -a ~/Applications/Ghostty.app/Contents/MacOS/
    fish_add_path -a /Applications/Postgres.app/Contents/Versions/latest/bin/
    fish_add_path -a /opt/homebrew/bin/
  '';
}
