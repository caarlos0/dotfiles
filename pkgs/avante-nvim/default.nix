{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, vimUtils
, darwin
,
}:

let
  version = "2024-09-08";

  src = fetchFromGitHub {
    owner = "yetone";
    repo = "avante.nvim";
    rev = "7532e590d28c6fffe88aa17ba6689c4ec8fec8ba";
    hash = "sha256-qfpTNoojSnBLCVqdBEsSnGwDgh3Br/iRKKHlZw4UeyY=";
  };

  meta = with lib; {
    description = "Neovim plugin designed to emulate the behaviour of the Cursor AI IDE";
    homepage = "https://github.com/yetone/avante.nvim";
    license = licenses.asl20;
    maintainers = [ ];
  };

  avante-nvim-lib = rustPlatform.buildRustPackage {
    pname = "avante-nvim-lib";
    inherit version src meta;
    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "mlua-0.10.0-beta.1" = "sha256-ZEZFATVldwj0pmlmi0s5VT0eABA15qKhgjmganrhGBY=";
      };
    };

    nativeBuildInputs = [
      pkg-config
      openssl
    ];

    buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

    buildPhase = ''
      export PKG_CONFIG_PATH=${openssl.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
      make BUILD_FROM_SOURCE=true
    '';

    installPhase = ''
      mkdir -p $out
      cp ./build/*.{dylib,so} $out/
    '';

    doCheck = false;
  };
in

vimUtils.buildVimPlugin {
  pname = "avante.nvim";
  inherit version src meta;

  # The plugin expects the dynamic libraries to be under build/
  postInstall = ''
    mkdir -p $out/build
    ln -s ${avante-nvim-lib}/*.{dylib,so} $out/build
  '';
}
