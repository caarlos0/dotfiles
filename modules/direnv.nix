{ pkgs, ... }:
let
  homeDirectory = (if pkgs.stdenv.isDarwin then "/Users/" else "/home/") + "carlos";
in
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      global = {
        load_dotenv = true;
      };
      whitelist = {
        prefix = [
          "${homeDirectory}/Developer/caarlos0/"
          "${homeDirectory}/Developer/charmbracelet/"
          "${homeDirectory}/Developer/goreleaser/"
        ];
      };
    };
  };
}
