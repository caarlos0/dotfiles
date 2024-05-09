---@diagnostic disable: undefined-global
local bufnr = vim.api.nvim_get_current_buf()

vim.opt_local.formatoptions:append("jo")

vim.api.nvim_buf_create_user_command(bufnr, "GoModTidy", function()
  vim.notify("Running `go mod tidy`...")
  local uri = vim.uri_from_bufnr(bufnr)
  local arguments = { { URIs = { uri } } }
  vim.cmd([[ noautocmd wall ]])
  vim.lsp.buf.execute_command({
    command = "gopls.tidy",
    arguments = arguments,
  })
end, { desc = "go mod tidy" })

vim.keymap.set("n", "<leader>gmt", vim.cmd.GoModTidy, {
  noremap = true,
  silent = true,
  buffer = bufnr,
  desc = "Run go mod tidy",
})
