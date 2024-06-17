{ ... }: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    # --> Tokyo Night
    colors = {
      "bg" = "#16161e";
      "bg+" = "#283457";
      "border" = "#27a1b9";
      "fg" = "#c0caf5";
      "gutter" = "#16161e";
      "header" = "#ff9e64";
      "hl" = "#2ac3de";
      "hl+" = "#2ac3de";
      "info" = "#545c7e";
      "marker" = "#ff007c";
      "pointer" = "#ff007c";
      "prompt" = "#2ac3de";
      "query" = "#c0caf5:regular";
      "scrollbar" = "#27a1b9";
      "separator" = "#ff9e64";
      "spinner" = "#ff007c";
    };
  };
}
