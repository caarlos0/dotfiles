require("bufferline").setup({
  highlights = require("catppuccin.groups.integrations.bufferline").get(),
  options = {
    diagnostics = "nvim_lsp",
    tab_size = 22,
    modified_icon = "",
    show_close_icon = false,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "center",
        separator = true,
      },
    },
    custom_areas = {
      left = function()
        return {
          { text = "    " },
        }
      end,
    },
  },
})
