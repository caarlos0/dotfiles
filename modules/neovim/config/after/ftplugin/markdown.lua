vim.opt_local.formatoptions:remove("l")
vim.opt_local.textwidth = 80
vim.opt_local.conceallevel = 1

if require("zk.util").notebook_root(vim.fn.expand("%:p")) ~= nil then
  if vim.g.loaded_zk ~= 1 then
    require("user.zk")
    vim.g.loaded_zk = 1
  end

  -- TODO: add keymaps?
end

local bufnr = vim.api.nvim_buf_get_number(0)
vim.keymap.set("n", "<leader>op", function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lineno = cursor[1]
  local line = vim.api.nvim_buf_get_lines(bufnr, lineno - 1, lineno, false)[1] or ""
  if string.find(line, "%[ %]") then
    line = line:gsub("%[ %]", "%[x%]")
  else
    line = line:gsub("%[x%]", "%[ %]")
  end
  vim.api.nvim_buf_set_lines(bufnr, lineno - 1, lineno, false, { line })
  vim.api.nvim_win_set_cursor(0, cursor)
end, {
  noremap = true,
  silent = true,
  desc = "Toggle checkbox",
  buffer = bufnr,
})
