vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("user-fugitive", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.bo.ft ~= "fugitive" then
      return
    end

    local keymap = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, {
        noremap = true,
        silent = true,
        buffer = vim.api.nvim_get_current_buf(),
        desc = desc,
      })
    end

    keymap("<leader>p", function()
      vim.cmd.Git("push")
    end, "Git push")

    keymap("<leader>P", function()
      vim.cmd.Git({ "pull", "--rebase" })
    end, "Git pull --rebase")

    keymap("<leader>t", function()
      vim.cmd.Git({ "push", "-u", "origin" })
    end, "Git push tracking origin")
  end,
})

vim.keymap.set("n", "<leader>gs", vim.cmd.Git, {
  noremap = true,
  silent = true,
  desc = "Open Git",
})
