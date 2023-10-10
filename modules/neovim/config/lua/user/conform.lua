local prettier = { { "prettierd", "prettier" } }
local conform = require("conform")
conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = prettier,
    markdown = prettier,
    html = prettier,
    css = prettier,
    nix = { "nixpkgs_fmt" },
    go = { "gofumpt" },
    fish = { "fish_indent" },
    json = { "jq" },
    rust = { "rustfmt" },
    tf = { "terraform_fmt" },
    sql = { "pg_format", "sql_formatter" },
    ["_"] = { "trim_whitespace" },
  },
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 500,
  },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
