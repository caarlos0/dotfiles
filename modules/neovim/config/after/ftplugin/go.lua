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

local function cclear()
  vim.fn.setqflist({}, "r")
end

keymap("<F1>", function()
  vim.notify("Building...")
  cclear()
  vim.schedule(function()
    vim.cmd("make")
    copen()
  end)
end)

keymap("<F2>", function()
  vim.notify("Installing...")
  vim.fn.jobstart("go install ./...")
end)

keymap("<F6>", vim.cmd.GoModTidy)

keymap("<F7>", function()
  vim.notify("Running golangci-lint...")
  cclear()
  vim.fn.jobstart("golangci-lint run --max-issues-per-linter=0 --max-same-issues=0", {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 1 then
        vim.schedule(function()
          vim.fn.setqflist({}, " ", { lines = data })
          copen()
        end)
      end
    end,
  })
end)
