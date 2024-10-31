local bg0 = "#1b1b1b"
require("gruvbox").setup({
  contrast = "hard",
  overrides = {
    GruvboxBg0 = { fg = bg0 },
    SignColumn = { link = "GruvboxBg0" },
    Normal = { bg = bg0 },
  },
})
vim.cmd("colorscheme gruvbox")
