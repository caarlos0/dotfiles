return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = {},
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        automatic_enable = false,
        ensure_installed = {
          "bashls",
          "clangd",
          "cssls",
          "dockerls",
          "gopls",
          "html",
          "htmx",
          "jsonls",
          "lua_ls",
          "rust_analyzer",
          "taplo",
          "templ",
          "tailwindcss",
          "terraformls",
          "tflint",
          "ts_ls",
          "yamlls",
          "zls",
        },
      },
    },
  },
  config = function()
    require("mason").setup()
    local keymaps = require("lsp_keymaps")
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
      keymaps.on_attach(bufnr)
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
        },
      },
    })

    local float_config = {
      focusable = true,
      style = "minimal",
      border = "none",
      source = "if_many",
    }

    -- setup diagnostics
    vim.diagnostic.config({
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = float_config,
    })

    vim.lsp.buf.hover(float_config)
    vim.lsp.buf.signature_help(float_config)
    vim.highlight.priorities.semantic_tokens = 95

    -- set up diagnostic signs
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "󰌶",
        },
      },
    })
  end,
}
