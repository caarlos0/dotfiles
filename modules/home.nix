{ ... }: {
  home.username = "carlos";
  home.stateVersion = "23.11";

  home.enableNixpkgsReleaseCheck = false; # FIXME: remove this

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    PROJECTS = "$HOME/Developer";
  };
}
