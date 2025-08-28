require("ibl").setup({
  indent = { char = "│" },
  exclude = { filetypes = { "help" } },
  scope = { enabled = false },
})

require("nvim-autopairs").setup({
  check_ts = true,
})

require("nvim-ts-autotag").setup()
require("nvim-surround").setup()
require("todo-comments").setup()

require("treesitter-context").setup({
  multiline_threshold = 1,
})

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
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
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      node_decremental = "<bs>",
      scope_incremental = "<noop>",
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
})
