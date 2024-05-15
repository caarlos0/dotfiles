vim.g.fugitive_legacy_commands = 0

vim.keymap.set("n", "<leader>gs", vim.cmd.Git, {
  noremap = true,
  silent = true,
  desc = "Open Git",
})

vim.keymap.set("n", "<leader>gms", function()
  vim.cmd.Git("sync")
end, {
  noremap = true,
  silent = true,
  desc = "Git sync",
})

require("gitsigns").setup({
  preview_config = {
    border = "rounded",
  },
})

vim.keymap.set("n", "<leader>gp", function()
  vim.cmd.Gitsigns("preview_hunk")
end, {
  noremap = true,
  silent = true,
  desc = "Git preview hunk",
})
