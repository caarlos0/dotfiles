require("catppuccin").setup({
  flavour = "mocha",
  highlight_overrides = {
    mocha = function(C)
      return {
        TabLineSel = { bg = C.pink },
        TelescopeBorder = { link = "FloatBorder" },
      }
    end,
  },
  integrations = {
    cmp = true,
    dap = {
      enabled = true,
      enable_ui = true,
    },
    gitsigns = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = true,
    },
    markdown = true,
    native_lsp = {
      enabled = true,
    },
    neogit = true,
    neotest = true,
    notify = true,
    telescope = true,
    harpoon = true,
    treesitter = true,
    treesitter_context = true,
  },
})

vim.cmd.colorscheme("catppuccin")
