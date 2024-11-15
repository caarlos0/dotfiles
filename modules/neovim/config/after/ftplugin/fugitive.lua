local async = require("plenary.async")

local opts = {
  noremap = true,
  silent = true,
  buffer = vim.api.nvim_get_current_buf(),
}

-- goes directly to the first file and opens diff view
vim.cmd("normal )=")

vim.keymap.set("n", "gp", function()
  vim.cmd("close")
  async.void(function()
    vim.cmd("silent! Git push --quiet")
  end)
end, opts)

vim.keymap.set("n", "gP", function()
  vim.cmd("close")
  async.void(function()
    vim.cmd("silent! Git pull --rebase")
  end)
end, opts)

vim.keymap.set("n", "go", function()
  vim.cmd("close")
  async.void(function()
    vim.cmd("silent! Git push origin HEAD --quiet")
    vim.cmd("silent! Git pr")
  end)
end, opts)
