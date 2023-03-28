vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("user-fugitive", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.bo.ft ~= "fugitive" then
      return
    end

    vim.keymap.set("n", "gPp", function()
      vim.cmd.Git("push")
    end, {
      buffer = vim.api.nvim_get_current_buf(),
      noremap = true,
      silent = true,
      desc = "Git push",
    })
  end,
})

vim.keymap.set("n", "<leader>gs", vim.cmd.Git, {
  noremap = true,
  silent = true,
  desc = "Open Git",
})
