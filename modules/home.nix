{ ... }: {
  home.username = "carlos";
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.nix-index.enable = true;

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    PROJECTS = "$HOME/Developer";
  };

  # ensures ~/Developer folder exists.
  # this folder is later assumed by other activations, specially on darwin.
  home.activation.developer = ''
    mkdir -p ~/Developer
  '';
}
