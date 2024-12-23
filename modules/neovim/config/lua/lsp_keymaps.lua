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

--- Add an insert keymap.
---@param lhs string Keymap
---@param rhs function Action
---@param bufnr number Buffer number
local ikeymap = function(lhs, rhs, bufnr)
  vim.keymap.set("i", lhs, rhs, {
    noremap = true,
    silent = true,
    buffer = bufnr,
  })
end

local is_v10 = vim.fn.has("nvim-0.10") == 1

--- On attach for key maps.
---@param bufnr number Buffer number
M.on_attach = function(bufnr)
  keymap("gd", vim.lsp.buf.definition, bufnr)
  keymap("grr", vim.lsp.buf.references, bufnr)
  keymap("<leader>ls", vim.lsp.buf.document_symbol, bufnr)
  keymap("<leader>lS", vim.lsp.buf.workspace_symbol, bufnr)
  keymap("<C-s>", vim.lsp.buf.signature_help, bufnr)
  ikeymap("<C-s>", vim.lsp.buf.signature_help, bufnr)
  keymap("gi", vim.lsp.buf.implementation, bufnr)
  keymap("gD", vim.lsp.buf.declaration, bufnr)
  keymap("K", vim.lsp.buf.hover, bufnr)
  keymap("<leader>D", vim.lsp.buf.type_definition, bufnr)
  keymap("grn", vim.lsp.buf.rename, bufnr)
  keymap("gra", vim.lsp.buf.code_action, bufnr)
  keymap("grl", vim.lsp.codelens.run, bufnr)
  keymap("gl", vim.diagnostic.open_float, bufnr)
  keymap("[d", function()
    if is_v10 then
      vim.diagnostic.goto_prev()
    else
      vim.diagnostic.jump({ count = -1 })
    end
    vim.cmd("norm zz")
  end, bufnr)
  keymap("]d", function()
    if is_v10 then
      vim.diagnostic.goto_next()
    else
      vim.diagnostic.jump({ count = 1 })
    end
    vim.cmd("norm zz")
  end, bufnr)

  keymap("<leader>v", function()
    vim.cmd("vsplit | lua vim.lsp.buf.definition()")
    vim.cmd("norm zz")
  end, bufnr)
end

return M
