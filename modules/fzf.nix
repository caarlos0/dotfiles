{ ... }: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    colors = {
      "bg+" = "#313244";
      "fg+" = "#cdd6f4";
      "hl+" = "#f38ba8";
      bg = "#1e1e2e";
      fg = "#cdd6f4";
      header = "#f38ba8";
      hl = "#f38ba8";
      info = "#cba6f7";
      marker = "#f5e0dc";
      pointer = "#f5e0dc";
      prompt = "#cba6f7";
      spinner = "#f5e0dc";
    };
  };
}
