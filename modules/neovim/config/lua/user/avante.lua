require("avante_lib").load()
require("avante").setup({
  hints = { enabled = false },
  provider = "claude37",
  -- cursor_applying_provider = "groq",
  -- behaviour = {
  --   enable_cursor_planning_mode = true,
  -- },
  vendors = {
    claude37 = {
      __inherited_from = "claude",
      model = "claude-3-7-sonnet-20250219",
    },
    -- groq = {
    --   __inherited_from = "openai",
    --   api_key_name = "GROQ_API_KEY",
    --   endpoint = "https://api.groq.com/openai/v1/",
    --   model = "llama-3.3-70b-versatile",
    --   max_tokens = 32768,
    -- },
  },
})

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
local avante = require("avante.api")
keymap("n", "<leader>aa", function()
  avante.ask()
end, opts)
keymap("n", "<leader>ar", function()
  avante.refresh()
end, opts)
keymap("v", "<leader>ae", function()
  avante.edit()
end, opts)
