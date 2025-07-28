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

  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
  { src = "https://github.com/stevearc/dressing.nvim" },

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

  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/asiryk/auto-hlsearch.nvim" },
  { src = "https://github.com/famiu/bufdelete.nvim" },
  { src = "https://github.com/norcalli/nvim-colorizer.lua" },
  { src = "https://github.com/akinsho/git-conflict.nvim" },
})

local opts = { noremap = true, silent = true }

require("plugins.lsp")
require("plugins.telescope")
require("plugins.syntax")

local bg0 = "#1b1b1b"
require("gruvbox").setup({
  contrast = "hard",
  overrides = {
    GruvboxBg0 = { fg = bg0 },
    SignColumn = { bg = bg0 },
    GruvboxRedSign = { bg = bg0 },
    GruvboxYellowSign = { bg = bg0 },
    GruvboxGreenSign = { bg = bg0 },
    GruvboxAquaSign = { bg = bg0 },
    GruvboxOrangeSign = { bg = bg0 },
    GruvboxPurpleSign = { bg = bg0 },
    GruvboxBlueSign = { bg = bg0 },
    Normal = { bg = bg0 },
  },
})
vim.cmd("colorscheme gruvbox")
-- https://github.com/ellisonleao/gruvbox.nvim/commit/c74e6e523c4827b67af2cb02b636e22dc35fdf70
-- https://github.com/nvim-lualine/lualine.nvim/issues/1312
vim.api.nvim_set_hl(0, "StatusLine", { reverse = false })
vim.api.nvim_set_hl(0, "StatusLineNC", { reverse = false })

require("dressing").setup({ input = { insert_only = true } })

local notify = require("notify")
notify.setup({
  render = "compact",
  stages = "static",
  timeout = 2000,
  max_height = function()
    return math.floor(vim.o.lines * 0.75)
  end,
  max_width = function()
    return math.floor(vim.o.columns * 0.75)
  end,
  on_open = function(win)
    vim.api.nvim_win_set_config(win, { focusable = false })
  end,
})
vim.notify = notify

require("lualine").setup({
  options = {
    theme = "gruvbox",
    component_separators = "",
    section_separators = "",
  },
  sections = {
    lualine_c = {
      "%=",
      {
        "filename",
        file_status = false,
        path = 1,
      },
    },
  },
  inactive_sections = {
    lualine_c = {
      "%=",
      {
        "filename",
        file_status = false,
        path = 1,
      },
    },
    lualine_x = { "location" },
  },
})

require("gitsigns").setup({
  preview_config = {
    border = "none",
  },
})
vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns preview_hunk<cr>", opts)

require("other-nvim").setup({
  mappings = {
    "golang",
    {
      pattern = "go.mod$",
      target = "go.sum",
      context = "sum",
    },
    {
      pattern = "go.sum$",
      target = "go.mod",
      context = "mod",
    },
    {
      pattern = "go.work$",
      target = "go.work.sum",
      context = "sum",
    },
    {
      pattern = "go.work.sum$",
      target = "go.work",
      context = "mod",
    },
  },
})

vim.keymap.set("n", "<leader>oo", "<cmd>Other<cr>", opts)
vim.keymap.set("n", "<leader>ov", "<cmd>OtherVSplit<cr>", opts)
vim.keymap.set("n", "<leader>os", "<cmd>OtherSplit<cr>", opts)

require("neogen").setup({
  snippet_engine = "nvim",
})
vim.keymap.set("n", "gco", "<cmd>Neogen<cr>", opts)

require("conform").setup({
  formatters_by_ft = {
    css = { "prettier" },
    fish = { "fish_indent" },
    html = { "prettier" },
    javascript = { "prettier" },
    json = { "jq" },
    lua = { "stylua" },
    markdown = { "prettier" },
    sh = { "shfmt" },
    sql = { "pg_format", "sql_formatter" },
    templ = { "templ" },
    tf = { "terraform_fmt" },
    yaml = { "prettier" },
    ["_"] = { "trim_whitespace", "trim_newlines" },
    -- let only the lsp take care of these.
    go = {},
    rust = {},
    zig = {},
  },
  format_after_save = {
    lsp_fallback = true,
  },
})

require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})

---@module 'blink.cmp'
---@type blink.cmp.Config
require("blink.cmp").setup({
  keymap = { preset = "default" },
  appearance = {
    -- use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
    kind_icons = {
      Array = "",
      Boolean = "",
      Class = "",
      Color = "",
      Constant = "",
      Constructor = "",
      Copilot = "",
      Enum = "",
      EnumMember = "",
      Event = "",
      Field = "",
      File = "",
      Folder = "󰉋",
      Function = "",
      Interface = "",
      Key = "",
      Keyword = "",
      Method = "",
      Module = "",
      Namespace = "",
      Null = "󰟢",
      Number = "",
      Object = "",
      Operator = "",
      Package = "",
      Property = "",
      Reference = "",
      Snippet = "",
      String = "",
      Struct = "",
      Text = "",
      TypeParameter = "",
      Unit = "",
      Value = "",
      Variable = "",
    },
  },
  signature = { enabled = true },
  cmdline = {
    enabled = true,
    sources = function()
      local type = vim.fn.getcmdtype()
      if type == "/" or type == "?" then
        return { "buffer" }
      end
      if type == ":" then
        return { "cmdline" }
      end
      return {}
    end,
    completion = {
      menu = {
        draw = {
          columns = {
            { "kind_icon", "label", gap = 1 },
            { "kind" },
          },
        },
      },
    },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "copilot" },
    providers = {
      lsp = {
        min_keyword_length = 0,
        score_offset = 0,
      },
      path = {
        min_keyword_length = 0,
      },
      snippets = {
        min_keyword_length = 2,
      },
      buffer = {
        min_keyword_length = 5,
        max_items = 5,
      },
      copilot = {
        name = "copilot",
        module = "blink-cmp-copilot",
        -- score_offset = -10,
        min_keyword_length = 0,
        async = true,
        override = {
          -- copilot complete on space, new line, etc as well...
          get_trigger_characters = function(self)
            local trigger_characters = self:get_trigger_characters()
            vim.list_extend(trigger_characters, { "\n", "\t", " " })
            return trigger_characters
          end,
        },
        transform_items = function(_, items)
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1
          CompletionItemKind[kind_idx] = "Copilot"
          for _, item in ipairs(items) do
            item.kind = kind_idx
          end
          return items
        end,
      },
    },
  },
  completion = {
    accept = { auto_brackets = { enabled = true } },

    keyword = {
      range = "full",
    },

    trigger = {
      show_on_insert_on_trigger_character = true,
      show_on_trigger_character = true,
      show_on_keyword = true,
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 250,
      treesitter_highlighting = true,
    },

    menu = {
      draw = {
        columns = {
          { "kind_icon", "label", gap = 1 },
          { "kind" },
        },
      },
    },
  },
})
