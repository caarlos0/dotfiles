{ config, pkgs, ... }: {
  programs.gh = {
    enable = true;
    settings = {
      # Workaround for https://github.com/nix-community/home-manager/issues/4744
      version = 1;
      aliases = {
        clone = "repo clone";
        co = "pr checkout";
        v = "repo view --web";
        pv = "pr view --web";
        pr = "pr create --web";
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
