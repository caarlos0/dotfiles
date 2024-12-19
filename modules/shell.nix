{ ... }:
{
  imports = [
    ./fish
    ./starship.nix
    ./lsd.nix
    ./bat.nix
    ./direnv.nix
  ];

  programs.zoxide.enable = true;
  programs.ranger = {
    enable = true;
    settings = {
      unicode_ellipsis = true;
    };
  };
}
