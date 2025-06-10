return {
  "rgroli/other.nvim",
  event = "VeryLazy",
  main = "other-nvim",
  opts = {
    mappings = {
      "golang",
      {
        pattern = "go.mod$",
        target = "go.sum",
        context = "sum",
      },
      {
        pattern = "go.sum$",
        target = "go.mod",
        context = "mod",
      },
      {
        pattern = "go.work$",
        target = "go.work.sum",
        context = "sum",
      },
      {
        pattern = "go.work.sum$",
        target = "go.work",
        context = "mod",
      },
    },
  },
  keys = {
    { "<leader>oo", "<cmd>Other<cr>", desc = "Open other file" },
    { "<leader>ov", "<cmd>OtherVSplit<cr>", desc = "Open other file in a vertical split" },
    { "<leader>os", "<cmd>OtherSplit<cr>", desc = "Open other file in a horizontal split" },
  },
}
