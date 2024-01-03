# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
let
  overseerr = (pkgs.callPackage ../../packages/overseerr.nix { });
in
{
  imports =
    [
      ../shared.nix
      ./hardware.nix
    ];

  networking.hostName = "media";
  services.qemuGuest.enable = true;

  services.nginx = {
    enable = true;
    virtualHosts."media.local" = {
      root = (pkgs.callPackage ../../packages/homer.nix { });
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 5055 ];

  services.plex = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "carlos";
  };
  services.tautulli = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "carlos";
  };
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "carlos";
  };
  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "carlos";
  };
  services.bazarr = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "carlos";
  };
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
  services.transmission = {
    enable = true;
    openFirewall = true;
    openRPCPort = true;
    group = "wheel";
    user = "carlos";
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,192.168.1.*";
      rpc-host-whitelist = "media.local";
      rpc-host-whitelist-enabled = true;
      download-dir = "/home/carlos/media";
      incomplete-dir = "/home/carlos/media";
    };
  };

  environment.systemPackages = with pkgs; [
    unpackerr
  ];

  systemd.services.unpackerr = {
    description = "Unpackerr";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = "carlos";
      Group = "wheel";
      ExecStart =
        let
          config = pkgs.writeText "unpackerr.conf"
            ''
              [[sonarr]]
              url = "http://localhost:8989"
              api_key = "71c261a86baf491784a60fa7489620fc"
              delete_orig = true

              [[radarr]]
              url = "http://localhost:7878"
              api_key = "0042dc1c54444388b0ed680187f11b37"
              delete_orig = true
            '';
        in
        "${pkgs.unpackerr}/bin/unpackerr -c ${config}";
      Restart = "on-failure";
    };
  };

  systemd.services.overseerr = {
    description = "Request management and media discovery tool for the Plex ecosystem";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment.PORT = 5055;
    serviceConfig = {
      Type = "exec";
      StateDirectory = "overseerr";
      WorkingDirectory = "${overseerr}/libexec/overseerr/deps/overseerr";
      DynamicUser = true;
      ExecStart = "${overseerr}/bin/overseerr";
      BindPaths = [ "/var/lib/overseerr/:${overseerr}/libexec/overseerr/deps/overseerr/config/" ];
      Restart = "on-failure";
      ProtectHome = true;
      ProtectSystem = "strict";
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      NoNewPrivileges = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RemoveIPC = true;
      PrivateMounts = true;
    };
  };



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

