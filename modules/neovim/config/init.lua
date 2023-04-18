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
require("mini.starter").setup()
require("mini.sessions").setup()

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
require("dressing").setup({})
require("fidget").setup({
  text = { spinner = "dots_pulse" },
})
require("user.test")
require("user.harpoon")
require("user.telescope")
require("user.fugitive")
require("user.undotree")
require("which-key").setup()
require("user.tree")
require("user.bufremove")
require("auto-hlsearch").setup()
if os.getenv("SSH_CLIENT") ~= nil then
  require("user.osc52")
end

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
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.comment").setup()
require("nvim-ts-autotag").setup({ enable = true })
require("user.lsp")
require("user.cmp")
require("user.treesitter")
