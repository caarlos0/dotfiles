vim.opt.compatible = false
vim.opt.termsync = true
vim.opt.hidden = true
vim.opt.updatetime = 250
vim.opt.mouse = ""
vim.opt.inccommand = "nosplit"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = false
vim.opt.textwidth = 0
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smoothscroll = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "undodir"
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.ruler = true
vim.opt.wildmenu = true
vim.opt.autoread = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.colorcolumn = "80"
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.spelllang = { "en_us" }
vim.opt.spellfile = vim.uv.os_homedir() .. "/.spell.add"
vim.opt.laststatus = 2
vim.opt.cursorline = true
vim.opt.grepprg = "rg --vimgrep --smart-case --follow"
vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.opt.shortmess:append("c")
vim.opt.timeoutlen = 300
vim.opt.winborder = "none"

vim.hl.priorities.semantic_tokens = 10
vim.g.fugitive_legacy_commands = 0

vim.cmd([[
inoreabbrev Goreleaser GoReleaser
inoreabbrev gorelesaer goreleaser
inoreabbrev carlos0 caarlos0
inoreabbrev descriptoin description
inoreabbrev fucn func
inoreabbrev sicne since
inoreabbrev emtpy empty
inoreabbrev udpate update
inoreabbrev dont don't
inoreabbrev wont won't
inoreabbrev cant can't
inoreabbrev lenght length
inoreabbrev Lenght Length

" ptbr
inoreabbrev neh né
inoreabbrev soh só
inoreabbrev nao não
inoreabbrev sao são
]])

vim.pack.add({
  -- UI
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/stevearc/dressing.nvim" },
  { src = "https://github.com/rcarriga/nvim-notify" },
  { src = "https://github.com/christoomey/vim-tmux-navigator" },
  { src = "https://github.com/asiryk/auto-hlsearch.nvim" },
  { src = "https://github.com/famiu/bufdelete.nvim" },
  { src = "https://github.com/norcalli/nvim-colorizer.lua" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/akinsho/git-conflict.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },

  -- CODING
  { src = "https://github.com/rgroli/other.nvim" },
  { src = "https://github.com/danymat/neogen" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/zbirenbaum/copilot.lua" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/giuxtaposition/blink-cmp-copilot" },
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1.*"),
  },

  -- tpope gang
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/tpope/vim-rhubarb" },
  { src = "https://github.com/tpope/vim-abolish" },
  { src = "https://github.com/tpope/vim-repeat" },
  { src = "https://github.com/tpope/vim-eunuch" },
  { src = "https://github.com/tpope/vim-sleuth" },
  { src = "https://github.com/tpope/vim-speeddating" },

  -- treesitter and friends
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  { src = "https://github.com/wansmer/treesj" },
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/kylechui/nvim-surround" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/RRethy/nvim-treesitter-endwise" },
})

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- quicklists
keymap("n", "<leader>co", ":copen<CR>", opts)
keymap("n", "<leader>cc", ":cclose<CR>", opts)

-- write, buffer killing
keymap("n", "<leader>q", ":Bdelete<CR>", opts)
keymap("n", "<leader>bad", ":%Bwipeout!<cr>:intro<cr>", opts)
keymap("n", "<leader>w", ":write<CR>", opts)

-- zz
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-o>", "<C-o>zz", opts)
keymap("n", "<C-i>", "<C-i>zz", opts)

-- system clipboard integration
keymap({ "n", "v" }, "<leader>y", '"+y', opts)

-- copy the current file path
keymap("n", "<leader>py", ':let @" = expand("%:p")<CR>', opts)

-- delete to blackhole
keymap({ "n", "v" }, "<leader>d", '"_d', opts)

-- git
keymap("n", "<leader>gs", ":tab Git<cr>", opts)
keymap("n", "<F9>", ":tab Git mergetool<cr>", opts)
keymap("n", "<leader>gd", ":Gitsign preview_hunk_inline<cr>", opts)

-- indent
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- If I visually select words and paste from clipboard, don't replace my
-- clipboard with the selected word, instead keep my old word in the
-- clipboard
keymap("v", "p", '"_dP', opts)

-- Move text up and down
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)

