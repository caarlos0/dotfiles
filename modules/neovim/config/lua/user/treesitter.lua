require("treesitter-context").setup({
  multiline_threshold = 1,
})

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  endwise = {
    enable = true,
  },
  autopairs = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>", -- maps in normal mode to init the node/scope selection with ctrl+space
      node_incremental = "<C-space>", -- increment to the upper named parent
      node_decremental = "<bs>", -- decrement to the previous node
      scope_incremental = "<noop>", -- increment to the upper scope (as defined in locals.scm)
    },
  },
  auto_install = false,
})
