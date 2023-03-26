{
  description = "Home Manager configuration of Carlos Becker";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."carlos@supernova" =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./modules/home.nix
            ./modules/tmux/default.nix
            ./modules/dev.nix
            ./modules/git.nix
            ./modules/shell.nix
            ./modules/ssh.nix
            ./modules/bins.nix
            ./modules/darwin.nix
          ];
        };
    };
}
