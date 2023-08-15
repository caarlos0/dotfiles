-- revert this once https://github.com/nvim-neotest/neotest-go/issues/51 is fixed.
vim.keymap.set("n", "<leader>ttn", ":TestNearest -v<CR>g", {
  noremap = true,
  silent = true,
  desc = "Test nearest",
})
vim.keymap.set("n", "<leader>ttf", ":TestFile -v<CR>g", {
  noremap = true,
  silent = true,
  desc = "Test file",
})
vim.keymap.set("n", "<leader>tts", ":TestSuite -v<CR>g", {
  noremap = true,
  silent = true,
  desc = "Test Suite",
})
vim.keymap.set("n", "<leader>ttl", ":TestLast -v<CR>g", {
  noremap = true,
  silent = true,
  desc = "Test latest",
})
vim.keymap.set("n", "<leader>ttv", ":TestVisit -v<CR>g", {
  noremap = true,
  silent = true,
  desc = "Test visit",
})

vim.api.nvim_set_var("test#strategy", "neovim")
vim.api.nvim_set_var("test#neovim#term_position", "vert")
