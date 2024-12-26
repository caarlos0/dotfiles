---@diagnostic disable: missing-fields
require("blink.cmp").setup({
  keymap = { preset = "default" },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
  },
  signature = { enabled = true },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    cmdline = function()
      local type = vim.fn.getcmdtype()
      if type == "/" or type == "?" then
        return { "buffer" }
      end
      if type == ":" then
        return { "cmdline" }
      end
      return {}
    end,
  },
  completion = {
    accept = { auto_brackets = { enabled = true } },
  },
})
