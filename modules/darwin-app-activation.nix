# courtesy of https://github.com/kamalmarhubi/dotfiles-nix/blob/f8f5ad4f899b07beb881e4391bd60425f6ae2de0/darwin.nix
{ config, lib, pkgs, ... }: {
  disabledModules = [ "targets/darwin/linkapps.nix" ];
  # Add a custom mkalias based thing cribbed from:
  #   https://github.com/nix-community/home-manager/issues/1341#issuecomment-1446696577
  # but using mkalias as in
  #   https://github.com/reckenrode/nixos-configs/commit/26cf5746b7847ec983f460891e500ca67aaef932?diff=unified
  # instead; latter found via
  # via
  #   https://github.com/nix-community/home-manager/issues/1341#issuecomment-1452420124
  home.activation.aliasApplications = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
    (let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      app_path="$HOME/Applications/Home Manager Apps"
      echo "Linking Home Manager applications..." 2>&1
      ${pkgs.fd}/bin/fd \
          -t l -d 1 . ${apps}/Applications \
          -x $DRY_RUN_CMD cp -f {} "app_path/{/}"
    '');
}
