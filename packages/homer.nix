{ writeText, stdenv, fetchzip, pkgs, ... }:
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
            name = "Series";
            url = "http://media.local:8096/";
            type = "Emby";
            apikey = "f972a063155049baa6080533886ccdd8";
            libraryType = "series";
          }
          {
            name = "Movies";
            url = "http://media.local:8096/";
            type = "Emby";
            apikey = "f972a063155049baa6080533886ccdd8";
            libraryType = "movies";
          }
        ];
      }
      {
        name = "Download";
        items = [
          {
            name = "Series";
            type = "Radarr";
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
            name = "Indexer";
            url = "http://media.local:9117/";
            target = "_blank";
          }
        ];
      }
    ];
  };
in
stdenv.mkDerivation
rec {
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
