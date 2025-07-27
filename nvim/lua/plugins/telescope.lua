local select_one_or_multi = function(prompt_bufnr)
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require("telescope.actions").close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        vim.cmd(string.format("%s %s", "edit", j.path))
      end
    end
  else
    require("telescope.actions").select_default(prompt_bufnr)
  end
end

local telescope = require("telescope")
telescope.setup({
  defaults = {
    pickers = {
      find_files = {
        theme = "ivy",
      },
    },
    mappings = {
      i = {
        ["<CR>"] = select_one_or_multi,
        ["<C-y>"] = select_one_or_multi,
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

local opts = { noremap = true, silent = true }
local builtin = require("telescope.builtin")

local function ivy(opts)
  return require("telescope.themes").get_ivy(opts)
end

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
  builtin.oldfiles({
    only_cwd = true,
  })
end, opts)

vim.keymap.set("n", "<leader>lg", require("config.telescope-multi"), opts)

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

vim.keymap.set("n", "<leader>xx", function()
  builtin.diagnostics(ivy())
end, opts)

vim.keymap.set("n", "<leader>ghi", function()
  telescope.extensions.gh.issues(ivy())
end, opts)

vim.keymap.set("n", "<leader>fj", function()
  telescope.extensions.harpoon.marks(ivy())
end, opts)
