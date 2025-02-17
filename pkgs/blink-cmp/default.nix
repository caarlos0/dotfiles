{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  vimUtils,
  nix-update-script,
  git,
  replaceVars,
}:
let
  version = "0.12.4";
  src = fetchFromGitHub {
    owner = "Saghen";
    repo = "blink.cmp";
    tag = "v${version}";
    hash = "";
  };
  blink-fuzzy-lib = rustPlatform.buildRustPackage {
    inherit version src;
    pname = "blink-fuzzy-lib";

    useFetchCargoVendor = true;
    cargoHash = "";

    nativeBuildInputs = [ git ];

    env = {
      # TODO: remove this if plugin stops using nightly rust
      RUSTC_BOOTSTRAP = true;
    };
  };
in
vimUtils.buildVimPlugin {
  pname = "blink.cmp";
  inherit version src;
  preInstall =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      mkdir -p target/release
      ln -s ${blink-fuzzy-lib}/lib/libblink_cmp_fuzzy${ext} target/release/libblink_cmp_fuzzy${ext}
    '';

  patches = [
    (replaceVars ./force-version.patch { inherit (src) tag; })
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.blink-cmp.blink-fuzzy-lib";
    };

    # needed for the update script
    inherit blink-fuzzy-lib;
  };

  meta = {
    description = "Performant, batteries-included completion plugin for Neovim";
    homepage = "https://github.com/saghen/blink.cmp";
    changelog = "https://github.com/Saghen/blink.cmp/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      balssh
      redxtech
    ];
  };

  nvimSkipModule = [
    # Module for reproducing issues
    "repro"
  ];
}
