require("nvim-autopairs").setup({
  check_ts = true,
})

require("nvim-ts-autotag").setup()
require("nvim-surround").setup()
require("todo-comments").setup()

require("treesitter-context").setup({
  multiline_threshold = 1,
})

require("nvim-treesitter").install({
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
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
    if pcall(vim.treesitter.get_parser, ev.buf) then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require("nvim-treesitter-textobjects").setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})

local ts_select = require("nvim-treesitter-textobjects.select")
local ts_move = require("nvim-treesitter-textobjects.move")
local ts_swap = require("nvim-treesitter-textobjects.swap")

-- select
vim.keymap.set({ "x", "o" }, "af", function() ts_select.select_textobject("@function.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "if", function() ts_select.select_textobject("@function.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ac", function() ts_select.select_textobject("@conditional.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ic", function() ts_select.select_textobject("@conditional.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "aa", function() ts_select.select_textobject("@parameter.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ia", function() ts_select.select_textobject("@parameter.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "av", function() ts_select.select_textobject("@variable.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "iv", function() ts_select.select_textobject("@variable.inner", "textobjects") end)

-- move
vim.keymap.set({ "n", "x", "o" }, "]f", function() ts_move.goto_next_start("@function.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]c", function() ts_move.goto_next_start("@class.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]a", function() ts_move.goto_next_start("@parameter.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]F", function() ts_move.goto_next_end("@function.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]C", function() ts_move.goto_next_end("@class.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]A", function() ts_move.goto_next_end("@parameter.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[f", function() ts_move.goto_previous_start("@function.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[c", function() ts_move.goto_previous_start("@class.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[a", function() ts_move.goto_previous_start("@parameter.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[F", function() ts_move.goto_previous_end("@function.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[C", function() ts_move.goto_previous_end("@class.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[A", function() ts_move.goto_previous_end("@parameter.inner", "textobjects") end)

-- swap
vim.keymap.set("n", "<leader>a", function() ts_swap.swap_next("@parameter.inner") end)
vim.keymap.set("n", "<leader>A", function() ts_swap.swap_previous("@parameter.inner") end)
