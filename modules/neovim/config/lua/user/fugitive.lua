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
