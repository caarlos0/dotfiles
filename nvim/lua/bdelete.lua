vim.keymap.set("n", "<leader>q", ":bdelete!<cr>", {
  noremap = true,
  silent = true,
  buffer = vim.api.nvim_get_current_buf(),
  desc = "Close buffer",
})
