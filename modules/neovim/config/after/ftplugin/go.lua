---@diagnostic disable: undefined-global
local bufnr = vim.api.nvim_get_current_buf()

vim.opt_local.formatoptions:append("jo")
vim.opt_local.makeprg = "go build ./..."
vim.opt_local.errorformat = "%A%f:%l:%c: %m,%-G%.%#"

--- Add a normal keymap.
---@param lhs string Keymap
---@param rhs function Action
local keymap = function(lhs, rhs)
  vim.keymap.set("n", lhs, rhs, {
    noremap = true,
    silent = true,
    buffer = bufnr,
  })
end

vim.api.nvim_buf_create_user_command(bufnr, "GoModTidy", function()
  vim.notify("Running go mod tidy...")
  local uri = vim.uri_from_bufnr(bufnr)
  local arguments = { { URIs = { uri } } }
  vim.cmd([[ noautocmd wall ]])
  vim.lsp.buf.execute_command({
    command = "gopls.tidy",
    arguments = arguments,
  })
end, { desc = "go mod tidy" })

local function copen()
  if vim.fn.getqflist({ size = 0 }).size > 1 then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end

keymap("<F2>", function()
  vim.notify("Running make...")
  vim.cmd("make")
  copen()
end)

keymap("<F3>", function()
  vim.notify("Running golangci-lint...")
  local output = vim.fn.system("golangci-lint run --max-issues-per-linter=0 --max-same-issues=0")
  if output and output ~= "" then
    vim.fn.setqflist({}, " ", { lines = vim.split(output, "\n") })
    copen()
  end
end)

keymap("<F4>", vim.cmd.GoModTidy)