-- in insert mode, adds new undo points after more some chars:
for _, lhs in ipairs({ "-", "_", ",", ".", ";", ":", "/", "!", "?" }) do
  keymap("i", lhs, lhs .. "<c-g>u", opts)
end

---
--- UI
---

local bg0 = "#1b1b1b"
require("gruvbox").setup({
  contrast = "hard",
  overrides = {
    GruvboxBg0 = { fg = bg0 },
    SignColumn = { bg = bg0 },
    GruvboxRedSign = { bg = bg0 },
    GruvboxYellowSign = { bg = bg0 },
    GruvboxGreenSign = { bg = bg0 },
    GruvboxAquaSign = { bg = bg0 },
    GruvboxOrangeSign = { bg = bg0 },
    GruvboxPurpleSign = { bg = bg0 },
    GruvboxBlueSign = { bg = bg0 },
    Normal = { bg = bg0 },
  },
})
vim.cmd("colorscheme gruvbox")
-- https://github.com/ellisonleao/gruvbox.nvim/commit/c74e6e523c4827b67af2cb02b636e22dc35fdf70
-- https://github.com/nvim-lualine/lualine.nvim/issues/1312
vim.api.nvim_set_hl(0, "StatusLine", { reverse = false })
vim.api.nvim_set_hl(0, "StatusLineNC", { reverse = false })

require("dressing").setup({ input = { insert_only = true } })

local notify = require("notify")
notify.setup({
  render = "compact",
  stages = "static",
})
vim.notify = notify

local section_b = { "branch", "diff", { "diagnostics", sources = { "nvim_workspace_diagnostic" } } }
local section_c = { "%=", { "filename", file_status = false, path = 1 } }
require("lualine").setup({
  options = {
    theme = "gruvbox",
    component_separators = "",
    section_separators = "",
  },
  sections = {
    lualine_b = section_b,
    lualine_c = section_c,
  },
  inactive_sections = {
    lualine_c = section_c,
    lualine_x = { "location" },
  },
})

require("auto-hlsearch").setup({})
require("gitsigns").setup({})
require("git-conflict").setup({})

-- setup diagnostics
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

keymap("n", "<leader>xx", vim.diagnostic.setqflist, opts)

-- set up diagnostic signs
local severity = vim.diagnostic.severity
local signs = {
  [severity.ERROR] = "",
  [severity.WARN] = "",
  [severity.INFO] = "",
  [severity.HINT] = "󰌶",
}
vim.diagnostic.config({
  signs = {
    text = signs,
  },
})

require("other-nvim").setup({ mappings = { "golang" } })
keymap("n", "<leader>oo", ":Other<cr>", opts)
keymap("n", "<leader>ov", ":OtherVSplit<cr>", opts)
keymap("n", "<leader>os", ":OtherSplit<cr>", opts)

require("neogen").setup({ snippet_engine = "nvim" })
keymap("n", "gco", ":Neogen<cr>", opts)

require("conform").setup({
  formatters_by_ft = {
    css = { "prettier" },
    fish = { "fish_indent" },
    html = { "prettier" },
    javascript = { "prettier" },
    json = { "jq" },
    lua = { "stylua" },
    markdown = { "prettier" },
    sh = { "shfmt" },
    sql = { "pg_format", "sql_formatter" },
    templ = { "templ" },
    tf = { "terraform_fmt" },
    yaml = { "prettier" },
    ["_"] = { "trim_whitespace", "trim_newlines" },
    -- let only the lsp take care of these.
    go = {},
    rust = {},
    zig = {},
  },
  format_after_save = {
    lsp_fallback = true,
  },
})

require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})

---@module 'blink.cmp'
---@type blink.cmp.Config
require("blink.cmp").setup({
  keymap = { preset = "default" },
  appearance = {
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
        -- score_offset = -10,
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
})

local function copen()
  if vim.fn.getqflist({ size = 0 }).size > 1 then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end

local function cclear()
  vim.fn.setqflist({}, "r")
end

-- Opens the directory of the current file in Finder/file explorer.
vim.api.nvim_create_user_command("Finder", "!open %:h", {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  command = "startinsert",
})

-- ensure the parent folder exists, so it gets properly added to the lsp
-- context and everything just works.
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*",
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
      vim.cmd([[ :e % ]])
    end
  end,
})

