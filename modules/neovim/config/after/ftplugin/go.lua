local ms = require("vim.lsp.protocol").Methods

---@diagnostic disable-next-line: undefined-field
vim.opt_local.formatoptions:append("jo")

local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_create_user_command(bufnr, "GoModTidy", function()
  vim.notify("Running `go mod tidy`...")
  local uri = vim.uri_from_bufnr(bufnr)
  local arguments = { { URIs = { uri } } }
  vim.cmd.wall()
  vim.lsp.buf.execute_command({
    command = "gopls.tidy",
    arguments = arguments,
  })
  -- vim.cmd("silent! e") -- do we need this?
end, { desc = "go mod tidy" })

vim.keymap.set("n", "<leader>gmt", vim.cmd.GoModTidy, {
  noremap = true,
  silent = true,
  desc = "Run go mod tidy",
})
