require("bufferline").setup({
  highlights = require("catppuccin.groups.integrations.bufferline").get(),
  options = {
    diagnostics = "nvim_lsp",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "center",
        separator = true,
      },
    },
  },
})
