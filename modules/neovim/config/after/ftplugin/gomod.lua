vim.cmd.runtime({ "after/ftplugin/go.lua", bang = true })
vim.cmd.runtime({ "lua/autoread.lua", bang = true })

local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("GoMod", { clear = true }),
  buffer = bufnr,
  callback = function()
    vim.cmd.GoModTidy()
  end,
})
