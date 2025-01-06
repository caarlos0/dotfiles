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
  keymap("<leader>ls", telescope("document_symbols"), bufnr)
  keymap("<leader>lS", telescope("workspace_symbols"), bufnr)
  keymap("<C-s>", vim.lsp.buf.signature_help, bufnr)
  ikeymap("<C-s>", vim.lsp.buf.signature_help, bufnr)
  keymap("gi", telescope("implementations"), bufnr)
  keymap("gD", vim.lsp.buf.declaration, bufnr)
  keymap("K", vim.lsp.buf.hover, bufnr)
  keymap("<leader>D", telescope("type_definitions"), bufnr)
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
