local todo = require("todo-comments")
todo.setup({
  highlight = {
    keyword = "bg",
  },
})

vim.keymap.set("n", "]t", todo.jump_next, { desc = "Next todo comment" })
vim.keymap.set("n", "[t", todo.jump_prev, { desc = "Previous todo comment" })
