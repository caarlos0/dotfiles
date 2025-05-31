---@diagnostic disable: missing-fields
require("avante_lib").load()
require("avante").setup({
  hints = { enabled = false },
})

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
local avante = require("avante.api")
keymap("n", "<leader>aa", function()
  avante.ask()
end, opts)
keymap("n", "<leader>ar", function()
  avante.refresh()
end, opts)
keymap("v", "<leader>ae", function()
  avante.edit()
end, opts)
