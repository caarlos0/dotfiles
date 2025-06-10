return {
  "rcarriga/nvim-notify",
  setup = true,
  opts = {
    render = "compact",
    stages = "static",
    timeout = 2000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { focusable = false })
    end,
  },
  keys = {
    { "<leader>un", "<cmd>lua require('notify').dismiss()<cr>" },
  },
  config = function()
    vim.notify = notify
  end,
}
