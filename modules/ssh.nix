{ ... }: {
  programs.ssh = {
    enable = true;
    includes = [ "~/.ssh/config.local" ];
    serverAliveInterval = 60;
    # identityFile = "~/.ssh/id_ed25519";
    # extraOptions = { UseKeyChain = "true"; }; TODO: darwin
    matchBlocks = {
      "localhost" = {
        extraOptions = {
          UserKnownHostsFile = "/dev/null";
          StrictHostKeyChecking = "false";
        };
      };
      "dev" = {
        forwardAgent = true;
        extraOptions = {
          RequestTTY = "true";
          RemoteCommand = "~/.bin/tmux-new"; # TODO: change
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
}
