local function arrangeAppWindowsInGrid(appName)
  -- Get the screen size
  local screenFrame = hs.screen.mainScreen():frame()

  -- Find all windows of the specified application in the current space
  local appWindows = hs.window.filter.new(false):setAppFilter(appName, { currentSpace = true }):getWindows()

  -- Calculate the grid dimensions
  local gridColumns = math.ceil(math.sqrt(#appWindows))
  local gridRows = math.ceil(#appWindows / gridColumns)

  -- Calculate window size for grid
  local windowWidth = screenFrame.w / gridColumns
  local windowHeight = screenFrame.h / gridRows

  -- Calculate the number of windows that need to be taller to fill the gaps
  local windowsInLastRow = #appWindows % gridColumns
  local tallerWindows = windowsInLastRow > 0 and gridColumns - windowsInLastRow or 0

  -- Disable window animations
  local originalAnimationDuration = hs.window.animationDuration
  hs.window.animationDuration = 0

  -- Iterate through windows and position them in the grid
  for index, win in ipairs(appWindows) do
    local row = math.floor((index - 1) / gridColumns)
    local column = (index - 1) % gridColumns

    -- Check if the window is in the row previous to the last one and if its index is within the last columns that need to be taller
    local isRightmostTallerWindow = row == (gridRows - 2) and column >= (gridColumns - tallerWindows)

    local x = screenFrame.x + (column * windowWidth)
    local y = screenFrame.y + (row * windowHeight)

    if isRightmostTallerWindow then
      -- Adjust the size and position of the necessary rightmost windows to fill the gaps
      win:setFrame({ x = x, y = y, w = windowWidth, h = windowHeight * 2 })
    else
      win:setFrame({ x = x, y = y, w = windowWidth, h = windowHeight })
    end

    -- Focus on the window to make it visible
    win:focus()
  end

  -- Refocus on the first window in the list
  if #appWindows > 0 then
    appWindows[1]:focus()
  end

  -- Restore the original window animation duration
  hs.window.animationDuration = originalAnimationDuration
end

local positions = {
  maximized = hs.layout.maximized,
  centered = { x = 0.15, y = 0.15, w = 0.7, h = 0.7 },

  left34 = { x = 0, y = 0, w = 0.34, h = 1 },
  left50 = hs.layout.left50,
  left66 = { x = 0, y = 0, w = 0.66, h = 1 },
  left70 = hs.layout.left70,

  right30 = hs.layout.right30,
  right34 = { x = 0.66, y = 0, w = 0.34, h = 1 },
  right50 = hs.layout.right50,
  right66 = { x = 0.34, y = 0, w = 0.66, h = 1 },
  right70 = hs.layout.right70,

  upper50 = { x = 0, y = 0, w = 1, h = 0.5 },
  upper50Left50 = { x = 0, y = 0, w = 0.5, h = 0.5 },
  upper50Right15 = { x = 0.85, y = 0, w = 0.15, h = 0.5 },
  upper50Right30 = { x = 0.7, y = 0, w = 0.3, h = 0.5 },
  upper50Right50 = { x = 0.5, y = 0, w = 0.5, h = 0.5 },

  lower50 = { x = 0, y = 0.5, w = 1, h = 0.5 },
  lower50Left50 = { x = 0, y = 0.5, w = 0.5, h = 0.5 },
  lower50Right50 = { x = 0.5, y = 0.5, w = 0.5, h = 0.5 },

  chat = { x = 0.5, y = 0, w = 0.35, h = 0.5 },
}

-- picked from https://github.com/evantravers/hammerspoon-config/blob/38a7d8c0ad2190d1563d681725628e4399dcbe6c/movewindows.lua
-- gathers all the open windows, except the current one
-- and presents them in a chooser, so you can pick one
-- that will be opened side by side with the current one.
-- It defaults to 30/70 split, but if you hold the alt key
-- will do 50/50 split.
local function referenceChooser()
  local windows = hs.fnutils.map(hs.window.filter.new():setCurrentSpace(true):getWindows(), function(win)
    if win ~= hs.window.focusedWindow() then
      return {
        text = win:title(),
        subText = win:application():title(),
        image = hs.image.imageFromAppBundle(win:application():bundleID()),
        id = win:id(),
      }
    end
  end)

  local chooser = hs.chooser.new(function(choice)
    if choice ~= nil then
      local layout = {}
      local focused = hs.window.focusedWindow()
      local toRead = hs.window.find(choice.id)
      if hs.eventtap.checkKeyboardModifiers()["alt"] then
        hs.layout.apply({
          { nil, focused, focused:screen(), hs.layout.left50,  0, 0 },
          { nil, toRead,  focused:screen(), hs.layout.right50, 0, 0 },
        })
      else
        hs.layout.apply({
          { nil, focused, focused:screen(), hs.layout.right70, 0, 0 },
          { nil, toRead,  focused:screen(), hs.layout.left30,  0, 0 },
        })
      end
      toRead:raise()
    end
  end)

  chooser
      :placeholderText("Choose window for 30/70 split. Hold ⎇ for 50/50.")
      :searchSubText(true)
      :choices(windows)
      :show()
end

local function debugWindow()
  local win = hs.window.focusedWindow()
  local app = win:application()
  local app_name = app:name()
  local win_title = win:title()
  local win_id = win:id()
  local win_frame = win:frame()
  local win_frame_string = "x: "
      .. win_frame.x
      .. " y: "
      .. win_frame.y
      .. " w: "
      .. win_frame.w
      .. " h: "
      .. win_frame.h
  local win_screen = win:screen():name()
  local win_screen_frame = win:screen():frame()
  local win_screen_frame_string = "x: "
      .. win_screen_frame.x
      .. " y: "
      .. win_screen_frame.y
      .. " w: "
      .. win_screen_frame.w
      .. " h: "
      .. win_screen_frame.h
  local debugLines = {
    "app: " .. app_name,
    "win title: " .. win_title,
    "win_id: " .. win_id,
    "frame: " .. win_frame_string,
    "screen: " .. win_screen,
    "screen frame: " .. win_screen_frame_string,
  }
  hs.alert.show(table.concat(debugLines, "\n"), 10)
  print("\n" .. table.concat(debugLines, "\n"))
end

local function window_menu()
  local options = {
    {
      text = hs.styledtext.new("Action 1", {
        font = { size = 18 },
        color = hs.drawing.color.definedCollections.hammerspoon.green
      }),
      fn = function()
        print("Action 1 selected")
      end
    },
    {
      text = "Action 2",
      fn = function()
        print("Action 2 selected")
      end
    },
    {
      text = "Action 3",
      fn = function()
        print("Action 3 selected")
      end
    }
  }

  local chooser = hs.chooser.new(function(choice)
    if choice ~= nil then
      choice.fn();
    end
  end)

  chooser
      :placeholderText("Choose window action")
      :searchSubText(false)
      :choices(options)
      :show()
end

return {
  arrangeAppWindowsInGrid = arrangeAppWindowsInGrid,
  positions = positions,
  referenceChooser = referenceChooser,
  debugWindow = debugWindow,
  window_menu = window_menu,
}
