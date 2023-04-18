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

-- returns a function that, when called
-- will focus the chrome tab with the given name
-- and bring it to the front.
-- Finding the chrome window that contains the tab
-- is fuzzy, but focusing the right exact tab within the
-- window requires the exact tab name.
local function focusChromeTab(tabName)
	local script = [[
  tell application "Google Chrome" to activate
  tell application "Google Chrome"
    set found to false
    repeat with theWindow in windows
      repeat with theTab in (tabs of theWindow)
        if the title of theTab contains "%s" then
          set found to true
          set index of theWindow to 1
          return id of theTab
        end if
      end repeat
    end repeat
    return found
  end tell
]]

	return function()
		local success, windowID, errors = hs.osascript.applescript(string.format(script, tabName))

		print(success, windowID, type(windowID), hs.inspect(errors))
		if success == false then
			hs.alert.show("Tab with name '" .. tabName .. "' not found.")
		else
			hs.alert.show("Tab '" .. tabName .. "' found and brought to front.")
			hs.appfinder.appFromName(chrome_app_name):selectMenuItem({ "Tab", tabName })
		end
	end
end

-- picked from https://github.com/evantravers/hammerspoon-config/blob/38a7d8c0ad2190d1563d681725628e4399dcbe6c/movewindows.lua
-- gathers all the open windows, except the current one
-- and presents them in a chooser, so you can pick one
-- that will be opened side by side with the current one.
-- It defaults to 30/70 split, but if you hold the alt key
-- will do 50/50 split.
local function referenceChooser()
	local windows = hs.fnutils.map(hs.window.filter.new():getWindows(), function(win)
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
					{ nil, focused, focused:screen(), hs.layout.left50, 0, 0 },
					{ nil, toRead, focused:screen(), hs.layout.right50, 0, 0 },
				})
			else
				hs.layout.apply({
					{ nil, focused, focused:screen(), hs.layout.right70, 0, 0 },
					{ nil, toRead, focused:screen(), hs.layout.left30, 0, 0 },
				})
			end
			toRead:raise()
		end
	end)

	chooser
		:placeholderText("Choose window for 50/50 split. Hold ⎇ for 70/30.")
		:searchSubText(true)
		:choices(windows)
		:show()
end

return {
	arrangeAppWindowsInGrid = arrangeAppWindowsInGrid,
	positions = positions,
	focusChromeTab = focusChromeTab,
	referenceChooser = referenceChooser,
}
