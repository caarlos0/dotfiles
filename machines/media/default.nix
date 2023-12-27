# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
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
      root = (pkgs.callPackage ../packages/homer.nix { });
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

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
    group = "wheel";
    user = "carlos";
  };
  services.jackett = {
    enable = true;
    openFirewall = true;
    group = "wheel";
    user = "carlos";
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
              api_key = "71c261a86baf491784a60fa7489620fc"

              [[radarr]]
              api_key = "0042dc1c54444388b0ed680187f11b37"
            '';
        in
        "${pkgs.unpackerr}/bin/unpackerr -c ${config}";
      Restart = "on-failure";
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

