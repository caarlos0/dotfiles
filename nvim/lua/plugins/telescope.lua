local telescope = require("telescope")
telescope.setup({
  defaults = {
    pickers = {
      find_files = {
        theme = "ivy",
      },
    },
    prompt_prefix = "   ",
    selection_caret = " ❯ ",
    entry_prefix = "   ",
    multi_icon = "+ ",
    path_display = { "filename_first" },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--sort=path",
    },
  },
})
telescope.load_extension("gh")

local function ivy(opts)
  return require("telescope.themes").get_ivy(opts)
end

local builtin = require("telescope.builtin")
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-p>", function()
  builtin.find_files(ivy({
    find_command = {
      "fd",
      "--type",
      "f",
      "--strip-cwd-prefix",
      "--hidden",
    },
  }))
end, opts)

vim.keymap.set("n", "<leader>of", function()
  builtin.oldfiles(ivy({
    only_cwd = true,
  }))
end, opts)

vim.keymap.set("n", "<leader>lg", function()
  builtin.live_grep(ivy())
end, opts)

vim.keymap.set("n", "<leader>fb", function()
  builtin.buffers(ivy())
end, opts)

vim.keymap.set("n", "<leader>fh", function()
  builtin.help_tags(ivy())
end, opts)

vim.keymap.set("n", "<leader>fc", function()
  builtin.commands(ivy())
end, opts)

vim.keymap.set("n", "<leader>fr", function()
  builtin.resume(ivy())
end, opts)

vim.keymap.set("n", "<leader>fq", function()
  builtin.quickfix(ivy())
end, opts)

vim.keymap.set("n", "<leader>/", function()
  builtin.current_buffer_fuzzy_find(ivy())
end, opts)

vim.keymap.set("n", "<leader>ghi", function()
  telescope.extensions.gh.issues(ivy())
end, opts)
