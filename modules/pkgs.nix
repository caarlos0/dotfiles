{ pkgs, lib, ... }: {
  home.packages = with pkgs;
    with pkgs.nodePackages_latest;
    [
      age
      comma
      cosign
      curl
      fd
      ffmpeg
      git-lfs
      go-task
      graphviz
      htmltest
      httpstat
      hugo
      hyperfine
      inetutils
      jq
      kubectl
      kubectx
      kubernetes-helm
      moreutils
      ncdu
      neofetch
      netcat-gnu
      nmap
      nodejs
      onefetch
      p7zip
      ranger
      ripgrep
      sqlite
      sshpass
      stern
      syft
      terraform
      timer
      tldr
      upx
      unixtools.watch
      vegeta
      wget
      yarn

      # From NUR
      nur.repos.caarlos0.fork-cleaner
      nur.repos.caarlos0.gocovsh
      nur.repos.caarlos0.jsonfmt
      nur.repos.caarlos0.svu
      nur.repos.goreleaser.goreleaser-pro

      # treesitter, lsps, etc
      bash-language-server
      cargo
      clang-tools # clangd lsp
      delve
      docker-ls
      gofumpt
      golangci-lint
      golangci-lint-langserver
      gopls
      marksman # markdown lsp
      nil # nix lsp
      nixpkgs-fmt
      prettier
      rust-analyzer
      rustc
      rustfmt
      shellcheck
      shfmt
      stylua
      sumneko-lua-language-server
      taplo # tomp lsp
      terraform-ls
      tflint
      tree-sitter
      typescript-language-server
      vscode-html-languageserver-bin
      vscode-json-languageserver-bin
      yaml-language-server
      yamllint
      zk # zettelkasten
    ] ++ (lib.optionals pkgs.stdenv.isDarwin [
      nur.repos.caarlos0.discord-applemusic-rich-presence
      terminal-notifier
      coreutils
    ]) ++ (lib.optionals pkgs.stdenv.isLinux [
      util-linux
      docker
      docker-compose
      # https://nixos.wiki/wiki/podman
      # podman
      # shadow
    ]);
}
