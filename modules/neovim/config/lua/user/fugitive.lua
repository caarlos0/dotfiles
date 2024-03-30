vim.g.fugitive_legacy_commands = 0

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user-fugitive", { clear = true }),
  pattern = "fugitive",
  callback = function()
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
      vim.cmd.Git("pull --rebase")
    end, "Git pull --rebase")

    keymap("<leader>t", function()
      vim.cmd.Git("push -u origin")
    end, "Git push tracking origin")

    keymap("<leader>o", function()
      vim.cmd.Git("push")
      vim.cmd.Git("pr")
    end, "Git push & open browser in PR view")

    keymap("<leader>q", ":bdelete!<cr>", "Close Git status")
  end,
})

vim.keymap.set("n", "<leader>gs", vim.cmd.Git, {
  noremap = true,
  silent = true,
  desc = "Open Git",
})

vim.keymap.set("n", "<leader>gms", function()
  vim.cmd.Git("sync")
end, {
  noremap = true,
  silent = true,
  desc = "Git sync",
})
