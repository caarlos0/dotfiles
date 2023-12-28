{ pkgs, stdenv, writeText, ... }:
let
  script = writeText "upload-to-cache.sh" ''
    #!/bin/sh
    if [ "$(${pkgs.busybox}/bin/hostname)" = "cachixe" ]; then
      exit 0
    fi
    set -eu
    set -f # disable globbing
    export IFS=' '
    echo "uploading paths" $OUT_PATHS
    exec nix copy --to "ssh://carlos@cachixe.local" $OUT_PATHS
  '';
in
stdenv.mkDerivation {
  name = "upload-to-cache";
  version = "unstable";
  dontUnpack = true;

  buildInputs = with pkgs; [ busybox ];

  installPhase = ''
    mkdir -vp $out/bin
    cp ${script} $out/bin/upload-to-cachixe
    chmod +x $out/bin/upload-to-cachixe
  '';
}
