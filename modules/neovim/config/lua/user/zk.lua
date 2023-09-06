require("zk").setup({
  picker = "telescope",

  lsp = {
    config = {
      cmd = { "zk", "lsp" },
      name = "zk",
    },

    auto_attach = {
      enabled = true,
      filetypes = { "markdown" },
    },
  },
})

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
keymap("n", "<leader>n", ":ZkNew<CR>", opts)
keymap("n", "<c-p>", ":ZkNotes<CR>", opts)
keymap("n", "<C-i>", ":ZkInsertLink<CR>", opts)
keymap("n", "<leader>lt", ":ZkTags<CR>", opts)
keymap("n", "<leader>ot", ":e `zk jp`<CR>", opts)
