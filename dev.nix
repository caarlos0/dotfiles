{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    # package = pkgs.neovim-nightly;
    # install needed binaries here
    # plugins = with pkgs.vimPlugins; [
    # ];
  };

  home.sessionVariables = { GOPATH = "~/Developer/Go"; };

  home.packages = with pkgs; [
    tree-sitter

    # nix
    nil
    nixfmt

    # go
    go
    goreleaser
    gofumpt
    gopls

    # rust
    cargo
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
