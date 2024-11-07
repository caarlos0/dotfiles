local opts = {
  noremap = true,
  silent = true,
  buffer = vim.api.nvim_get_current_buf(),
}

-- goes directly to the first file and opens diff view
vim.cmd("normal )=")

vim.keymap.set("n", "gp", function()
  vim.cmd([[
    silent! Git push --quiet
    close
  ]])
end, opts)

vim.keymap.set("n", "gP", function()
  vim.cmd([[
    silent! Git pull --rebase
    close
  ]])
end, opts)

vim.keymap.set("n", "go", function()
  vim.cmd([[
    silent! Git push origin HEAD --quiet
    silent! Git pr
    close
  ]])
end, opts)
