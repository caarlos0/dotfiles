{ pkgs, ... }: {
  home.packages = with pkgs; [ pinentry_mac ];

  home.file."Library/LaunchAgents/pbcopy.plist" = {
    text = builtins.readFile ./darwin/pbcopy.plist;
  };
  home.file."Library/LaunchAgents/pbpaste.plist" = {
    text = builtins.readFile ./darwin/pbpaste.plist;
  };
}
