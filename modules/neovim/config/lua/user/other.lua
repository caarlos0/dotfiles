require("other-nvim").setup({
  mappings = {
    "golang",
    {
      pattern = "go.mod$",
      target = "go.sum",
      context = "sum",
    },
    {
      pattern = "go.sum$",
      target = "go.mod",
      context = "mod",
    },
    {
      pattern = "go.work$",
      target = "go.work.sum",
      context = "sum",
    },
    {
      pattern = "go.work.sum$",
      target = "go.work",
      context = "mod",
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
