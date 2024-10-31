{ ... }: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    # --> Gruvbox
    # XXX: when changing this, run:
    #   set -e FZF_DEFAULT_OPTS
    #   set -e FZF_OPTS
    # Reasons unknown, but I think it's somehow related to babelfish.
    colors = {
      "bg" = "#1b1b1b";
      "bg+" = "#665c54";
      "border" = "#458588";
      "fg" = "#ebdbb2";
      "gutter" = "#1b1b1b";
      "header" = "#fabd2f";
      "hl" = "#83a598";
      "hl+" = "#83a598";
      "info" = "#928374";
      "marker" = "#fb4934";
      "pointer" = "#fb4934";
      "prompt" = "#83a598";
      "query" = "#ebdbb2:regular";
      "scrollbar" = "#458588";
      "separator" = "#fabd2f";
      "spinner" = "#fb4934";
    };
  };
}
