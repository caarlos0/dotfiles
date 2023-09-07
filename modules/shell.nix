{ ... }: {
  imports = [
    ./fish/default.nix
    ./starship.nix
    ./lsd.nix
    ./bat.nix
    ./zoxide.nix
    ./direnv.nix
  ];
}
