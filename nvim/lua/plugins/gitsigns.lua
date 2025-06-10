return {
  "lewis6991/gitsigns.nvim",
  opts = {
    preview_config = {
      border = "none",
    },
  },
  keys = {
    { "<leader>gd", "<cmd>Gitsigns preview_hunk<cr>" },
  },
  event = "BufEnter",
  config = true,
}
