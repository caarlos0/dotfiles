require("lsp_autocommands").setup()
local severity = vim.diagnostic.severity

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

  local telescope = function(action)
    return function()
      local ivy = require("telescope.themes").get_ivy()
      require("telescope.builtin")["lsp_" .. action](ivy)
    end
  end

  keymap("gd", telescope("definitions"))
  keymap("grr", telescope("references"))
  keymap("gO", telescope("document_symbols"))
  keymap("gri", telescope("implementations"))
  keymap("gD", vim.lsp.buf.declaration)
  keymap("K", vim.lsp.buf.hover)
  keymap("<leader>D", telescope("type_definitions"))
  keymap("grl", vim.lsp.codelens.run)
  keymap("gl", vim.diagnostic.open_float)
  keymap("[d", function()
    vim.diagnostic.jump({
      severity = severity.ERROR,
      count = -1,
    })
    vim.cmd("norm zz")
  end)
  keymap("]d", function()
    vim.diagnostic.jump({
      severity = severity.ERROR,
      count = 1,
    })
    vim.cmd("norm zz")
  end)

  keymap("<leader>v", function()
    vim.cmd("vsplit | lua vim.lsp.buf.definition()")
    vim.cmd("norm zz")
  end)
end

vim.lsp.config("gopls", {
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
vim.lsp.enable("gopls")

vim.lsp.config("ts_ls", {
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
vim.lsp.enable("ts_ls")

for _, lsp in ipairs({
  "bashls",
  "clangd",
  "cssls",
  "jsonls",
  "pylsp",
  "rust_analyzer",
  "taplo",
  "templ",
  "terraformls",
  "tflint",
  "zls",
}) do
  vim.lsp.config(lsp, {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable(lsp)
end

for _, lsp in ipairs({ "html", "htmx" }) do
  vim.lsp.config(lsp, {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "html", "templ" },
  })
  vim.lsp.enable(lsp)
end

vim.lsp.config("tailwindcss", {
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
vim.lsp.enable("tailwindcss")

vim.lsp.config("yamlls", {
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
vim.lsp.enable("yamlls")

vim.lsp.config("lua_ls", {
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
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
})
vim.lsp.enable("lua_ls")
