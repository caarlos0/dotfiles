local hotkey = require("hs.hotkey")

-- hyper key
local hyper = { "alt", "ctrl", "cmd", "shift" }

-- disable anymations
hs.window.animationDuration = 0

hotkey.bind(hyper, ";", function()
  hs.reload()
end)

hs.alert.show("Config loaded")

-- middle left
hs.hotkey.bind(hyper, "H", function()
  hs.window.focusedWindow():moveToUnit({ 0, 0, 0.5, 1 })
end)

-- middle right
hs.hotkey.bind(hyper, "L", function()
  hs.window.focusedWindow():moveToUnit({ 0.5, 0, 0.5, 1 })
end)

-- centralize at 80% screen size
hotkey.bind(hyper, "J", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x * 0.8
  f.y = max.y * 0.8
  f.w = max.w * 0.8
  f.h = max.h * 0.8

  win:setFrame(f)
  win:centerOnScreen()
end)

-- maximize
hotkey.bind(hyper, "K", function()
  hs.window.focusedWindow():moveToUnit({ 0, 0, 1, 1 })
end)

hotkey.bind(hyper, "Y", function()
  hs.application.launchOrFocus("Music")
end)

hotkey.bind(hyper, "U", function()
  hs.application.launchOrFocus("Ghostty")
end)

hotkey.bind(hyper, "I", function()
  hs.application.launchOrFocus("Safari")
end)

hotkey.bind(hyper, "O", function()
  hs.application.launchOrFocus("Notes")
end)

hotkey.bind(hyper, "P", function()
  hs.application.launchOrFocus("Discord")
end)

hotkey.bind(hyper, "M", function()
  hs.application.launchOrFocus("Reminders")
end)
