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

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>oo", "<cmd>Other<cr>", opts)
vim.keymap.set("n", "<leader>ov", "<cmd>OtherVSplit<cr>", opts)
vim.keymap.set("n", "<leader>os", "<cmd>OtherSplit<cr>", opts)
