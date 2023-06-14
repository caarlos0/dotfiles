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
  xdg.configFile."gh-dash/config.yml" = {
    source = config.lib.file.mkOutOfStoreSymlink ./gh-dash.yml;
  };
}
