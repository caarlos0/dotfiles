local M = {}

--- Add a normal keymap.
---@param lhs string Keymap
---@param rhs function Action
---@param bufnr number Buffer number
local keymap = function(lhs, rhs, bufnr)
  vim.keymap.set("n", lhs, rhs, {
    noremap = true,
    silent = true,
    buffer = bufnr,
  })
end

local telescope = function(action)
  return function()
    local ivy = require("telescope.themes").get_ivy()
    require("telescope.builtin")["lsp_" .. action](ivy)
  end
end

--- On attach for key maps.
---@param bufnr number Buffer number
M.on_attach = function(bufnr)
  keymap("gd", telescope("definitions"), bufnr)
  keymap("grr", telescope("references"), bufnr)
  keymap("gO", telescope("document_symbols"), bufnr)
  keymap("gri", telescope("implementations"), bufnr)
  keymap("gD", vim.lsp.buf.declaration, bufnr)
  keymap("K", vim.lsp.buf.hover, bufnr)
  keymap("<leader>D", telescope("type_definitions"), bufnr)
  keymap("grl", vim.lsp.codelens.run, bufnr)
  keymap("gl", vim.diagnostic.open_float, bufnr)
  keymap("[d", function()
    vim.diagnostic.jump({ count = -1 })
    vim.cmd("norm zz")
  end, bufnr)
  keymap("]d", function()
    vim.diagnostic.jump({ count = 1 })
    vim.cmd("norm zz")
  end, bufnr)

  keymap("<leader>v", function()
    vim.cmd("vsplit | lua vim.lsp.buf.definition()")
    vim.cmd("norm zz")
  end, bufnr)
end

return M
