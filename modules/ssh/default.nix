{ config, lib, pkgs, ... }: {
  programs.ssh = {
    enable = true;
    includes = [ "~/.ssh/config.local" ];
    serverAliveInterval = 60;
    matchBlocks = {
      "*" = {
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = lib.mkMerge [
          { }
          (if pkgs.stdenv.isDarwin then { UseKeyChain = "yes"; } else { })
        ];
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
            bind.port = 2224;
            host.address = "127.0.0.1";
            host.port = 2224;
          }
          {
            bind.port = 2225;
            host.address = "127.0.0.1";
            host.port = 2225;
          }
        ];
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

  home.file.".ssh/rc".source = config.lib.file.mkOutOfStoreSymlink ./rc;
}
