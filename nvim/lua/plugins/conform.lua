return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      css = { "prettier" },
      fish = { "fish_indent" },
      html = { "prettier" },
      javascript = { "prettier" },
      json = { "jq" },
      lua = { "stylua" },
      markdown = { "prettier" },
      sh = { "shfmt" },
      sql = { "pg_format", "sql_formatter" },
      templ = { "templ" },
      tf = { "terraform_fmt" },
      yaml = { "prettier" },
      ["_"] = { "trim_whitespace", "trim_newlines" },
      -- let only the lsp take care of these.
      go = {},
      rust = {},
      zig = {},
    },
    format_after_save = {
      lsp_fallback = true,
    },
  },
  dependencies = {
    { "mason-org/mason.nvim" },
    {
      "LittleEndianRoot/mason-conform",
      opts = {
        automatic_installation = false,
        ensure_installed = {
          "prettier",
          "stylua",
          "shfmt",
        },
      },
    },
  },
}
