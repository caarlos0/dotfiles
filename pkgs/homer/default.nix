# with import <nixpkgs> { };
{ fetchFromGitHub
, fetchYarnDeps
, mkYarnPackage
, pkgs
, ...
}:
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
            apikey = "e8b5cf4086f0418393d976ef26f40570";
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
            apikey = "e8b5cf4086f0418393d976ef26f40570";
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
            username = "admin";
            password = "adminadmin";
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
            name = "Readarr";
            subtitle = "Books";
            logo = "https://raw.githubusercontent.com/NX211/homer-icons/master/png/readarr.png";
            type = "Readarr";
            url = "http://media.local:8787/";
            apikey = "TODO";
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
mkYarnPackage rec {
  name = "homer";
  version = "fork";
  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "homer";
    rev = "main";
    hash = "sha256-xNziRpNVCM13IckyETbD4LQ4YWWlvXUz4OLooayFmVI=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-6OAK9zTF/Yev4f/yg3GZfkFMflBzspt3vDnVpo71DPw=";
  };

  distPhase = "true";

  buildPhase = ''
    export HOME=$(mktemp -d)
    yarn --offline build
  '';

  fixupPhase = ''
    cp -rf $out/libexec/homer/deps/homer/dist/* $out
    rm -rf $out/bin $out/libexec
    cp -r ${config} $out/assets/config.yml
  '';
}
