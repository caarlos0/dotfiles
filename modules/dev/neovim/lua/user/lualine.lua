require("lualine").setup({
  options = {
    theme = "catppuccin",
    component_separators = "",
    section_separators = "",
  },
  sections = {
    lualine_c = {
      "%=",
      {
        "filetype",
        icon_only = true,
        icon = { align = "right" },
      },
      {
        "filename",
        file_status = false,
        path = 1,
      },
    },
  },
})
