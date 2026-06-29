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

local function launchOrFocus(app)
  return function()
    hs.application.launchOrFocus(app)
  end
end

-- disable anymations
hs.window.animationDuration = 0

hotkey.bind(hyper, "\\", function()
  hs.reload()
end)

hs.alert.show("Config loaded")

-- moves the focused window to a screen-relative rect (no-op if nothing is focused)
local function moveTo(unit)
  return function()
    local win = hs.window.focusedWindow()
    if win then
      win:moveToUnit(unit)
    end
  end
end

hs.hotkey.bind(hyper, "Left", moveTo({ 0, 0, 0.5, 1 })) -- middle left
hs.hotkey.bind(hyper, "Right", moveTo({ 0.5, 0, 0.5, 1 })) -- middle right
hs.hotkey.bind(hyper, "Up", moveTo({ 0, 0, 1, 0.5 })) -- middle up
hs.hotkey.bind(hyper, "Down", moveTo({ 0, 0.5, 1, 0.5 })) -- middle down
hotkey.bind(hyper, ";", moveTo({ 0, 0, 1, 1 })) -- maximize

-- centralize at 80% screen size
hotkey.bind(hyper, "'", function()
  local win = hs.window.focusedWindow()
  if not win then
    return
  end

  local f = win:frame()
  local max = win:screen():frame()
  f.w = max.w * 0.8
  f.h = max.h * 0.8

  win:setFrame(f)
  win:centerOnScreen()
end)

hotkey.bind(hyper, "Y", launchOrFocus("Music"))
hotkey.bind(hyper, "U", appCycler({ "Mail" }))
hotkey.bind(hyper, "I", appCycler({ "Calendar" }))
hotkey.bind(hyper, "P", appCycler({ "Slack", "Microsoft Teams" }))
hotkey.bind(hyper, "J", launchOrFocus("Ghostty"))
hotkey.bind(hyper, "K", launchOrFocus("Safari"))
hotkey.bind(hyper, "H", appCycler({ "Notes", "Reminders" }))
