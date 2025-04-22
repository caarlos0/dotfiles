require("user.options")
require("user.keymaps")
require("user.autocommands")

--
-- UI
--
require("user.colorscheme")
require("nvim-web-devicons").setup()
require("user.notify")
require("user.lualine")
require("colorizer").setup()

--
-- BASIC
--
require("user.indent")
require("dressing").setup({
  input = {
    insert_only = false,
  },
})
require("user.harpoon")
require("user.telescope")
require("user.git")
require("auto-hlsearch").setup()

--
-- CODING
--
require("lazydev").setup({})
require("nvim-autopairs").setup({ check_ts = true })
require("nvim-ts-autotag").setup({ enable = true })
require("user.lsp")
require("user.cmp")
require("nvim-surround").setup()
require("user.treesitter")
require("user.other")
require("user.conform")
require("user.neogen")
require("user.avante")