-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = { "*.txt" },
  callback = function()
    if vim.o.filetype == "help" then
      vim.cmd.wincmd("L")
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "fugitive",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()

    local function async_git(args, success_msg, error_msg)
      vim.system({ "git", unpack(args) }, {}, function(obj)
        vim.schedule(function()
          if obj.code == 0 then
            vim.notify(success_msg, vim.log.levels.INFO)
          else
            vim.notify(error_msg, vim.log.levels.ERROR)
          end
        end)
      end)
    end

    vim.cmd("normal )k=")

    local buf_opts = { noremap = true, silent = true, buffer = bufnr }
    keymap("n", "gp", function()
      async_git({ "push", "--quiet" }, "Pushed!", "Push failed!")
      vim.cmd("silent! close")
    end, buf_opts)

    keymap("n", "gP", function()
      async_git({ "pull", "--rebase" }, "Pulled!", "Pull failed!")
      vim.cmd("silent! close")
    end, buf_opts)

    keymap("n", "go", function()
      async_git({ "ppr" }, "Pushed and opened PR URL!", "Failed to push or open PR")
      vim.cmd("silent! close")
    end, buf_opts)

    keymap("n", "cc", ":silent! Git commit -s<cr>", buf_opts)
    keymap("n", "gq", ":silent! close<cr>", buf_opts)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 72
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf", "help" },
  callback = function()
    keymap("n", "<leader>q", ":bdelete<CR>", {
      buffer = vim.api.nvim_get_current_buf(),
      noremap = true,
      silent = true,
    })
  end,
})

local get_gopls = function(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, c in ipairs(clients) do
    if c.name == "gopls" then
      return c
    end
  end
  return nil
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()

    vim.opt_local.formatoptions:append("jo")
    vim.opt_local.makeprg = "go build ./..."
    vim.opt_local.errorformat = "%A%f:%l:%c: %m,%-G%.%#"

    vim.api.nvim_buf_create_user_command(bufnr, "GoModTidy", function()
      local gopls = get_gopls(bufnr)
      if gopls == nil then
        return
      end

      vim.cmd([[ noautocmd wall ]])

      local uri = vim.uri_from_bufnr(bufnr)
      local arguments = { { URIs = { uri } } }

      local err = gopls:request_sync("workspace/executeCommand", {
        command = "gopls.tidy",
        arguments = arguments,
      }, 30000, bufnr)

      if err ~= nil and type(err[1]) == "table" then
        vim.notify("go mod tidy: " .. vim.inspect(err), vim.log.levels.ERROR)
        return
      end
    end, { desc = "go mod tidy" })

    local buf_opts = { noremap = true, silent = true, buffer = bufnr }
    keymap("n", "<F6>", vim.cmd.GoModTidy, buf_opts)
    keymap("n", "<F7>", function()
      cclear()
      vim.fn.jobstart("golangci-lint run --max-issues-per-linter=0 --max-same-issues=0 --new", {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data and #data > 1 then
            vim.schedule(function()
              vim.fn.setqflist({}, " ", { lines = data })
              copen()
            end)
          end
        end,
      })
    end, buf_opts)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 80
    vim.opt_local.formatoptions:remove("ct")
  end,
})

require("plugins.syntax")

local treesj = require("treesj")
treesj.setup({ use_default_keymaps = false })
keymap("n", "<leader>st", treesj.toggle, opts)

require("fzf-lua").setup({
  fzf_opts = { ["--cycle"] = true },
  winopts = { split = "botright new" },
})
keymap("n", "<C-p>", ":FzfLua global<CR>", opts)
keymap("n", "<leader>of", ":FzfLua oldfiles cwd_only=true<CR>", opts)
keymap("n", "<leader>lg", ":FzfLua live_grep<CR>", opts)
keymap("n", "<leader>fh", ":FzfLua helptags<CR>", opts)
keymap("n", "<leader>fc", ":FzfLua commands<CR>", opts)
keymap("n", "<leader>fr", ":FzfLua resume<CR>", opts)
keymap("n", "<leader>fq", ":FzfLua quickfix<CR>", opts)
keymap("n", "<leader>/", ":FzfLua grep_curbuf<CR>", opts)
keymap("n", "<leader>fb", ":FzfLua buffers cwd_only=true<CR>", opts)

require("plugins.lsp")
