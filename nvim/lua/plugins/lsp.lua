require("lsp_autocommands").setup()

local capabilities = require("blink.cmp").get_lsp_capabilities({
  workspace = {
    didChangeWatchedFiles = {
      dynamicRegistration = true, -- needs fswatch on linux
      relativePatternSupport = true,
    },
  },
}, true)

---@param client vim.lsp.Client LSP client
---@param bufnr number Buffer number
---@diagnostic disable: unused-local
local on_attach = function(client, bufnr)
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

  local fzf = function(action)
    return function()
      FzfLua["lsp_" .. action]()
    end
  end

  keymap("gd", fzf("definitions"))
  keymap("grr", fzf("references"))
  keymap("gO", fzf("document_symbols"))
  keymap("gri", fzf("implementations"))
  keymap("gD", vim.lsp.buf.declaration)
  keymap("K", vim.lsp.buf.hover)
  keymap("<leader>D", fzf("typedefs"))
  keymap("grl", vim.lsp.codelens.run)
  keymap("gl", vim.diagnostic.open_float)
  keymap("[d", function()
    vim.diagnostic.jump({ count = -1 })
    vim.cmd("norm zz")
  end)
  keymap("]d", function()
    vim.diagnostic.jump({ count = 1 })
    vim.cmd("norm zz")
  end)

  keymap("<leader>v", function()
    vim.cmd("vsplit | FzfLua lsp_definitions jump1=true")
    vim.cmd("norm zz")
  end)
end

local lspconfig = require("lspconfig")
require("lspconfig.ui.windows").default_options.border = "none"
lspconfig.gopls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = true,
        generate = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedvariable = true,
        unusedwrite = true,
        useany = true,
      },
      staticcheck = true,
      directoryFilters = { "-.git", "-node_modules" },
      semanticTokens = true,
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
})

lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    javascript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
    typescript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
})

for _, lsp in ipairs({
  "bashls",
  "clangd",
  "cssls",
  "dockerls",
  "jsonls",
  "rust_analyzer",
  "taplo",
  "templ",
  "terraformls",
  "tflint",
  "zls",
}) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

for _, lsp in ipairs({ "html", "htmx" }) do
  lspconfig[lsp].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "html", "templ" },
  })
end

lspconfig.tailwindcss.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "html", "templ", "javascript" },
  settings = {
    tailwindCSS = {
      includeLanguages = {
        templ = "html",
      },
    },
  },
})

lspconfig.yamlls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    yaml = {
      schemaStore = {
        url = "https://www.schemastore.org/api/json/catalog.json",
        enable = true,
      },
    },
  },
})

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";", {})
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      telemetry = { enable = false },
      hint = {
        enable = true,
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})
