return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "giuxtaposition/blink-cmp-copilot",
  },
  version = "1.*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "default" },
    appearance = {
      -- use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
      kind_icons = {
        Array = "",
        Boolean = "",
        Class = "",
        Color = "",
        Constant = "",
        Constructor = "",
        Copilot = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "",
        File = "",
        Folder = "󰉋",
        Function = "",
        Interface = "",
        Key = "",
        Keyword = "",
        Method = "",
        Module = "",
        Namespace = "",
        Null = "󰟢",
        Number = "",
        Object = "",
        Operator = "",
        Package = "",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "",
        Struct = "",
        Text = "",
        TypeParameter = "",
        Unit = "",
        Value = "",
        Variable = "",
      },
    },
    signature = { enabled = true },
    cmdline = {
      enabled = true,
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        if type == ":" then
          return { "cmdline" }
        end
        return {}
      end,
      completion = {
        menu = {
          draw = {
            columns = {
              { "kind_icon", "label", gap = 1 },
              { "kind" },
            },
          },
        },
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
      providers = {
        lsp = {
          min_keyword_length = 0,
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
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = -10,
          min_keyword_length = 0,
          async = true,
          override = {
            -- copilot complete on space, new line, etc as well...
            get_trigger_characters = function(self)
              local trigger_characters = self:get_trigger_characters()
              vim.list_extend(trigger_characters, { "\n", "\t", " " })
              return trigger_characters
            end,
          },
          transform_items = function(_, items)
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local kind_idx = #CompletionItemKind + 1
            CompletionItemKind[kind_idx] = "Copilot"
            for _, item in ipairs(items) do
              item.kind = kind_idx
            end
            return items
          end,
        },
      },
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },

      keyword = {
        range = "full",
      },

      trigger = {
        show_on_insert_on_trigger_character = true,
        show_on_trigger_character = true,
        show_on_keyword = true,
      },

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
        },
      },
    },
  },
  opts_extend = { "sources.default" },
}
