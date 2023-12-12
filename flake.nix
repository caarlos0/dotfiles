{
  description = "caarlos0's nix-darwin and home-manager configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    caarlos0-nur.url = "github:caarlos0/nur";
    charmbracelet-nur.url = "github:charmbracelet/nur";
    goreleaser-nur.url = "github:goreleaser/nur";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    , nixpkgs
    , ...
    }@inputs:
    let
      overlays = [
        inputs.neovim-nightly.overlay
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
      ];

      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix;

      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = overlays;
      });
    in
    {
      nixosConfigurations = {
        cachixe = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./machines/cachixe.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.carlos = {
                imports = [
                  ./modules/home.nix
                  ./modules/nixos.nix
                  ./modules/shell.nix
                ];
              };
            }
          ];
        };
        media = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./machines/media.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.carlos = {
                imports = [
                  ./modules/home.nix
                  ./modules/nixos.nix
                  ./modules/shell.nix
                ];
              };
            }
          ];
        };
        darkstar = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./machines/darkstar.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.carlos = {
                imports = [
                  ./modules/home.nix
                  ./modules/nixos.nix
                  ./modules/pkgs.nix
                  ./modules/editorconfig.nix
                  ./modules/yamllint.nix
                  ./modules/go.nix
                  ./modules/fzf.nix
                  ./modules/tmux
                  ./modules/neovim
                  ./modules/gpg.nix
                  ./modules/git.nix
                  ./modules/gh
                  ./modules/top.nix
                  ./modules/shell.nix
                  ./modules/ssh
                  ./modules/bins
                  ./modules/charm.nix
                  nix-index-database.hmModules.nix-index
                ];
              };
            }
          ];
        };
      };
      darwinConfigurations = {
        supernova = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./machines/supernova.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = false;
              home-manager.users.carlos = {
                imports = [
                  ./modules/home.nix
                  ./modules/darwin
                  ./modules/pkgs.nix
                  ./modules/editorconfig.nix
                  ./modules/yamllint.nix
                  ./modules/go.nix
                  ./modules/fzf.nix
                  ./modules/ghostty
                  ./modules/tmux
                  ./modules/neovim
                  ./modules/gpg.nix
                  ./modules/git.nix
                  ./modules/gh
                  ./modules/top.nix
                  ./modules/shell.nix
                  ./modules/ssh
                  ./modules/bins
                  ./modules/charm.nix
                  ./modules/hammerspoon
                  inputs.caarlos0-nur.homeManagerModules.default
                  # ./modules/yubikey.nix
                  nix-index-database.hmModules.nix-index
                ];
              };
            }
          ];
        };
      };

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          goreleaser = (import goreleaser-nur {
            pkgs = pkgs;
          });
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              go-task
              goreleaser.goreleaser-pro
              neofetch
              glow
            ];
          };
        });
    };
}
