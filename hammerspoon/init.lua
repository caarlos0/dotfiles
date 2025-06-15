local hotkey = require("hs.hotkey")

-- hyper key
local hyper = { "alt", "ctrl", "cmd", "shift" }

-- disable anymations
hs.window.animationDuration = 0

hotkey.bind(hyper, "\\", function()
  hs.reload()
end)

hs.alert.show("Config loaded")

-- middle left
hs.hotkey.bind(hyper, "Left", function()
  hs.window.focusedWindow():moveToUnit({ 0, 0, 0.5, 1 })
end)

-- middle right
hs.hotkey.bind(hyper, "Right", function()
  hs.window.focusedWindow():moveToUnit({ 0.5, 0, 0.5, 1 })
end)

-- middle up
hs.hotkey.bind(hyper, "Up", function()
  hs.window.focusedWindow():moveToUnit({ 0, 0, 1, 0.5 })
end)

-- middle down
hs.hotkey.bind(hyper, "Down", function()
  hs.window.focusedWindow():moveToUnit({ 0, 0.5, 1, 0.5 })
end)

-- maximize
hotkey.bind(hyper, ";", function()
  hs.window.focusedWindow():moveToUnit({ 0, 0, 1, 1 })
end)

-- centralize at 80% screen size
hotkey.bind(hyper, "'", function()
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

hotkey.bind(hyper, "H", function()
  hs.application.launchOrFocus("Reminders")
end)

hotkey.bind(hyper, "J", function()
  hs.application.launchOrFocus("Calendar")
end)

hotkey.bind(hyper, "K", function()
  hs.application.launchOrFocus("Mail")
end)

hotkey.bind(hyper, "M", function()
  hs.application.launchOrFocus("Claude")
end)

local function handleAppLaunch(app, appName)
  local screen = hs.screen:primaryScreen():getUUID()
  local spaces = hs.spaces.allSpaces()[screen]
  while #spaces < 3 do
    hs.spaces.addSpaceToScreen(screen)
    spaces = hs.spaces.allSpaces()[screen]
  end

  local apps = {
    ["Safari"] = 1,
    ["Ghostty"] = 1,
    ["Mail"] = 2,
    ["Calendar"] = 2,
    ["Notes"] = 2,
    ["Reminders"] = 2,
    ["Music"] = 3,
    ["Discord"] = 3,
    ["Telegram"] = 3,
    ["WhatsApp"] = 3,
    ["Messages"] = 3,
  }

  print(appName)

  if apps[appName] then
    local space = spaces[apps[appName]]
    local window = app:mainWindow()
    hs.spaces.moveWindowToSpace(window, space)
    window:focus()
    -- if space ~= hs.spaces.activeSpaceOnScreen(hs.screen.primaryScreen()) then
    --   hs.spaces.gotoSpace(spaces[space])
    -- end
  end
end

---needs to be a global var otherwise it gets garbage collected apparently
---@diagnostic disable-next-line: lowercase-global
appwatcher = hs.application.watcher
  .new(function(appName, event, app)
    if event == hs.application.watcher.launched then
      handleAppLaunch(app, appName)
    end
  end)
  :start()
