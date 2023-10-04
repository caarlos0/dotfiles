local group = vim.api.nvim_create_augroup("LSP", { clear = true })

-- Format code and organize imports (if supported).
--
---@param client lsp.Client Client
---@param bufnr number Buffer number
---@param timeoutms number timeout in ms
local organize_imports = function(client, bufnr, timeoutms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  -- TODO: PR neovim allowing to filter buf_request_sync
  local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, timeoutms)
  for cid, res in pairs(result or {}) do
    if cid == client.id then
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        elseif r.command and r.command.command then
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end
end

--- Checks if the given client is alive.
--
---@param client table Client object
---@return boolean
local is_alive = function(client)
  if client == nil then
    return false
  end
  if not client.initialized then
    return false
  end
  if client.is_stopped() then
    return false
  end
  return true
end

local M = {}

--- On attach adds all the autocommands we might need when attaching a lsp server to a buffer.
--
---@param client table Client object
---@param bufnr number
M.on_attach = function(client, bufnr)
  if client.server_capabilities.codeActionProvider and client.name ~= "lua_ls" then
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      buffer = bufnr,
      callback = function()
        organize_imports(client, bufnr, 1500)
      end,
      group = group,
    })
  end

  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = bufnr,
      callback = function()
        if is_alive(client) then
          vim.lsp.codelens.refresh()
        end
      end,
      group = group,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      buffer = bufnr,
      callback = function()
        if is_alive(client) then
          vim.lsp.codelens.clear()
        end
      end,
      group = group,
    })
  end

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      callback = function()
        if is_alive(client) then
          vim.lsp.buf.document_highlight()
        end
      end,
      group = group,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      buffer = bufnr,
      callback = function()
        if is_alive(client) then
          vim.lsp.buf.clear_references()
        end
      end,
      group = group,
    })
  end
end

return M
