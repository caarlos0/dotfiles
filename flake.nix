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
    charmbracelet-nur.url = "github:charmbracelet/nur";
    goreleaser-nur.url = "github:goreleaser/nur";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    { nur
    , neovim-nightly
    , caarlos0-nur
    , charmbracelet-nur
    , goreleaser-nur
    , darwin
    , home-manager
    , nix-index-database
    , ...
    }@inputs:
    let
      overlays = [
        (final: prev: {
          nur = import nur {
            nurpkgs = prev;
            pkgs = prev;
            repoOverrides = {
              caarlos0 = import caarlos0-nur { pkgs = prev; };
              charmbracelet = import charmbracelet-nur { pkgs = prev; };
              goreleaser = import goreleaser-nur { pkgs = prev; };
            };
          };
        })
        (import neovim-nightly)
      ];
    in
    {
      darwinConfigurations."supernova" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./modules/darwin/configuration.nix ];
      };
      homeConfigurations = {
        "carlos@supernova" = home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ({ config, ... }: { config = { nixpkgs.overlays = overlays; }; })
            ./modules/darwin-app-activation.nix
            ./modules/home.nix
            ./modules/pkgs.nix
            ./modules/editorconfig.nix
            ./modules/yamllint.nix
            ./modules/go.nix
            ./modules/fzf.nix
            ./modules/wezterm/default.nix
            ./modules/tmux/default.nix
            ./modules/neovim/default.nix
            ./modules/gpg.nix
            ./modules/git.nix
            ./modules/gh/default.nix
            ./modules/top.nix
            ./modules/shell.nix
            ./modules/ssh/default.nix
            ./modules/bins/default.nix
            ./modules/charm.nix
            ./modules/hammerspoon/default.nix
            inputs.caarlos0-nur.homeManagerModules.default
            ./modules/darwin.nix
            # ./modules/yubikey.nix
            nix-index-database.hmModules.nix-index
          ];
        };

        "carlos@darkstar" = home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ({ config, ... }: { config = { nixpkgs.overlays = overlays; }; })
            ./modules/home.nix
            ./modules/pkgs.nix
            ./modules/editorconfig.nix
            ./modules/yamllint.nix
            ./modules/go.nix
            ./modules/fzf.nix
            ./modules/wezterm/default.nix
            ./modules/tmux/default.nix
            ./modules/neovim/default.nix
            ./modules/gpg.nix
            ./modules/git.nix
            ./modules/gh/default.nix
            ./modules/top.nix
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
