{ pkgs, config, ... }: {
  xdg.configFile."wezterm/wezterm.lua" = {
    source = config.lib.file.mkOutOfStoreSymlink ./wezterm.lua;
  };
  home.packages = [
    (pkgs.stdenv.mkDerivation {
      name = "wezterm-terminfo";
      version = "unstable";
      src = ./data;
      outputs = [ "out" "terminfo" ];
      installPhase = ''
        mkdir -p $terminfo/share/terminfo $out/nix-support
        ${pkgs.ncurses}/bin/tic -x -o $terminfo/share/terminfo wezterm.terminfo
        echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
      '';
    })
  ];
}
