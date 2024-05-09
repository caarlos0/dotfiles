{ config, ... }: {
  programs.ssh = {
    enable = true;
    includes = [ "~/.ssh/config.local" ];
    serverAliveInterval = 60;
    matchBlocks = {
      "*" = {
        identityFile = "~/.ssh/id_ed25519";
        setEnv = {
          TERM = "xterm-256color";
        };

        sendEnv = [
          "COLORTERM"
        ];

        extraOptions = {
          IgnoreUnknown = "UseKeychain";
          UseKeyChain = "yes";
        };
      };
      "localhost" = {
        extraOptions = {
          UserKnownHostsFile = "/dev/null";
          StrictHostKeyChecking = "false";
        };
      };
      "dev" = {
        forwardAgent = true;
        remoteForwards = [
          {
            # pbcopy
            bind.port = 2224;
            host.address = "127.0.0.1";
            host.port = 2224;
          }
          {
            # pbpaste
            bind.port = 2225;
            host.address = "127.0.0.1";
            host.port = 2225;
          }
          {
            # xdg-open-svc
            bind.port = 2226;
            host.address = "127.0.0.1";
            host.port = 2226;
          }
        ];
        extraOptions = {
          RequestTTY = "true";
          RemoteCommand = "tmux new -A -s default";
        };
      };
      "aur.archlinux.org" = { identityFile = "~/.ssh/aur"; };
      "github.com" = {
        serverAliveInterval = 0;
        extraOptions = {
          ControlMaster = "auto";
          ControlPath = "~/.ssh/github.sock";
          ControlPersist = "5m";
        };
      };
    };
  };

  home.file.".ssh/rc".source = config.lib.file.mkOutOfStoreSymlink ./rc;
}
