local neotest = require("neotest")

vim.keymap.set("n", "<leader>ttn", function()
  neotest.run.run()
end, {
  noremap = true,
  silent = true,
  desc = "Test nearest",
})

vim.keymap.set("n", "<leader>ttf", function()
  neotest.run.run(vim.fn.expand("%"))
end, {
  noremap = true,
  silent = true,
  desc = "Test file",
})

vim.keymap.set("n", "<leader>tts", function()
  neotest.run.run(vim.fn.getcwd())
end, {
  noremap = true,
  silent = true,
  desc = "Test Suite",
})

vim.keymap.set("n", "<leader>ttl", function()
  neotest.run.run_last()
end, {
  noremap = true,
  silent = true,
  desc = "Test latest",
})

vim.keymap.set("n", "<leader>tts", function()
  neotest.summary.toggle()
end, {
  noremap = true,
  silent = true,
  desc = "Toggle test summary",
})

vim.keymap.set("n", "<leader>tto", function()
  neotest.output_panel.toggle()
end, {
  noremap = true,
  silent = true,
  desc = "Toggle test output panel",
})

vim.keymap.set("n", "[n", function()
  neotest.jump.prev({ status = "failed" })
end, {
  noremap = true,
  silent = true,
  desc = "Jump to previous failed test",
})

vim.keymap.set("n", "]n", function()
  neotest.jump.next({ status = "failed" })
end, {
  noremap = true,
  silent = true,
  desc = "Jump to next failed test",
})

local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
      return message
    end,
  },
}, neotest_ns)

neotest.setup({
  adapters = {
    require("neotest-go")({
      experimental = {
        test_table = true,
      },
      args = { "-count=1", "-timeout=60s", "-v", "-race" },
    }),
  },
})
