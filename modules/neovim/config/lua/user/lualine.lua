require("lualine").setup({
  options = {
    theme = "rose-pine",
    component_separators = "",
    section_separators = "",
  },
  sections = {
    lualine_c = {
      "%=",
      {
        "filename",
        file_status = false,
        path = 1,
      },
    },
  },
  inactive_sections = {
    lualine_c = {
      "%=",
      {
        "filename",
        file_status = false,
        path = 1,
      },
    },
    lualine_x = { "location" },
  },
})
