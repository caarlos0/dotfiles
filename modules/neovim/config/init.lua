require("user.options")
require("user.keymaps")
require("user.autocommands")
require("user.commands")
require("cloak").setup()

--
-- UI
--
require("user.colorscheme")
require("nvim-web-devicons").setup()
require("user.notify")
require("user.lualine")

--
-- BASIC
--
require("user.indent")
require("gitsigns").setup({
  current_line_blame = true,
})
require("user.todo")
require("dressing").setup({
  input = {
    insert_only = false,
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
require("user.conform")
