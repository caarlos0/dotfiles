local keymap = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, {
    noremap = true,
    silent = true,
    buffer = vim.api.nvim_get_current_buf(),
    desc = desc,
  })
end

keymap("<leader>p", function()
  vim.cmd.Git("push --quiet")
end, "Git push")

keymap("<leader>P", function()
  vim.cmd.Git("pull --rebase")
end, "Git pull --rebase")

keymap("<leader>t", function()
  vim.cmd.Git("push -u origin --quiet")
end, "Git push tracking origin")

keymap("<leader>o", function()
  vim.cmd.Git("push --quiet")
  vim.cmd.Git("pr")
end, "Git push & open browser in PR view")

vim.cmd.runtime({ "lua/bdelete.lua", bang = true })
