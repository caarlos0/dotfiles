---@diagnostic disable: undefined-global
local ms = require("vim.lsp.protocol").Methods
local bufnr = vim.api.nvim_get_current_buf()

vim.opt_local.formatoptions:append("jo")

local function watchFileChanged()
  local params = vim.lsp.util.make_workspace_params()
  local fname = vim.api.nvim_buf_get_name(bufnr)
  params.changes = params.changes
    or {
      { uri = params.uri or vim.uri_from_fname(fname), type = params.type or change_type.Changed },
    }
  vim.lsp.buf_request(bufnr, "workspace/didChangeWatchedFiles", params, function(err, result, ctx)
    vim.defer_fn(function()
      if err then
        log("failed to workspace reloaded:" .. vim.inspect(err) .. vim.inspect(ctx) .. vim.inspect(result))
      else
        vim.notify("workspace reloaded")
      end
    end, 200)
  end)
end

vim.api.nvim_buf_create_user_command(bufnr, "GoModTidy", function()
  vim.notify("Running `go mod tidy`...")
  local uri = vim.uri_from_bufnr(bufnr)
  local arguments = { { URIs = { uri } } }
  vim.cmd.wall()
  vim.lsp.buf.execute_command({
    command = "gopls.tidy",
    arguments = arguments,
  })
  watchFileChanged()
end, { desc = "go mod tidy" })

vim.keymap.set("n", "<leader>gmt", vim.cmd.GoModTidy, {
  noremap = true,
  silent = true,
  buffer = bufnr,
  desc = "Run go mod tidy",
})
