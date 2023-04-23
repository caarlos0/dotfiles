local dap = require("dap")
local dapui = require("dapui")
local gdap = require("dap-go")
local vtdap = require("nvim-dap-virtual-text")

gdap.setup({})
dapui.setup({})
vtdap.setup({})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

--- Add a normal keymap.
---@param lhs string Keymap
---@param rhs function Action
local keymap = function(lhs, rhs)
  vim.keymap.set("n", lhs, rhs, {
    noremap = true,
    silent = true,
  })
end

keymap("<F5>", dap.continue)
keymap("<F3>", dap.step_over)
keymap("<F2>", dap.step_into)
keymap("<F12>", dap.step_out)
keymap("<leader>b", dap.toggle_breakpoint)
keymap("<leader>B", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
keymap("<leader>lp", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
keymap("<leader>dr", dap.repl.open)
keymap("<leader>dt", gdap.debug_test)
