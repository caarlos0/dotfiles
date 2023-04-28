require("other-nvim").setup({
  mappings = {
    {
      pattern = "(.*).go$",
      target = "%1_test.go",
      context = "test",
    },
    {
      pattern = "(.*)_test.go$",
      target = "%1.go",
      context = "file",
    },
  },
})

vim.keymap.set("n", "<leader>oo", ":Other<CR>", {
  noremap = true,
  silent = true,
  desc = "Open other file",
})
vim.keymap.set("n", "<leader>ov", ":OtherVSplit<CR>", {
  noremap = true,
  silent = true,
  desc = "Open other file in a vertical split",
})
vim.keymap.set("n", "<leader>os", ":OtherSplit<CR>", {
  noremap = true,
  silent = true,
  desc = "Open other file in a horizontal split",
})
