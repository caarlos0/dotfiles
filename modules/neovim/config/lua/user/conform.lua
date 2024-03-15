local conform = require("conform")
conform.setup({
  formatters_by_ft = {
    css = { "prettier" },
    fish = { "fish_indent" },
    go = { "gofumpt" },
    html = { "prettier" },
    javascript = { "prettier" },
    json = { "jq" },
    lua = { "stylua" },
    markdown = { "prettier" },
    nix = { "nixpkgs_fmt" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    sql = { "pg_format", "sql_formatter" },
    tf = { "terraform_fmt" },
    yaml = { "prettier" },
    zig = { "zigfmt" },
    ["_"] = { "trim_whitespace", "trim_newlines" },
  },
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 500,
  },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
