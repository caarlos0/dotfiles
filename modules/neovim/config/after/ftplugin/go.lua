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

-- get the gopls server from the given buffer, or nil.
---@param bufnr integer
---@return vim.lsp.Client
local get_gopls = function(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, c in ipairs(clients) do
    if c.name == "gopls" then
      return c
    end
  end
  vim.notify("gopls not found", vim.log.levels.WARN)
  return nil
end

-- based on https://github.com/ray-x/go.nvim/blob/c6d5ca26377d01c4de1f7bff1cd62c8b43baa6bc/lua/go/gopls.lua#L57
vim.api.nvim_buf_create_user_command(bufnr, "GoModTidy", function()
  vim.notify("Running go mod tidy...")
  local gopls = get_gopls(bufnr)
  if gopls == nil then
    return
  end

  vim.cmd([[ noautocmd wall ]])

  local uri = vim.uri_from_bufnr(bufnr)
  local arguments = { { URIs = { uri } } }

  gopls.request_sync("workspace/executeCommand", {
    command = "gopls.tidy",
    arguments = arguments,
  }, 2000, bufnr)
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
