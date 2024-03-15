{ ... }: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    # --> Catppuccin (Mocha)
    colors = {
      "bg+" = "#26233a";
      "fg+" = "#e0def4";
      "hl+" = "#ebbcba";
      bg = "#191724";
      border = "#403d52";
      fg = "#908caa";
      gutter = "#191724";
      header = "#31748f";
      hl = "#ebbcba";
      info = "#9ccfd8";
      marker = "#eb6f92";
      pointer = "#c4a7e7";
      prompt = "#908caa";
      separator = "#403d52";
      spinner = "#f6c177";
    };
  };
}
