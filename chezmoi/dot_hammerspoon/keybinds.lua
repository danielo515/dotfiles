local chrome_app_name = "Google Chrome"
local ws = require("windowing")

local hyperApps = {
	{ key = "1", appName = "Slack" },
	{ key = "2", appName = "Kitty", layout = "com.apple.keylayout.US" },
	{ key = "4", appName = "Arc" },
}

local hyper = { "cmd", "shift", "alt", "ctrl" }

hs.fnutils.each(hyperApps, function(item)
	hs.hotkey.bind(hyper, item.key, function()
		hs.application.launchOrFocus(item.appName)
		local app = hs.appfinder.appFromName(item.app)
		if app then
			app:activate()
			app:unhide()
		end
		if item.layout ~= nil then
			hs.keycodes.setLayout(item.layout)
		end
	end)
end)

hs.hotkey.bind(hyper, "3", function()
	local opened = hs.application.launchOrFocus(chrome_app_name)
	if opened then
		hs.window.find(chrome_app_name):centerOnScreen()
	end
end)

-- Create a hotkey to trigger the script for Finder
hs.hotkey.bind(hyper, "F", function()
	ws.arrangeAppWindowsInGrid("Finder")
end)

hs.hotkey.bind(hyper, "space", function()
	hs.grid.show()
end)

-- Get the currently focused application and put all its windows in a grid
local function mainAppToGrid()
	local mainApp = hs.application.frontmostApplication()
	local mainAppName = mainApp:title()
	ws.arrangeAppWindowsInGrid(mainAppName)
end

hs.hotkey.bind(hyper, "g", mainAppToGrid)

-- toggle the hammerspoon console, focusing on the previous app when hidden
local lastApp = nil
local function toggleConsole()
	local frontmost = hs.application.frontmostApplication()
	hs.toggleConsole()
	if frontmost:bundleID() == "org.hammerspoon.Hammerspoon" then
		if lastApp ~= nil then
			lastApp:activate()
			lastApp = nil
		end
	else
		lastApp = frontmost
	end
end
hs.hotkey.bind(hyper, "c", toggleConsole)

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

hs.hotkey.bind(hyper, "w", focusChromeTab("WhatsApp"))
hs.hotkey.bind(hyper, "i", focusChromeTab("inbox"))
