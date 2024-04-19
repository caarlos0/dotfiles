vim.opt_local.autoread = true
local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("Autoread", { clear = true }),
  buffer = bufnr,
  callback = function()
    vim.cmd("silent! checktime")
  end,
})
