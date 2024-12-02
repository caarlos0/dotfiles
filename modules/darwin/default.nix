{ ... }:
{
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

  # exclude GOPATH from time machine backups
  # exclude 'dist' and 'node_modules' folders as well
  home.activation.time-machine-exclusions = ''
    /usr/bin/tmutil addexclusion /Users/carlos/Developer/Go/
    /usr/bin/tmutil addexclusion /Users/carlos/.cargo/
    /usr/bin/tmutil addexclusion /Users/carlos/.rustup/
    find /Users/carlos/Developer -maxdepth 3 \( -name 'dist' -or -name 'node_modules' -or -name 'target' \) -not -path "*/Go/*" -not -path "*/.git/*" | while read -r p; do
      echo "TimeMachine: excluding $p..."
      /usr/bin/tmutil addexclusion "$p"
    done
  '';

  # never index the developer folder in spotlight.
  home.file."Developer/.metadata_never_index".text = "";

  launchd.agents = {
    pbcopy = {
      enable = true;
      config = {
        Label = "localhost.pbcopy";
        ProgramArguments = [ "/usr/bin/pbcopy" ];
        RunAtLoad = true;
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
        ProcessType = "Background";
        EnvironmentVariables = {
          "LC_CTYPE" = "UTF-8";
        };
        inetdCompatibility = {
          Wait = false;
        };
        Sockets = {
          Listener = {
            SockServiceName = "2224";
            SockNodeName = "127.0.0.1";
          };
        };
      };
    };
    pbpaste = {
      enable = true;
      config = {
        Label = "localhost.pbpaste";
        ProgramArguments = [ "/usr/bin/pbpaste" ];
        RunAtLoad = true;
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
        ProcessType = "Background";
        inetdCompatibility = {
          Wait = false;
        };
        EnvironmentVariables = {
          "LC_CTYPE" = "UTF-8";
        };
        Sockets = {
          Listener = {
            SockServiceName = "2225";
            SockNodeName = "127.0.0.1";
          };
        };
      };
    };
  };
}
