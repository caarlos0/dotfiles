require("user.options")
require("user.keymaps")
require("user.autocommands")

require("cloak").setup()

--
-- UI
--
require("user.colorscheme")
-- require("nvim-web-devicons").setup()
-- require("user.notify")
-- require("user.lualine")

--
-- BASIC
--
-- require("user.indent")
-- require("user.todo")
require("dressing").setup({
  input = {
    insert_only = false,
  },
})
require("user.harpoon")
require("user.telescope")
require("user.git")
-- require("auto-hlsearch").setup()
require("user.escape")

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
require("nvim-ts-autotag").setup({ enable = true })
require("user.lsp")
require("user.cmp")
require("user.treesitter")
require("user.other")
require("user.conform")
require("user.neogen")
require("user.avante")

-- mini
require("mini.bracketed").setup()
require("mini.bufremove").setup()
require("mini.clue").setup()
require("mini.comment").setup()
require("mini.cursorword").setup()
require("mini.icons").setup()
require("mini.jump").setup()
require("mini.notify").setup()
require("mini.operators").setup()
require("mini.pairs").setup()
require("mini.splitjoin").setup()
require("mini.statusline").setup()
require("mini.surround").setup()
require("mini.diff").setup()
require("mini.indentscope").setup({
  draw = {
    animation = require("mini.indentscope").gen_animation.none(),
  },
  symbol = "",
})
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    xxx = { pattern = "%f[%w]()XXX()%f[%W]", group = "MiniHipatternsFixme" },
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})
