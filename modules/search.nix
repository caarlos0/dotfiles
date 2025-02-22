{ ... }:
{
  programs.fd = {
    enable = true;
    ignores = [ ".git/" ];
    hidden = true;
  };

  programs.ripgrep = {
    enable = true;
  };

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
      "bg+" = "#3c3836";
      "fg" = "#ebdbb2";
      "fg+" = "#ebdbb2";
      "header" = "#fb4934";
      "hl" = "#fb4934";
      "hl+" = "#fb4934";
      "info" = "#d3869b";
      "marker" = "#83a598";
      "pointer" = "#ebdbb2";
      "prompt" = "#d3869b";
      "selected-bg" = "#665c54";
      "spinner" = "#ebdbb2";
    };
  };
}
