local bd = require("bufdelete")
vim.keymap.set("n", "<leader>q", function()
  bd.bufdelete(0, true)
end, {
  noremap = true,
  silent = true,
  desc = "Delete buffer",
})
