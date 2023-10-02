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
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    conform.format({ bufnr = args.buf })
  end,
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
