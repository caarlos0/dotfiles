local hotkey = require("hs.hotkey")

-- hyper key
local hyper = { "alt", "ctrl", "cmd", "shift" }

-- cycles through a list of apps, resetting to the first if the focused app isn't in the list
local function appCycler(apps)
  local index = 1
  return function()
    local frontApp = hs.application.frontmostApplication()
    local frontName = frontApp and frontApp:name() or ""
    local inList = false
    for _, app in ipairs(apps) do
      if frontName == app then
        inList = true
        break
      end
    end
    if not inList then
      index = 1
    elseif frontName == apps[index] then
      index = (index % #apps) + 1
    end
    hs.application.launchOrFocus(apps[index])
  end
end

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

hotkey.bind(hyper, "U", appCycler({ "Notes", "Reminders" }))

hotkey.bind(hyper, "I", appCycler({ "Mail", "Calendar" }))
hotkey.bind(hyper, "P", appCycler({ "Messages", "Telegram", "WhatsAp" }))

hotkey.bind(hyper, "J", function()
  hs.application.launchOrFocus("Ghostty")
end)

hotkey.bind(hyper, "K", function()
  hs.application.launchOrFocus("Safari")
end)

hotkey.bind(hyper, "L", appCycler({ "Microsoft Teams", "Slack" }))
