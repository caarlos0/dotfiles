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
    plugins = with pkgs.vimPlugins; [
      # ui
      catppuccin-nvim
      nvim-web-devicons
      nvim-tree-lua
      nvim-notify
      bufferline-nvim
      lualine-nvim
      dressing-nvim
      fidget-nvim

      # basics
      indent-blankline-nvim
      gitsigns-nvim
      todo-comments-nvim
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
      sqlite-lua
      (fromGitHub "prochri" "telescope-all-recent.nvim"
        "f26fad245d5a468fe7fd0b494fc983f707f2c4f3"
        "xzYPDyJH0BLYDoyZSrt1F+NajyQC7F2YJd+JWDzfZi8=")
      nvim-osc52
      mini-nvim
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
      nvim-ts-autotag
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      luasnip
      cmp_luasnip
      friendly-snippets
      neodev-nvim
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
      lsp-inlayhints-nvim
      (fromGitHub "RRethy" "nvim-treesitter-endwise"
        "0cf4601c330cf724769a2394df555a57d5fd3f34"
        "Pns+3gLlwhrojKQWN+zOFxOmgRkG3vTPGoLX90Sg+oo=")

      # TODO: "JellyApple102/easyread.nvim",
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
