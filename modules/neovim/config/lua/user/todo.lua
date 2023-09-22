local todo = require("todo-comments")

-- todo-comments create new highlight groups on setup, which causes a redraw,
-- which will steal the :intro screen, which I like to keep.
--
-- This will also lazy load it, so that's also good :)
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  once = true,
  callback = function()
    todo.setup({
      highlight = {
        keyword = "bg",
      },
    })
  end,
})

vim.keymap.set("n", "]t", todo.jump_next, { desc = "Next todo comment" })
vim.keymap.set("n", "[t", todo.jump_prev, { desc = "Previous todo comment" })
