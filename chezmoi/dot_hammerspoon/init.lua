hs.ipc.cliInstall("/opt/homebrew")
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
hs.loadSpoon("EmmyLua")
hs.grid.setGrid("10x6")

local retina = "Built-in Retina Display"
local primaryScreen = hs.screen.primaryScreen()
local featherWindowTitle = "Feather.*"
local chrome_app_name = "Google Chrome"
local tella_dev_window_title = "Danielo.*Tella "
local wf = hs.window.filter
local positions = require("windowing").positions
Chrome = require("browser")("Google Chrome")

local function locateFeather(window)
	local windowLayout = {
		{ nil, window, retina, hs.layout.left50, nil, nil },
	}
	hs.layout.apply(windowLayout)
end

local function subscribeToFocus(appName, callback, filterOptions)
	local options = filterOptions or {}
	wf.new(false):setAppFilter(appName, options):subscribe(hs.window.filter.windowFocused, callback, true)
end

subscribeToFocus(chrome_app_name, locateFeather, { allowTitles = featherWindowTitle })
-- Slack listener
subscribeToFocus("Slack", function(window)
	local layout = {
		{ nil, window, primaryScreen, hs.geometry.rect(0.3, 0, 0.45, 0.95), nil, nil },
	}
	hs.layout.apply(layout)
end, { rejectTitles = "Huddle" })

-- Whenever we focus kitty, we position chrome to the right so we can see references
-- or the web app we are working with
subscribeToFocus("kitty", function(window)
	local function notHuddle(name, title)
		return not name:match("Huddle")
	end

	local layout = {
		{ nil, window, primaryScreen, hs.layout.right70, nil, nil },
		{ chrome_app_name, nil, primaryScreen, positions.left34, nil, nil },
		{ "time tracker", nil, retina, positions.right30, nil, nil },
		{ "Slack", "Huddle", retina, positions.left50, nil, nil },
	}
	hs.layout.apply(layout, notHuddle)
end)

require("keybinds")
require("auto_tile")
require("auto_flasher")

hs.loadSpoon("Hyper")

App = hs.application
Hyper = spoon.Hyper

Hyper:bindHotKeys({ hyperKey = { {}, "F1" } })

Hyper:bind({}, "j", function()
	App.launchOrFocusByBundleID("net.kovidgoyal.kitty")
end)

hs.alert.show("Config loaded", { text = "red" })
