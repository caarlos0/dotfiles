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

M.setup = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
      if vim.lsp.inlay_hint.is_enabled(0) then
        return
      end
      local clients = vim.lsp.get_clients({ bufnr = 0, method = ms.textDocument_inlayHint })
      if #clients == 0 then
        return
      end
      vim.lsp.inlay_hint.enable(0, true)
    end,
  })
  vim.api.nvim_create_autocmd("LspDetach", {
    callback = function()
      local clients = vim.lsp.get_clients({ bufnr = 0, method = ms.textDocument_codeLens })
      for _, client in ipairs(clients) do
        vim.lsp.codelens.clear(client.id, 0)
      end
    end,
    group = group,
  })

  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = function()
      local clients = vim.lsp.get_clients({ bufnr = 0, method = ms.textDocument_codeAction })
      for _, client in ipairs(clients) do
        if client.name ~= "lua_ls" then
          organize_imports(client, 0, 1500)
        end
      end
    end,
    group = group,
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    callback = function()
      local clients = vim.lsp.get_clients({ bufnr = 0, method = ms.textDocument_codeLens })
      if #clients == 0 then
        return
      end
      vim.lsp.codelens.refresh({ bufnr = 0 })
    end,
    group = group,
  })

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    callback = function()
      local clients = vim.lsp.get_clients({ bufnr = 0, method = ms.textDocument_documentHighlight })
      if #clients == 0 then
        return
      end
      vim.lsp.buf.document_highlight()
    end,
    group = group,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved" }, {
    callback = function()
      local clients = vim.lsp.get_clients({ bufnr = 0, method = ms.textDocument_documentHighlight })
      if #clients == 0 then
        return
      end
      vim.lsp.buf.clear_references()
    end,
    group = group,
  })
end

return M
