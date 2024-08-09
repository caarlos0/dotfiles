local mapping = {
  j = { k = "<Esc>" },
  k = { j = "<Esc>" },
}

require("better_escape").setup({
  timeout = 100,
  default_mappings = false,
  mappings = {
    i = mapping,
    c = mapping,
    t = mapping,
    v = mapping,
    s = mapping,
  },
})
