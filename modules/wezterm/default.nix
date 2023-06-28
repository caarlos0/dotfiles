{ pkgs, config, ... }: {
  xdg.configFile."wezterm/wezterm.lua" = {
    source = config.lib.file.mkOutOfStoreSymlink ./wezterm.lua;
  };
  home.activation.installWeztermTerminfo = ''
    ${pkgs.ncurses}/bin/tic -x -o $HOME/.terminfo ${
      pkgs.fetchurl {
        url =
          "https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo";
        sha256 = "P+mUyBjCvblCtqOmNZlc2bqUU32tMNWpYO9g25KAgNs=";
      }
    }
  '';
}
