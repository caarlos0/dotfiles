vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.dockerfile",
  callback = function()
    vim.opt_local.ft = "dockerfile"
  end,
  group = vim.api.nvim_create_augroup("Dockerfile", { clear = true }),
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  command = "startinsert",
  group = vim.api.nvim_create_augroup("AutoInsert", { clear = true }),
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
  group = vim.api.nvim_create_augroup("Mkdir", { clear = true }),
})

-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup("Highlight", { clear = true }),
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("help_window_right", {}),
  pattern = { "*.txt" },
  callback = function()
    if vim.o.filetype == "help" then
      vim.cmd.wincmd("L")
    end
  end,
})
