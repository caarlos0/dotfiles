require("neogen").setup({
  snippet_engine = "nvim",
})

vim.keymap.set("n", "gco", function()
  require("neogen").generate()
end, { desc = "Generate docstring" })
