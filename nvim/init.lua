require("config.options")
require("config.keymaps")
require("config.autocommands")

vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },

  { src = "https://github.com/zbirenbaum/copilot.lua" },
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1.*"),
  },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/giuxtaposition/blink-cmp-copilot" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },

  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/tpope/vim-rhubarb" },
  { src = "https://github.com/tpope/vim-abolish" },
  { src = "https://github.com/tpope/vim-repeat" },
  { src = "https://github.com/tpope/vim-eunuch" },
  { src = "https://github.com/tpope/vim-sleuth" },
  { src = "https://github.com/tpope/vim-speeddating" },

  { src = "https://github.com/nvim-lualine/lualine.nvim", },
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
  { src = "https://github.com/stevearc/dressing.nvim", },

  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-github.nvim" },
  {
    src = "https://github.com/nvim-telescope/telescope.nvim",
    version = vim.version.range("0.1.*"),
  },

  { src = "https://github.com/christoomey/vim-tmux-navigator" },

  { src = "https://github.com/rgroli/other.nvim" },
  { src = "https://github.com/danymat/neogen" },
  { src = "https://github.com/rcarriga/nvim-notify" },


  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  { src = "https://github.com/wansmer/treesj" },
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/kylechui/nvim-surround" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/folke/ts-comments.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/RRethy/nvim-treesitter-endwise" },


  { src = "https://github.com/stevearc/conform.nvim", },
  { src = "https://github.com/lewis6991/gitsigns.nvim", },
  { src = "https://github.com/asiryk/auto-hlsearch.nvim", },
  { src = "https://github.com/famiu/bufdelete.nvim", },
  { src = "https://github.com/norcalli/nvim-colorizer.lua", },
  { src = "https://github.com/akinsho/git-conflict.nvim", },
})

require("plugins.lsp")
require("plugins.blink-cmp")
require("plugins.gruvbox")
require("plugins.telescope")
require("plugins.other")
require("plugins.neogen")
require("plugins.notify")
require("plugins.syntax")
require("plugins.conform")
require("plugins.lualine")
require("dressing").setup({ input = { insert_only = true } })
require("plugins.gitsigns")
