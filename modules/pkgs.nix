{ pkgs, lib, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  home.packages =
    with pkgs;
    with pkgs.nodePackages_latest;
    [
      # custom packages
      (pkgs.callPackage ../pkgs/bins { })

      age
      comma
      cosign
      curl
      entr
      fd
      gnumake
      go-task
      graphviz
      httpstat
      hyperfine
      jq
      moreutils
      ncdu
      netcat-gnu
      nmap
      nodejs
      onefetch
      p7zip
      ranger
      ripgrep
      scc
      sqlite
      tldr
      unixtools.watch
      unrar
      vegeta
      wget
      yarn

      # gke stuff
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
      ])
      kubectl
      kubectx
      stern
      argocd

      # From NUR
      nur.repos.caarlos0.glyphs
      nur.repos.caarlos0.gocovsh
      nur.repos.caarlos0.gopls # always latest
      nur.repos.caarlos0.golangci-lint # always latest
      nur.repos.caarlos0.jsonfmt
      nur.repos.caarlos0.svu
      nur.repos.goreleaser.goreleaser-pro

      # treesitter, lsps, formatters, etc
      bash-language-server
      clang-tools # clangd lsp
      delve
      dockerfile-language-server-nodejs
      gofumpt
      htmx-lsp
      nil # nix lsp
      nixfmt-rfc-style
      pgformatter
      prettier
      rustup
      shellcheck
      shfmt
      # sql-formatter
      stylua
      sumneko-lua-language-server
      tailwindcss-language-server
      taplo # toml lsp
      terraform-ls
      tflint
      tree-sitter
      typescript-language-server
      vscode-langservers-extracted
      yaml-language-server
      yamllint
      zig
      zls # zig lsp
    ]
    ++ (lib.optionals pkgs.stdenv.isDarwin [
      nur.repos.caarlos0.discord-applemusic-rich-presence
      terminal-notifier
      coreutils
      mosquitto
    ])
    ++ (lib.optionals pkgs.stdenv.isLinux [
      ffmpeg_6-full # failing on macos
      inetutils # macos already has its own utils
      lm_sensors
      # https://nixos.wiki/wiki/podman
      # podman
      # shadow
    ]);
}
