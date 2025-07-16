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

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-github.nvim",
  },
  opts = {
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
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("gh")
    telescope.load_extension("harpoon")
  end,
  keys = function()
    local function ivy(opts)
      return require("telescope.themes").get_ivy(opts)
    end
    return {
      {
        "<C-p>",
        function()
          require("telescope.builtin").find_files(ivy({
            find_command = {
              "fd",
              "--type",
              "f",
              "--strip-cwd-prefix",
              "--hidden",
            },
          }))
        end,
      },
      {
        "<leader>of",
        function()
          require("telescope.builtin").oldfiles({ only_cwd = true })
        end,
      },
      {
        "<leader>lg",
        function()
          require("config.telescope-multi")()
        end,
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers(ivy())
        end,
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags(ivy())
        end,
      },
      {
        "<leader>fc",
        function()
          require("telescope.builtin").commands(ivy())
        end,
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").resume(ivy())
        end,
      },
      {
        "<leader>fq",
        function()
          require("telescope.builtin").quickfix(ivy())
        end,
      },
      {
        "<leader>/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find(ivy())
        end,
      },
      {
        "<leader>xx",
        function()
          require("telescope.builtin").diagnostics(ivy())
        end,
      },
      {
        "<leader>ghi",
        function()
          require("telescope").extensions.gh.issues(ivy())
        end,
      },
      {
        "<leader>fj",
        function()
          require("telescope").extensions.harpoon.marks(ivy())
        end,
      },
    }
  end,
}
