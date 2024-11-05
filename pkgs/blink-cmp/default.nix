{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, vimUtils
,
}:
let
  version = "2024-11-04";
  src = fetchFromGitHub {
    owner = "Saghen";
    repo = "blink.cmp";
    rev = "77f037cae07358368f3b7548ba39cffceb49349e";
    hash = "sha256-VGXaT0+DGy4+Ahb5AfSI5gZUDunvi6HupZhgJ5ElMyA=";
  };
  libExt = if stdenv.hostPlatform.isDarwin then "dylib" else "so";
  blink-fuzzy-lib = rustPlatform.buildRustPackage {
    inherit version src;
    pname = "blink-fuzzy-lib";
    env = {
      # TODO: remove this if plugin stops using nightly rust
      RUSTC_BOOTSTRAP = true;
    };
    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "frizbee-0.1.0" = "sha256-eYth+xOIqwGPkH39OxNCMA9zE+5CTNpsuX8Ue/mySIA=";
      };
    };
  };
in
vimUtils.buildVimPlugin {
  pname = "blink-cmp";
  inherit version src;
  preInstall = ''
    mkdir -p target/release
    ln -s ${blink-fuzzy-lib}/lib/libblink_cmp_fuzzy.${libExt} target/release/libblink_cmp_fuzzy.${libExt}
  '';
  meta = {
    description = "Performant, batteries-included completion plugin for Neovim";
    homepage = "https://github.com/saghen/blink.cmp";
    maintainers = with lib.maintainers; [
      balssh
      redxtech
    ];
  };
  doInstallCheck = true;
  nvimRequireCheck = "blink-cmp";
}
