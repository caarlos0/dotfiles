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

--- On attach for key maps.
---@param bufnr number Buffer number
M.on_attach = function(bufnr)
  local builtin = require("telescope.builtin")
  keymap("gd", builtin.lsp_definitions, bufnr)
  keymap("gr", function()
    vim.notify("use grr no")
  end, bufnr)
  keymap("<leader>ls", builtin.lsp_document_symbols, bufnr)
  keymap("<leader>lS", builtin.lsp_dynamic_workspace_symbols, bufnr)
  keymap("gs", function()
    vim.notify("use <ctrl>+s now")
  end, bufnr)
  keymap("gi", builtin.lsp_implementations, bufnr)
  keymap("gD", vim.lsp.buf.declaration, bufnr)
  keymap("K", vim.lsp.buf.hover, bufnr)
  keymap("<leader>D", builtin.lsp_type_definitions, bufnr)
  keymap("<leader>cl", vim.lsp.codelens.run, bufnr)
  keymap("<leader>rn", function()
    vim.notify("use grn now")
  end, bufnr)
  keymap("<leader>ca", function()
    vim.notify("use gra now")
  end, bufnr)
  keymap("<leader>gl", vim.diagnostic.open_float, bufnr)
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
