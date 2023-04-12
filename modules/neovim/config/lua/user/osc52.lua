local osc52 = require("osc52")
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    if vim.v.event.operator == "y" and vim.v.event.regname == "+" then
      osc52.copy_register("+")
    end
  end,
  group = vim.api.nvim_create_augroup("OSCYank", { clear = true }),
})
