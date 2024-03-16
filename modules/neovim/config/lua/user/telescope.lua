local telescope = require("telescope")

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

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<CR>"] = select_one_or_multi,
      },
    },
    prompt_prefix = "   ",
    selection_caret = " ❯ ",
    entry_prefix = "   ",
    multi_icon = "+ ",
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob=!.git",
    },
  },
})

telescope.load_extension("gh")
telescope.load_extension("harpoon")
telescope.load_extension("dap")

local opts = { noremap = true, silent = true }
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", function()
  builtin.find_files({
    find_command = { "rg", "--hidden", "--files", "--smart-case", "--glob=!.git" },
  })
end, opts)
vim.keymap.set("n", "<leader>of", function()
  builtin.oldfiles({
    only_cwd = true,
  })
end, opts)
vim.keymap.set("n", "<leader>lg", builtin.live_grep, opts)
vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)
vim.keymap.set("n", "<leader>fh", builtin.help_tags, opts)
vim.keymap.set("n", "<leader>fc", builtin.commands, opts)
vim.keymap.set("n", "<leader>fr", builtin.resume, opts)
vim.keymap.set("n", "<leader>fq", builtin.quickfix, opts)
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, opts)
vim.keymap.set("n", "<leader>xx", builtin.diagnostics, opts)
vim.keymap.set("n", "<leader>ghi", telescope.extensions.gh.issues, opts)
vim.keymap.set("n", "<leader>fj", telescope.extensions.harpoon.marks, opts)
