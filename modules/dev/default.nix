{ config, pkgs, lib, ... }:
let
  fromGitHub = owner: repo: ref: hash:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = pkgs.fetchFromGitHub {
        owner = owner;
        repo = repo;
        rev = ref;
        sha256 = hash;
      };
    };
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
    # package = pkgs.neovim-nightly;
    # install needed binaries here
    plugins = with pkgs.vimPlugins; [
      # ui
      catppuccin-nvim
      nvim-web-devicons
      nvim-tree-lua
      nvim-notify
      bufferline-nvim
      lualine-nvim
      (fromGitHub "rmagatti" "auto-session"
        "1d3dd70a2d48e0f3441128eb4fb0b437a0bf2cc4"
        "Hv6pteuZNvwNLh4dCkwF1pY8YSs02lmP2oq8RuwqK/M=")

      # basics
      indent-blankline-nvim
      gitsigns-nvim
      todo-comments-nvim
      dressing-nvim
      fidget-nvim
      vim-test
      harpoon
      vim-fugitive
      undotree
      which-key-nvim
      vim-abolish
      vim-repeat
      vim-eunuch
      vim-sleuth
      vim-speeddating
      telescope-nvim
      telescope-github-nvim
      (fromGitHub "echasnovski" "mini.indentscope" "v0.7.0"
        "C6nD0764FwyCcFw7K0GJ6p6PwEOkkry5NenYl8FhjFc=")
      (fromGitHub "echasnovski" "mini.bufremove" "v0.7.0"
        "jpp3B/jVWIa+lVq3vVsA5gn99T/jkm7kwmXjs3BcZ2k=")
      (fromGitHub "ojroques" "nvim-osc52"
        "47ce7ee2396fa3ee4fb6b0e0ef14ba06f9c9bd31"
        "SQpwiA+dyTRXBq0YtUZ4nkYKglyChIyQeWopD73qznQ=")
      (fromGitHub "asiryk" "auto-hlsearch.nvim" "1.1.0"
        "AitkdtKoKNAURrEZuQU/VRLj71qDlI4zwL+vzXUJzew=")

      # coding
      symbols-outline-nvim
      nvim-lspconfig
      null-ls-nvim
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-emoji
      cmp-calc
      nvim-autopairs
      nvim-ts-autotag
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      luasnip
      cmp_luasnip
      neodev-nvim
      nvim-surround
      comment-nvim
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins:
        with plugins; [
          bash
          cpp
          css
          diff
          dockerfile
          fish
          git_config
          git_rebase
          gitattributes
          gitcommit
          gitignore
          go
          gomod
          gowork
          graphql
          hcl
          help
          html
          http
          javascript
          jq
          json
          lua
          make
          markdown
          markdown_inline
          nix
          python
          query
          regex
          rust
          scss
          sql
          terraform
          toml
          vhs
          vim
          yaml
          zig
        ]))
      nvim-treesitter-textobjects
      nvim-treesitter-context
      (fromGitHub "RRethy" "nvim-treesitter-endwise"
        "0cf4601c330cf724769a2394df555a57d5fd3f34"
        "Pns+3gLlwhrojKQWN+zOFxOmgRkG3vTPGoLX90Sg+oo=")
      (fromGitHub "simrat39" "inlay-hints.nvim"
        "006b0898f5d3874e8e528352103733142e705834"
        "cDWx08N+NhN5Voxh8f7RGzerbAYB5FHE6TpD4/o/MIQ=")

      # TODO: "JellyApple102/easyread.nvim",
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink ./neovim;
    #    recursive = true;
  };

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
    goreleaser
    gofumpt
    gopls # lsp
    golangci-lint
    golangci-lint-langserver # lsp

    # rust
    cargo
    rust-analyzer # lsp

    # terraform
    tflint
    terraform-ls # lsp

    # toml
    taplo # lsp

    # yaml
    yamllint

    # english
    ltex-ls # lsp

    # docker
    docker-ls # lsp
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
