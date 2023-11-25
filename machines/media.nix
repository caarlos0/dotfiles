# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
let
  homepage-dashboard-config = pkgs.writeTextToFile {
    name = "bookmarks.yaml";
    executable = false;
    destination = "/var/lib/private/homepage-dashboard/bookmarks.yaml";
    text = ''
      ---
      # For configuration options and examples, please see:
      # https://gethomepage.dev/en/configs/bookmarks

      - Developer:
          - Github:
              - abbr: GH
                href: https://github.com/

      - Social:
          - Twitter:
              - abbr: X
                href: https://twitter.com/

      - Entertainment:
          - YouTube:
              - abbr: YT
                href: https://youtube.com/
    '';
  };
in
{
  imports =
    [
      ./shared.nix
      ./hardware/media.nix
    ];

  networking.hostName = "media";

  users.users.carlos.packages = with pkgs; [
    unrar
    go-task
  ];

  # services.caddy = {
  #   enable = true;
  #   virtualHosts."jellyfin.local".extraConfig = ''
  #     reverse_proxy http://media.local:8096
  #   '';
  # };
  #

  services.homepage-dashboard = {
    enable = true;
    listenPort = 80;
    openFirewall = true;
  };

  environment.etc = {
    "private/homepage-dashboard/services.yaml".text = ''
      - Jellyfin:
        href: https://media.local:8086
        description: Watch movies and TV shows.
        server: localhost
        container: jellyfin
        widget:
          type: jellyfin
          url: http://media.local:8086
          key: f972a063155049baa6080533886ccdd8
    '';
  };

  services.jellyfin = {
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

