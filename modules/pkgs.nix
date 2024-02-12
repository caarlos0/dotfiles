{ pkgs, lib, ... }: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  home.packages = with pkgs; with pkgs.nodePackages_latest; [
    # custom packages
    (pkgs.callPackage ../pkgs/bins { })

    age
    comma
    cosign
    curl
    entr
    fd
    ffmpeg_6-full
    go-task
    graphviz
    httpstat
    hyperfine
    inetutils
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
    sqlite
    tldr
    unixtools.watch
    unrar
    vegeta
    wget
    yarn

    # From NUR
    nur.repos.caarlos0.gocovsh
    nur.repos.caarlos0.jsonfmt
    nur.repos.caarlos0.svu
    nur.repos.caarlos0.glyphs
    nur.repos.goreleaser.goreleaser-pro

    # treesitter, lsps, formatters, etc
    bash-language-server
    cargo
    clang-tools # clangd lsp
    delve
    dockerfile-language-server-nodejs
    gofumpt
    golangci-lint
    golangci-lint-langserver
    gopls
    nil # nix lsp
    nixpkgs-fmt
    pgformatter
    prettier
    rust-analyzer
    rustc
    rustfmt
    shellcheck
    shfmt
    sql-formatter
    stylua
    sumneko-lua-language-server
    taplo # toml lsp
    terraform-ls
    tflint
    tree-sitter
    typescript-language-server
    vscode-html-languageserver-bin
    vscode-json-languageserver-bin
    yaml-language-server
    yamllint
    zig
    zls # zig lsp
  ] ++ (lib.optionals pkgs.stdenv.isDarwin [
    nur.repos.caarlos0.discord-applemusic-rich-presence
    terminal-notifier
    coreutils
    mosquitto
  ]) ++ (lib.optionals pkgs.stdenv.isLinux [
    docker
    docker-compose
    lm_sensors
    util-linux
    # https://nixos.wiki/wiki/podman
    # podman
    # shadow
  ]);
}
