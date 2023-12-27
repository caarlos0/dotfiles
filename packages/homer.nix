{ stdenv, fetchzip, pkgs, ... }:
let
  formatYaml = pkgs.formats.yaml { };
  config = formatYaml.generate "config.yml" {
    title = "Media";
    header = true;
    services = [
      {
        name = "Watch";
        items = [
          {
            name = "Plex";
            url = "http://media.local:32400/web";
            endpoint = "http://media.local:8181";
            type = "Tautulli";
            apikey = "779ac777f02245fda8f23879e0b9eb37";
            target = "_blank";
          }
        ];
      }
      {
        name = "Statistics";
        items = [
          {
            name = "Tautulli";
            endpoint = "http://media.local:8181";
            url = "http://media.local:8181";
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
            name = "Series";
            type = "Sonarr";
            url = "http://media.local:8989/";
            apikey = "71c261a86baf491784a60fa7489620fc";
            target = "_blank";
          }
          {
            name = "Movies";
            type = "Radarr";
            url = "http://media.local:7878/";
            apikey = "0042dc1c54444388b0ed680187f11b37";
            target = "_blank";
          }
          {
            name = "Subtitles";
            url = "http://media.local:6767/";
            target = "_blank";
          }
          {
            name = "Torrents";
            url = "http://media.local:9091/";
            target = "_blank";
          }
          {
            name = "Prowlarr";
            url = "http://media.local:9696/";
            target = "_blank";
          }
          {
            name = "Indexer";
            url = "http://media.local:9117/";
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
