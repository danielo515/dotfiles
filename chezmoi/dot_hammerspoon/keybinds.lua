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

-- Define a hotkey to trigger the script
hs.hotkey.bind({ "cmd", "shift" }, "P", function()
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
end)

local hyperApps = {
	{ key = "1", appName = "Slack" },
	{ key = "2", appName = "Kitty", layout = "com.apple.keylayout.US" },
	{ key = "3", callback = focusCenterChrome },
	{ key = "4", appName = "Arc" },
	{
		key = "w",
		callback = function()
			Chrome.jump("whatsapp")
		end,
	},
	{ key = "space", callback = ws.referenceChooser },
	{ key = "g", callback = mainAppToGrid },
	{ key = "c", callback = toggleConsole },
	{ key = "i", callback = ws.debugWindow },
}

local hyper = { "cmd", "shift", "alt", "ctrl" }

hs.fnutils.each(hyperApps, function(item)
	if item.callback ~= nil then
		hs.hotkey.bind(hyper, item.key, item.callback)
		return
	end
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
