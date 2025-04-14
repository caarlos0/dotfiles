{ pkgs, ... }:
{
  programs.fish.interactiveShellInit = ''
    fish_add_path -p ~/Developer/Go/bin
  '';
  programs.go = {
    enable = true;
    package = pkgs.go_1_24;
    goPath = "Developer/Go";
  };
}
