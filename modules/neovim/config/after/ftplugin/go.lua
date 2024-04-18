vim.opt_local.formatoptions:append("jo")

local function tidy()
  vim.notify("Running `go mod tidy`...")
  local b = vim.api.nvim_get_current_buf()
  local uri = vim.uri_from_bufnr(b)
  local arguments = { { URIs = { uri } } }
  vim.lsp.buf.execute_command({
    command = "gopls.tidy",
    arguments = arguments,
  })
end

vim.api.nvim_create_user_command("GoModTidy", tidy, vim.tbl_extend("force", { desc = "go mod tidy" }, {}))

local group = vim.api.nvim_create_augroup("Go", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "go.mod", "go.sum", "go.work" },
  callback = tidy,
  group = group,
})

vim.keymap.set("n", "<leader>gmt", ":GoModTidy<CR>", { noremap = true, silent = true, desc = "Run go mod tidy" })
