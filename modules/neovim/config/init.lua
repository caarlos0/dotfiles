require("user.options")
require("user.keymaps")
require("user.autocommands")

--
-- UI
--
require("user.colorscheme")
require("nvim-web-devicons").setup()
require("user.notify")
require("user.bufferline")
require("user.lualine")
require("user.session")

--
-- BASIC
--
require("user.indent")
require("gitsigns").setup()
require("todo-comments").setup({
  highlight = {
    keyword = "bg",
  },
})
require("dressing").setup({
  input = {
    insert_only = false,
  },
  select = {
    get_config = function(opts)
      if opts.kind == "codeaction" or opts.kind == "codelens" then
        return {
          backend = "builtin",
          nui = {
            relative = "cursor",
            max_width = 60,
          },
        }
      end
    end,
  },
})
require("user.test")
require("user.harpoon")
require("user.telescope")
require("user.fugitive")
require("auto-hlsearch").setup()
require("better_escape").setup({
  mapping = { "jk", "kj" },
  timeout = 100,
})

--
-- CODING
--
require("neodev").setup({})
require("luasnip").setup({
  -- see: https://github.com/L3MON4D3/LuaSnip/issues/525
  region_check_events = "InsertEnter",
  delete_check_events = "InsertLeave",
})
require("luasnip.loaders.from_vscode").lazy_load()
require("nvim-autopairs").setup({ check_ts = true })
require("nvim-ts-autotag").setup({ enable = true })
require("user.lsp")
require("user.cmp")
require("nvim-surround").setup()
require("Comment").setup()
require("user.treesitter")
require("user.debug")
require("user.other")
