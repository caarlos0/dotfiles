{
  description = "caarlos0's nixos, nix-darwin, and home-manager configs";
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
    }:
    let
      overlays = [
        # inputs.neovim-nightly.overlay
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
        media = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./machines/media
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
            ./machines/darkstar
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bkp";
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
                  ./modules/git
                  ./modules/gh
                  ./modules/top.nix
                  ./modules/shell.nix
                  ./modules/ssh
                  ./modules/charm.nix
                  nix-index-database.hmModules.nix-index
                ];
              };
            }
          ];
        };
      };
      darwinConfigurations = {
        darkmatter = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./machines/darkmatter
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = false;
              home-manager.users.carlos = {
                programs.neovim.package = neovim-nightly.packages.aarch64-darwin.default;
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
                  ./modules/git
                  ./modules/gh
                  ./modules/top.nix
                  ./modules/shell.nix
                  ./modules/ssh
                  ./modules/charm.nix
                  ./modules/hammerspoon
                  caarlos0-nur.homeManagerModules.default
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
        in
        {
          default = pkgs.mkShellNoCC {
            buildInputs = with pkgs; [
              (writeScriptBin "dot-clean" ''
                nix-collect-garbage -d --delete-older-than 30d
              '')
              (writeScriptBin "dot-release" ''
                git tag -m "$(date +%Y.%m.%d)" "$(date +%Y.%m.%d)"
                git push --tags
                goreleaser release --clean
              '')
              (writeScriptBin "dot-sync" ''
                git pull --rebase origin main
                nix flake update
                dot-clean
                dot-apply
              '')
              (writeScriptBin "dot-apply" ''
                if test $(uname -s) == "Linux"; then
                  sudo nixos-rebuild switch --flake .#
                fi
                if test $(uname -s) == "Darwin"; then
                  nix build "./#darwinConfigurations.$(hostname | cut -f1 -d'.').system"
                  ./result/sw/bin/darwin-rebuild switch --flake .
                fi
              '')
            ];
          };
        });
    };
}
