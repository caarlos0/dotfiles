local ms = require("vim.lsp.protocol").Methods
local group = vim.api.nvim_create_augroup("LSP", { clear = true })

-- Format code and organize imports (if supported).
--
---@param client vim.lsp.Client Client
---@param bufnr number Buffer number
---@param timeoutms number timeout in ms
local organize_imports = function(client, bufnr, timeoutms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  -- TODO: PR neovim allowing to filter buf_request_sync
  local result = vim.lsp.buf_request_sync(bufnr, ms.textDocument_codeAction, params, timeoutms)
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

local M = {}

-- Checks if the given buffer has any lsp clients that support the given method.
--
---@param bufnr number Buffer number
---@param method string Method name
---@return boolean
local has_clients_with_method = function(bufnr, method)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = method })
  return #clients > 0
end

---@param bufnr number
---@param method string
---@param fn function(client)
local on_clients = function(bufnr, method, fn)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = method })
  for _, client in ipairs(clients) do
    fn(client)
  end
end

M.setup = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
        return
      end
      if client.supports_method(ms.textDocument_codeLens) then
        vim.lsp.inlay_hint.enable(true)
      end
    end,
  })
  vim.api.nvim_create_autocmd("LspDetach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
        return
      end
      if client.supports_method(ms.textDocument_codeLens) then
        vim.lsp.codelens.clear(client.id)
      end
    end,
    group = group,
  })

  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = function()
      on_clients(0, ms.textDocument_codeAction, function(client)
        if client.name ~= "lua_ls" then
          organize_imports(client, 0, 1500)
        end
      end)
    end,
    group = group,
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    callback = function()
      if has_clients_with_method(0, ms.textDocument_codeLens) then
        vim.lsp.codelens.refresh({ bufnr = 0 })
      end
    end,
    group = group,
  })

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    callback = function()
      if has_clients_with_method(0, ms.textDocument_documentHighlight) then
        vim.lsp.buf.document_highlight()
      end
    end,
    group = group,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved" }, {
    callback = function()
      if has_clients_with_method(0, ms.textDocument_documentHighlight) then
        vim.lsp.buf.clear_references()
      end
    end,
    group = group,
  })
end

return M
