require("mini.bufremove").setup({})
vim.keymap.set("n", "<leader>q", function()
  require("mini.bufremove").delete(0, true)
end, {
  noremap = true,
  silent = true,
  desc = "Delete buffer",
})
