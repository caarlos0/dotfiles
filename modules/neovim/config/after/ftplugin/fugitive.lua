local keymap = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, {
    noremap = true,
    silent = true,
    buffer = vim.api.nvim_get_current_buf(),
    desc = desc,
  })
end

-- goes directly to the first file and opens diff view
vim.cmd("normal )=")

keymap("gp", function()
  vim.cmd.Git("push --quiet")
end, "Git push")

keymap("gP", function()
  vim.cmd.Git("pull --rebase")
end, "Git pull --rebase")

keymap("gt", function()
  vim.cmd.Git("push -u origin --quiet")
end, "Git push tracking origin")

keymap("go", function()
  vim.cmd.Git("push --quiet")
  vim.cmd.Git("pr")
end, "Git push & open browser in PR view")
