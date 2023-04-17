{ ... }: {
  programs.gh = {
    enable = true;
    settings = {
      aliases = {
        clone = "repo clone";
        co = "pr checkout";
        open = "repo view --web";
        pr = "pr create";
      };
      editor = "nvim";
      git_protocol = "ssh";
    };
  };
}
