local ms = require("vim.lsp.protocol").Methods
local group = vim.api.nvim_create_augroup("LSP", { clear = true })

-- Format code and organize imports (if supported) (async).
--
---@async
---@param client vim.lsp.Client
---@param bufnr number
---@type fun(client: vim.lsp.Client, bufnr: number)
local organize_imports = function(client, bufnr)
  ---@type lsp.Handler
  ---@diagnostic disable-next-line: unused-local
  local handler = function(err, result, context, config)
    if err then
      -- ignore errors
      return
    end
    for _, r in pairs(result or {}) do
      if r.edit then
        local enc = client.offset_encoding or "utf-16"
        vim.lsp.util.apply_workspace_edit(r.edit, enc)
      elseif r.command and r.command.command then
        client:exec_cmd(r.command, { bufnr = bufnr })
      end
    end
    vim.cmd([[noautocmd write]])
  end

  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_range_params(win, client.offset_encoding or "utf-16")
  params.context = { only = { "source.organizeImports" } }
  client:request(ms.textDocument_codeAction, params, handler, bufnr)
end

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
---@param apply fun(client: vim.lsp.Client, bufnr: number)
---@param filter? fun(client: vim.lsp.Client): boolean?
local on_clients = function(bufnr, method, apply, filter)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = method })
  if not filter then
    filter = function()
      return true
    end
  end
  for _, client in ipairs(clients) do
    if filter(client) then
      apply(client, bufnr)
    end
  end
end

local M = {}

M.setup = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
        return
      end
      if client:supports_method(ms.textDocument_codeLens, vim.api.nvim_get_current_buf()) then
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
      if client:supports_method(ms.textDocument_codeLens, vim.api.nvim_get_current_buf()) then
        vim.lsp.codelens.clear(client.id)
      end
    end,
    group = group,
  })

  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = function()
      ---@type fun(client: vim.lsp.Client, bufnr: number)
      local format = function(client, bufnr)
        if client.server_capabilities.documentFormattingProvider then
          vim.lsp.buf.format({
            bufnr = bufnr,
            -- for some reason gopls started timing out on big projects recently...
            timeout_ms = 5000,
            id = client.id,
          })
        end
      end
      on_clients(vim.api.nvim_get_current_buf(), ms.textDocument_codeAction, format)
    end,
    group = group,
  })

  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      ---@type fun(client: vim.lsp.Client): boolean?
      local filter = function(client)
        -- lua_ls freaks out when you ask it to organize imports.
        return client.name ~= "lua_ls"
      end
      on_clients(bufnr, ms.textDocument_codeAction, organize_imports, filter)
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
