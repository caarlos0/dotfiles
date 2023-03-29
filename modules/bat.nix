{ ... }: {
  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
      italic-text = "always";
    };
  };

  home.sessionVariables = { MANPAGER = "sh -c 'col -bx | bat -l man -p'"; };
}
