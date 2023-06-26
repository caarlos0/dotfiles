require("nvim-tree").setup({
  disable_netrw = false,
  hijack_netrw = true,
  update_focused_file = {
    enable = true,
  },
})

vim.keymap.set("n", "<leader>tv", "<cmd>NvimTreeToggle<cr>", {
  noremap = true,
  silent = true,
  desc = "Toggle nvim-tree",
})
