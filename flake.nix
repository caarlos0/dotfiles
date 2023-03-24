{
  description = "Home Manager configuration of Carlos Becker";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	# neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "aarc64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
	  # overlays = [
   #        inputs.neovim-nightly-overlay.overlay
   #      ];
    in {
      homeConfigurations.carlos = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

		# configuration = { pkgs, ... }:
  #           {
  #             nixpkgs.overlays = overlays;
  #           };

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
		./home.nix
		];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
