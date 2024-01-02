local harpoon = require("harpoon")

harpoon:setup()

local function nav(i)
  return function()
    harpoon:list():select(i)
  end
end

local function k(key, fn, desc)
  vim.keymap.set("n", key, fn, {
    noremap = true,
    silent = true,
    desc = desc,
  })
end

k("[j", function()
  harpoon:list():prev()
end, "Harpoon previous")

k("[k", function()
  harpoon:list():next()
end, "Harpoon next")

k("<leader>m", function()
  harpoon:list():append()
end, "Harpoon mark current file")

k("<A-e>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, "Harpoon toggle quick menu")

k("<A-h>", nav(1), "Harpoon go to file 1")
k("<A-j>", nav(2), "Harpoon go to file 2")
k("<A-k>", nav(3), "Harpoon go to file 3")
k("<A-l>", nav(4), "Harpoon go to file 4")
