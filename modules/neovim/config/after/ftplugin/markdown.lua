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
