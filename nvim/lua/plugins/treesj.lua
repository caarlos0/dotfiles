return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
  config = true,
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
