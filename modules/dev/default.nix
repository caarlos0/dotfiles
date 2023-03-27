{ config, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
    # package = pkgs.neovim-nightly;
    # install needed binaries here
    # plugins = with pkgs.vimPlugins; [
    # ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink ./neovim;
    recursive = true;
  };

  xdg.configFile."yamllint/config".text = ''
    extends: relaxed
    rules:
      line-length: disable
  '';

  home.sessionVariables = { GOPATH = "$HOME/Developer/Go"; };

  home.packages = with pkgs; [
    tree-sitter

    # nix
    nil
    nixfmt

    # lua
    sumneko-lua-language-server
    stylua

    # go
    go
    goreleaser
    gofumpt
    gopls
    golangci-lint
    golangci-lint-langserver

    # rust
    cargo
    rust-analyzer

    # terraform
    tflint
    terraform-ls

    # toml
    taplo

    # yaml
    yamllint
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
