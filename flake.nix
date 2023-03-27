{
  description = "Home Manager configuration of Carlos Becker";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mkAlias = {
      url = "github:cdmistman/mkAlias";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."carlos@supernova" =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs system; };
          modules = [
            ./modules/darwin-app-activation.nix
            ./modules/darwin.nix
            ./modules/home.nix
            ./modules/wezterm/default.nix
            ./modules/tmux/default.nix
            ./modules/dev/default.nix
            ./modules/gpg.nix
            ./modules/git.nix
            ./modules/shell.nix
            ./modules/ssh.nix
            ./modules/bins/default.nix
            ./modules/charm.nix
            # ./modules/yubikey.nix
          ];
        };
    };
}
