{ config, pkgs, lib, ... }:
let
  fromGitHub = owner: repo: ref: hash:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = pkgs.fetchFromGitHub {
        owner = owner;
        repo = repo;
        rev = ref;
        sha256 = hash;
      };
    };

in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      # ui
      catppuccin-nvim
      nvim-web-devicons
      nvim-notify
      lualine-nvim
      # dressing-nvim TODO: https://github.com/stevearc/dressing.nvim/issues/126
      (fromGitHub "stevearc" "dressing.nvim" "master"
        "sha256-htUCShHjjwJU26/POs2GHDoUFFxczCXd87Ao//as5ig=")

      # basics
      indent-blankline-nvim
      gitsigns-nvim
      todo-comments-nvim
      neotest
      neotest-go
      neotest-rust
      neotest-jest
      # TODO: until harpoon2 is merged into main
      (fromGitHub "ThePrimeagen" "harpoon" "harpoon2"
        "sha256-WD93Oq1WHrfkdOVbYDJiExr+MP1Uezl5WKA53jEdwmY=")
      vim-fugitive
      vim-rhubarb
      vim-abolish
      vim-repeat
      vim-eunuch
      vim-sleuth
      vim-speeddating
      telescope-nvim
      telescope-github-nvim
      auto-hlsearch-nvim
      vim-tmux-navigator
      better-escape-nvim
      bufdelete-nvim

      # coding
      nvim-lspconfig
      (fromGitHub "stevearc" "conform.nvim" "v4.0.0"
        "sha256-fcifkP2beaHRIsyZbqk4fdryvXxTJfPGE7dwZ51ENTc=")
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
      copilot-lua
      copilot-cmp
      luasnip
      cmp_luasnip
      friendly-snippets
      neodev-nvim
      nvim-surround
      comment-nvim
      treesj
      lsp_lines-nvim
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins:
        with plugins; [
          arduino
          awk
          bash
          cpp
          css
          csv
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
          gosum
          gowork
          graphql
          hcl
          html
          http
          http
          ini
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
          ruby
          rust
          scss
          sql
          ssh_config
          terraform
          toml
          vhs
          vim
          yaml
          zig
        ]))
      nvim-treesitter-textobjects
      nvim-treesitter-context
      nvim-treesitter-endwise
      other-nvim
      # treesitter injections for home-manager
      (fromGitHub "calops" "hmts.nvim" "v1.2.2"
        "sha256-jUuztOqNBltC3axa7s3CPJz9Cmukfwkf846+Z/gAxCU=")

      # debug
      nvim-dap
      nvim-dap-ui
      nvim-dap-go
      telescope-dap-nvim
      nvim-dap-virtual-text


      # others
      vim-wakatime
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
