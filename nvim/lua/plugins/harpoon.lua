return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = function()
    local keys = {
      {
        "<leader>m",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon File",
      },
      {
        "<A-e>",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
    }

    local function nav(i)
      return function()
        local harpoon = require("harpoon")
        harpoon:list():select(i)
      end
    end

    table.insert(keys, { "<A-h>", nav(1), desc = "Harpoon go to file 1" })
    table.insert(keys, { "<A-j>", nav(2), desc = "Harpoon go to file 2" })
    table.insert(keys, { "<A-k>", nav(3), desc = "Harpoon go to file 3" })
    table.insert(keys, { "<A-l>", nav(4), desc = "Harpoon go to file 4" })

    return keys
  end,
}
