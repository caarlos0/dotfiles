require("zk").setup({
  picker = "telescope",

  lsp = {
    config = {
      cmd = { "zk", "lsp" },
      name = "zk",
    },

    auto_attach = {
      enabled = true,
      filetypes = { "markdown" },
    },
  },
})
