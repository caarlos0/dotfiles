---@diagnostic disable: missing-fields
require("blink.cmp").setup({
  fuzzy = {
    prebuilt_binaries = {
      -- TODO: this will be the default in nixpkgs soon.
      -- https://github.com/NixOS/nixpkgs/pull/368677
      force_version = "@tag@",
    },
  },
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
    providers = {
      lsp = {
        min_keyword_length = 2,
        score_offset = 0,
      },
      path = {
        min_keyword_length = 0,
      },
      snippets = {
        min_keyword_length = 2,
      },
      buffer = {
        min_keyword_length = 5,
        max_items = 5,
      },
    },
  },
  completion = {
    accept = { auto_brackets = { enabled = true } },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 250,
      treesitter_highlighting = true,
    },

    menu = {
      draw = {
        columns = {
          { "kind_icon", "label", gap = 1 },
          { "kind" },
        },
        components = {
          kind_icon = {
            text = function(item)
              local icons = require("user.icons").kinds
              local kind = icons[item.kind] or ""
              return kind .. " "
            end,
          },
        },
      },
    },
  },
})
