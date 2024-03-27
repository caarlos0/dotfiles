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
      dressing-nvim

      # basics
      indent-blankline-nvim
      gitsigns-nvim
      todo-comments-nvim
      neotest
      neotest-go
      neotest-rust
      neotest-jest
      harpoon2
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
      cloak-nvim

      # coding
      nvim-lspconfig
      conform-nvim
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
      hmts-nvim # treesitter injections for home-manager

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
