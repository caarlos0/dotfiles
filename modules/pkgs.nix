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
      ripgrep
      sqlite
      sshpass
      stern
      syft
      terraform
      timer
      tldr
      upx
      vegeta
      wget
      yarn

      # From NUR
      nur.repos.caarlos0.fork-cleaner
      nur.repos.caarlos0.gocovsh
      nur.repos.caarlos0.jsonfmt
      nur.repos.caarlos0.svu
      nur.repos.goreleaser.goreleaser-pro

      # fonts
      # using berkeley mono now, and wezterm already comes with jetbrains mono.
      # (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

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
      yaml-language-server
      yamllint
    ] ++ (lib.optionals pkgs.stdenv.isDarwin [
      nur.repos.caarlos0.discord-applemusic-rich-presence
      terminal-notifier
    ]) ++ (lib.optionals pkgs.stdenv.isLinux [ docker docker-compose podman ]);
}
