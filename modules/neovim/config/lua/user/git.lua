vim.g.fugitive_legacy_commands = 0
vim.g.flog_enable_extended_chars = 1

vim.keymap.set("n", "<leader>gs", "<cmd>tab Git<cr>", {
  noremap = true,
  silent = true,
  desc = "Open Git",
})

require("gitsigns").setup({
  preview_config = {
    border = "rounded",
  },
})

vim.keymap.set("n", "<leader>gd", function()
  vim.cmd.Gitsigns("preview_hunk")
end, {
  noremap = true,
  silent = true,
  desc = "Git preview hunk",
})
