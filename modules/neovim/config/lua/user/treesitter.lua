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
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
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
  textobjects = {
    enable = true,
    lookahead = true,
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]a"] = "@parameter.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
        ["]A"] = "@parameter.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[a"] = "@parameter.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
        ["[A"] = "@parameter.outer",
      },
    },
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",

        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",

        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",

        ["av"] = "@variable.outer",
        ["iv"] = "@variable.inner",
      },
    },
  },
})
