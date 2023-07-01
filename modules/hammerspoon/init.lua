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
hotkey.bind(hyper, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- middle right
hotkey.bind(hyper, "L", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
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
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h

  win:setFrame(f)
end)

hotkey.bind(hyper, "Y", function()
  hs.application.launchOrFocus("Music")
end)

hotkey.bind(hyper, "U", function()
  hs.application.launchOrFocus("WezTerm")
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
