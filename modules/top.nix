{ pkgs, config, ... }: {
  xdg.configFile."btop/themes/catppuccin_mocha.theme" = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/btop/main/themes/catppuccin_mocha.theme";
      sha256 = "TeaxAadm04h4c55aXYUdzHtFc7pb12e0wQmCjSymuug=";
    };
  };
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = false;
    };
  };
  programs.htop = {
    enable = true;
    settings = {
      color_scheme = 6;
      cpu_count_from_one = 0;
      delay = 15;
      fields = with config.lib.htop.fields; [
        PID
        USER
        PRIORITY
        NICE
        M_SIZE
        M_RESIDENT
        M_SHARE
        STATE
        PERCENT_CPU
        PERCENT_MEM
        TIME
        COMM
      ];
      highlight_base_name = 1;
      highlight_megabytes = 1;
      highlight_threads = 1;
    } // (with config.lib.htop;
      leftMeters [ (bar "AllCPUs2") (bar "Memory") (bar "Swap") ])
    // (with config.lib.htop;
      rightMeters [
        (text "Tasks")
        (text "LoadAverage")
        (text "Uptime")
        (text "Systemd")
      ]);
  };
}
