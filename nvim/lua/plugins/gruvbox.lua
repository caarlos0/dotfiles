local bg0 = "#1b1b1b"
require("gruvbox").setup({
  contrast = "hard",
  overrides = {
    GruvboxBg0 = { fg = bg0 },
    SignColumn = { bg = bg0 },
    GruvboxRedSign = { bg = bg0 },
    GruvboxYellowSign = { bg = bg0 },
    GruvboxGreenSign = { bg = bg0 },
    GruvboxAquaSign = { bg = bg0 },
    GruvboxOrangeSign = { bg = bg0 },
    GruvboxPurpleSign = { bg = bg0 },
    GruvboxBlueSign = { bg = bg0 },
    Normal = { bg = bg0 },
  },
})
vim.cmd("colorscheme gruvbox")
-- https://github.com/ellisonleao/gruvbox.nvim/commit/c74e6e523c4827b67af2cb02b636e22dc35fdf70
-- https://github.com/nvim-lualine/lualine.nvim/issues/1312
vim.api.nvim_set_hl(0, "StatusLine", { reverse = false })
vim.api.nvim_set_hl(0, "StatusLineNC", { reverse = false })
