local Job = require("plenary.job")

local opts = {
  noremap = true,
  silent = true,
  buffer = vim.api.nvim_get_current_buf(),
}

-- Runs a git command async.
--
---@param args string[]: git command arguments.
---@param success_msg string: notification message when the command succeeds.
---@param error_msg string: notification message when the command fails.
local function async_git(args, success_msg, error_msg)
  ---@diagnostic disable-next-line: missing-fields
  Job:new({
    command = "git",
    args = args,
    ---@diagnostic disable: unused-local
    on_exit = function(j, status)
      if status == 0 then
        vim.notify(success_msg, vim.log.levels.INFO)
      else
        vim.notify(error_msg, vim.log.levels.ERROR)
      end
    end,
  }):start()
end

-- goes directly to the file list.
vim.cmd("normal )k=")

vim.keymap.set("n", "gp", function()
  async_git({ "push", "--quiet" }, "Pushed!", "Push failed!")
  vim.cmd("silent! close")
  vim.notify("Pushing...")
end, opts)

vim.keymap.set("n", "gP", function()
  async_git({ "pull", "--rebase" }, "Pulled!", "Pull failed!")
  vim.cmd("silent! close")
  vim.notify("Pulling...")
end, opts)

vim.keymap.set("n", "go", function()
  async_git({ "ppr" }, "Pushed and opened PR URL!", "Failed to push or open PR")
  vim.cmd("silent! close")
  vim.notify("Opening PR...")
end, opts)

vim.keymap.set("n", "gq", function()
  vim.cmd("silent! close")
end, opts)
