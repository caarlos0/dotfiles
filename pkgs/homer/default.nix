{ stdenv, fetchzip, pkgs, ... }:
let
  formatYaml = pkgs.formats.yaml { };
  config = formatYaml.generate "config.yml" {
    title = "Media";
    header = true;
    # https://github.com/bastienwirtz/homer/blob/main/docs/customservices.md
    services = [
      {
        name = "Watch";
        items = [
          {
            name = "Plex";
            subtitle = "Media Server";
            url = "http://media.local:32400/web";
            endpoint = "http://media.local/tautulli";
            logo = "https://raw.githubusercontent.com/NX211/homer-icons/master/png/plex.png";
            type = "Tautulli";
            apikey = "779ac777f02245fda8f23879e0b9eb37";
            target = "_blank";
          }
          {
            name = "Overseerr";
            subtitle = "Request Media";
            logo = "https://raw.githubusercontent.com/NX211/homer-icons/master/png/overseerr.png";
            url = "http://media.local:5055";
            target = "_blank";
          }
          {
            name = "Tautulli";
            subtitle = "Plex Statistics";
            url = "http://media.local:8181";
            logo = "https://raw.githubusercontent.com/NX211/homer-icons/master/png/tautulli.png";
            endpoint = "http://media.local/tautulli";
            type = "Tautulli";
            apikey = "779ac777f02245fda8f23879e0b9eb37";
            target = "_blank";
          }
        ];
      }
      {
        name = "Download";
        items = [
          {
            name = "qBittorrent";
            subtitle = "Downloads";
            logo = "https://raw.githubusercontent.com/NX211/homer-icons/master/png/qbittorrent.png";
            url = "http://media.local:8091/";
            endpoint = "http://media.local:8090";
            target = "_blank";
            type = "qBittorrent";
          }
          {
            name = "Sonarr";
            subtitle = "Series";
            logo = "https://raw.githubusercontent.com/NX211/homer-icons/master/png/sonarr.png";
            type = "Sonarr";
            url = "http://media.local:8989/";
            apikey = "71c261a86baf491784a60fa7489620fc";
            target = "_blank";
          }
          {
            name = "Radarr";
            subtitle = "Movies";
            logo = "https://raw.githubusercontent.com/NX211/homer-icons/master/png/radarr.png";
            type = "Radarr";
            url = "http://media.local:7878/";
            apikey = "0042dc1c54444388b0ed680187f11b37";
            target = "_blank";
          }
          {
            name = "Bazarr";
            subtitle = "Subtitles";
            logo = "https://raw.githubusercontent.com/NX211/homer-icons/master/png/bazarr.png";
            url = "http://media.local:6767/";
            target = "_blank";
          }
          {
            name = "Prowlarr";
            subtitle = "Indexers";
            logo = "https://raw.githubusercontent.com/NX211/homer-icons/master/png/prowlarr.png";
            url = "http://media.local:9696/";
            type = "Prowlarr";
            apikey = "171a6baff00a4b918e722a7de9befaa1";
            target = "_blank";
          }
        ];
      }
    ];
  };
in
stdenv.mkDerivation rec {
  name = "homer";
  version = "23.10.1";
  src = fetchzip {
    url = "https://github.com/bastienwirtz/homer/releases/download/v${version}/homer.zip";
    hash = "sha256-KUEqrjO9LAoigZsQGLy5JrtsXx+HDXaz4Y4Vpba0uNw=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -vp $out
    cp -r . $out
    cp -r ${config} $out/assets/config.yml
  '';
}
