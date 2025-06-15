return {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- last release is way too old and doesn't work on Windows
  build = ":TSUpdate",
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
    "RRethy/nvim-treesitter-endwise",
    "windwp/nvim-autopairs",
    "folke/todo-comments.nvim",
    "folke/ts-comments.nvim",
    "lukas-reineke/indent-blankline.nvim",
    "wansmer/treesj",
  },
  keys = {
    { "<c-space>", desc = "Increment Selection" },
    { "<bs>",      desc = "Decrement Selection", mode = "x" },
    {
      "<leader>gS",
      function()
        require("treesj").toggle()
      end,
      desc = "Toggle split/join",
    },
  },
  ---@type TSConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    ensure_installed = {
      "arduino",
      "awk",
      "bash",
      "cpp",
      "css",
      "csv",
      "diff",
      "dockerfile",
      "fish",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "graphql",
      "hcl",
      "html",
      "http",
      "http",
      "ini",
      "javascript",
      "jq",
      "json",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      "mermaid",
      "python",
      "query",
      "regex",
      "ruby",
      "scss",
      "sql",
      "ssh_config",
      "templ",
      "terraform",
      "toml",
      "vhs",
      "vim",
      "vimdoc",
      "yaml",
      "zig",
    },

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
        init_selection = "<C-space>",   -- maps in normal mode to init the node/scope selection with ctrl+space
        node_incremental = "<C-space>", -- increment to the upper named parent
        node_decremental = "<bs>",      -- decrement to the previous node
        scope_incremental = "<noop>",   -- increment to the upper scope (as defined in locals.scm)
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
          ["]f"] = "@function.inner",
          ["]c"] = "@class.inner",
          ["]a"] = "@parameter.inner",
        },
        goto_next_end = {
          ["]F"] = "@function.inner",
          ["]C"] = "@class.inner",
          ["]A"] = "@parameter.inner",
        },
        goto_previous_start = {
          ["[f"] = "@function.inner",
          ["[c"] = "@class.inner",
          ["[a"] = "@parameter.inner",
        },
        goto_previous_end = {
          ["[F"] = "@function.inner",
          ["[C"] = "@class.inner",
          ["[A"] = "@parameter.inner",
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
  },
  ---@param opts TSConfig
  config = function(_, opts)
    require("todo-comments").setup()
    require("ts-comments").setup({
      lang = {
        gomod = "// %s",
        gowork = "// %s",
      },
    })
    require("treesitter-context").setup({
      multiline_threshold = 1,
    })
    require("nvim-autopairs").setup({ check_ts = true })
    require("ibl").setup({
      indent = { char = "│" },
      exclude = { filetypes = { "help" } },
      scope = { enabled = false },
    })
    require("treesj").setup()
    require("nvim-treesitter.configs").setup(opts)
  end,
}
