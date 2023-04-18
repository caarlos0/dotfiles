require("indent_blankline").setup({
  char = "│",
  filetype_exclude = { "help", "alpha", "dashboard" },
  show_trailing_blankline_indent = false,
  show_current_context = false,
})

local indent = require("mini.indentscope")
indent.setup({
  symbol = "│",
  draw = {
    animation = indent.gen_animation.none(),
  },
  options = { try_as_border = true },
})

require("mini.splitjoin").setup()
