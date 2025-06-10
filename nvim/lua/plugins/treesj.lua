return {
  "Wansmer/treesj",
  keys = { "<space>m", "<space>j", "<space>s" },
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
  setup = true,
  keys = {
    {
      "<leader>gS",
      function()
        require("treesj").toggle()
      end,
      desc = "Toggle split/join",
    },
  },
}
