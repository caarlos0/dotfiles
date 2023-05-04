{ config, pkgs, ... }: {
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
  home.packages = [ pkgs.gh-dash ];

  xdg.configFile."gh-dash/gh-dash.yml" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config.yml;
  };
}
