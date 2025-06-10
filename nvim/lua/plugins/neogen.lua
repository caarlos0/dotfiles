return {
  "danymat/neogen",
  opts = { snippet_engine = "nvim" },
  keys = {
    {
      "gco",
      function()
        require("neogen").generate()
      end,
      desc = "Generate docstring",
    },
  },
}
