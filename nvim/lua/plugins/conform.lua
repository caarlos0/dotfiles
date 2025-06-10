return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      css = { "prettier" },
      fish = { "fish_indent" },
      html = { "prettier" },
      javascript = { "prettier" },
      json = { "jq" },
      lua = { "stylua" },
      markdown = { "prettier" },
      nix = { "nixfmt" },
      sh = { "shfmt" },
      sql = { "pg_format", "sql_formatter" },
      templ = { "templ" },
      tf = { "terraform_fmt" },
      yaml = { "prettier" },
      ["_"] = { "trim_whitespace", "trim_newlines" },
      -- let only the lsp take care of these.
      go = {},
      rust = {},
      zig ={},
    },
    format_after_save = {
      lsp_fallback = true,
    },
  }
}
