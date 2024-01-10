{ ... }: {
  imports = [
    ./fish
    ./starship.nix
    ./lsd.nix
    ./bat.nix
    ./direnv.nix
  ];

  programs.zoxide.enable = true;
}
