local opts = { noremap = true, silent = true }
local neogen = require("neogen")
neogen.setup({
  snippet_engine = "nvim",
})
vim.keymap.set("n", "gco", neogen.generate, opts)
