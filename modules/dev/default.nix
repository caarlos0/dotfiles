{ pkgs, ... }: {
  xdg.configFile."yamllint/config".text = ''
    extends: relaxed
    rules:
      line-length: disable
  '';

  home.sessionVariables = { GOPATH = "$HOME/Developer/Go"; };

  home.packages = with pkgs; [
    tree-sitter

    # bash
    nodePackages.bash-language-server
    shfmt
    shellcheck

    # nix
    nil # lsp
    nixfmt

    # lua
    sumneko-lua-language-server # lsp
    stylua

    # c
    clang-tools # lsp (clangd)

    # go
    go
    nur.repos.caarlos0.goreleaser-pro
    gofumpt
    gopls # lsp
    golangci-lint
    golangci-lint-langserver # lsp
    delve

    # rust
    cargo
    rust-analyzer # lsp
    rustc
    rustfmt

    # terraform
    tflint
    terraform-ls # lsp

    # toml
    taplo # lsp

    # yaml
    yamllint
    nodePackages.yaml-language-server

    # docker
    docker-ls # lsp

    # others
    # nur.repos.caarlos0.prosemd-lsp
  ];

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        max_line_width = 78;
        indent_style = "tab";
        indent_size = 4;
      };
      "*.{rb,yaml,yml,lua,nix}" = {
        indent_style = "space";
        indent_size = 2;
      };
    };
  };
}
