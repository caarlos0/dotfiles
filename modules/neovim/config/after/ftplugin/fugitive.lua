local async = require("plenary.async")

local opts = {
  noremap = true,
  silent = true,
  buffer = vim.api.nvim_get_current_buf(),
}

-- goes directly to the first file and opens diff view
vim.cmd("normal )=")

vim.keymap.set("n", "gp", function()
  async.run(function()
    vim.cmd([[
      silent! Git push --quiet
    ]])
  end)
  vim.cmd([[ close ]])
end, opts)

vim.keymap.set("n", "gP", function()
  async.run(function()
    vim.cmd([[
      silent! Git pull --rebase
    ]])
  end)
  vim.cmd([[ close ]])
end, opts)

vim.keymap.set("n", "go", function()
  async.run(function()
    vim.cmd([[
      silent! Git push origin HEAD --quiet
      silent! Git pr
    ]])
  end)
  vim.cmd([[ close ]])
end, opts)
