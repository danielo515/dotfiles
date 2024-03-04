local chrome_app_name = "Google Chrome"
local ws = require("windowing")

local function focusCenterChrome()
	local opened = hs.application.launchOrFocus(chrome_app_name)
	if opened then
		hs.window.find(chrome_app_name):centerOnScreen()
	end
end

-- Get the currently focused application and put all its windows in a grid
local function mainAppToGrid()
	local mainApp = hs.application.frontmostApplication()
	local mainAppName = mainApp:title()
	ws.arrangeAppWindowsInGrid(mainAppName)
end

-- Puts the 3 most recen windows in a nice grid
local function gridRecents()
	hs.grid.setGrid("10x10")
	local windows = hs.window.filter.new():getWindows()
	local screen = hs.screen.mainScreen()
	hs.grid.set(windows[1], { x = 5, y = 0, w = 5, h = 10 }, screen)
	hs.grid.set(windows[2], { x = 0, y = 0, w = 5, h = 5 }, screen)
	hs.grid.set(windows[3], { x = 0, y = 5, w = 5, h = 5 }, screen)
end

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

-- Edit the current picture in the clipboard
local function editClipboardImage()
	-- Check if an image is in the clipboard
	local image = hs.pasteboard.readImage()
	if not image then
		hs.alert.show("No image in clipboard")
		return
	end

	-- Save the image to a temporary file
	local tmpfile = os.tmpname() .. ".png"
	image:saveToFile(tmpfile)

	-- Open the image in Preview and start annotation
	hs.execute("open -a Preview " .. tmpfile)
	hs.timer.doAfter(1, function()
		hs.appfinder.appFromName("Preview"):selectMenuItem({ "Tools", "Annotate", "Arrow" })
	end)
end

local function slackWeb()
	Chrome.jump("slack")
end

local US_LAYOUT = "com.apple.keylayout.US"
local hyperApps = {
	-- { key = "s", appName = "Slack", layout = US_LAYOUT },
	{ key = "s", callback = slackWeb, layout = US_LAYOUT },
	{ key = "t", appName = { "Alacritty", "Kitty" }, layout = US_LAYOUT },
	{ key = "3", appName = "Google Chrome" },
	{ key = "4", appName = "Firefox" },
	{ key = "o", appName = "Obsidian" },
	{
		key = "w",
		callback = function()
			Chrome.jump("whatsapp")
		end,
	},
	{ key = "space", callback = ws.referenceChooser },
	-- { key = "v", callback = ws.window_menu },
	-- { key = "g", callback = mainAppToGrid },-- yabai is handling grid now
	-- { key = "f", callback = gridRecents }, -- yabai is handling grid now
	{ key = "v", appName = "Code" },
	{ key = "c", callback = toggleConsole },
	{ key = "i", callback = ws.debugWindow },
	{ key = "p", callback = editClipboardImage },
}
-- Define the combination that is considered the hyper key
local hyper = { "cmd", "shift", "alt", "ctrl" }
-- Bind all the actions to the different hyper key combinations
hs.fnutils.each(hyperApps, function(item)
	if item.callback ~= nil then
		hs.hotkey.bind(hyper, item.key, item.callback)
		return
	end
	hs.hotkey.bind(hyper, item.key, function()
		-- if appName is a list, then first look for opened windows of the provided list
		-- and focus the first we find. If not, then fall back to activate the first app in the list
		local appName = item.appName -- shortcut and also re-used below for the table fallback
		if type(item.appName) ~= "table" then
			appName = { item.appName }
		end
		for _, name in ipairs(appName) do
			-- We prefer to use an already existing window in the current space if possible
			local appWindows = hs.window.filter.new(false):setAppFilter(name, { currentSpace = true }):getWindows()
			if #appWindows > 0 then
				print("found app window in current space", name)
				appWindows[1]:focus()
				return
			end
			local app = hs.appfinder.appFromName(name)
			if app then
				print("found app open", name)
				app:activate()
				app:unhide()
				if item.layout ~= nil then
					hs.keycodes.setLayout(item.layout)
				end
				return
			end
		end
		-- fallback to launch or focus
		hs.application.launchOrFocus(appName[1])
	end)
end)
