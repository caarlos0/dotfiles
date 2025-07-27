require("gitsigns").setup({
  preview_config = {
    border = "none",
  },
})

vim.keymap.set("n", "<leader>gd", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview Git hunk" })
