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

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
    caarlos0-nur.url = "github:caarlos0/nur";
  };

  outputs = { nur, caarlos0-nur, home-manager, nix-index-database, ... }@inputs:
    let
      overlays = final: prev: {
        nur = import nur {
          nurpkgs = prev;
          pkgs = prev;
          repoOverrides = { caarlos0 = import caarlos0-nur { pkgs = prev; }; };
        };
        # ... your other overlays
      };
    in {
      homeConfigurations = {
        "carlos@supernova" = home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ({ config, ... }: {
              config = { nixpkgs.overlays = [ overlays ]; };
            })
            ./modules/darwin-app-activation.nix
            ./modules/darwin.nix
            ./modules/home.nix
            ./modules/wezterm/default.nix
            ./modules/tmux/default.nix
            ./modules/dev/default.nix
            ./modules/gpg.nix
            ./modules/git.nix
            ./modules/shell.nix
            ./modules/ssh/default.nix
            ./modules/bins/default.nix
            ./modules/charm.nix
            # ./modules/yubikey.nix
            nix-index-database.hmModules.nix-index
          ];
        };

        "carlos@darkstar" = home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ({ config, ... }: {
              config = { nixpkgs.overlays = [ overlays ]; };
            })
            ./modules/home.nix
            ./modules/wezterm/default.nix
            ./modules/tmux/default.nix
            ./modules/dev/default.nix
            ./modules/gpg.nix
            ./modules/git.nix
            ./modules/shell.nix
            ./modules/ssh/default.nix
            ./modules/bins/default.nix
            ./modules/charm.nix
            nix-index-database.hmModules.nix-index
          ];
        };
      };
    };
}
