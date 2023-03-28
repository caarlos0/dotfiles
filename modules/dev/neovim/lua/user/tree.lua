require("nvim-tree").setup()

vim.keymap.set("n", "<leader>tv", "<cmd>NvimTreeToggle<cr>", {
  noremap = true,
  silent = true,
  desc = "nvim-tree",
})
