{ stdenv, writeText, ... }:
let
  script = writeText "upload-to-cache.sh" ''
    #!/bin/sh
    set -eu
    set -f # disable globbing
    export IFS=' '
    echo "Uploading paths" $OUT_PATHS
    exec nix copy --to "ssh://carlos@cachixe.local" $OUT_PATHS
  '';
in
stdenv.mkDerivation {
  name = "upload-to-cache";
  version = "unstable";
  dontUnpack = true;

  installPhase = ''
    mkdir -vp $out/bin
    cp ${script} $out/bin/upload-to-cachixe
    chmod +x $out/bin/upload-to-cachixe
  '';
}
