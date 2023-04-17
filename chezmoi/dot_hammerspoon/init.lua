hs.ipc.cliInstall("/opt/homebrew")
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
hs.loadSpoon("EmmyLua")

local retina = "Built-in Retina Display"
local primaryScreen = hs.screen.primaryScreen()
local featherWindowTitle = "Feather.*"
local chrome_app_name = "Google Chrome"
local tella_dev_window_title = "Danielo.*Tella "
local wf = hs.window.filter
local positions = require("windowing").positions

local function locateFeather(window)
	local windowLayout = {
		{ nil, window, retina, hs.layout.left50, nil, nil },
	}
	hs.layout.apply(windowLayout)
end

local function subscribeToFocus(appName, callback)
	wf.new(false):setAppFilter(appName, {}):subscribe(hs.window.filter.windowFocused, callback, true)
end

local feather_filter = wf.new(false):setAppFilter(chrome_app_name, { allowTitles = featherWindowTitle })
feather_filter:subscribe(hs.window.filter.windowFocused, locateFeather, true)
-- Slack listener
wf.new(false):setAppFilter("Slack", {}):subscribe(hs.window.filter.windowFocused, function(window)
	local layout = {
		{ nil, window, primaryScreen, hs.geometry.rect(0.3, 0, 0.45, 0.95), nil, nil },
	}
	hs.layout.apply(layout)
end, true)

-- Whenever we focus kitty, we position chrome to the right so we can see references
-- or the web app we are working with
subscribeToFocus("kitty", function(window)
	local layout = {
		{ nil, window, primaryScreen, hs.layout.right70, nil, nil },
		{ chrome_app_name, nil, primaryScreen, hs.layout.left50, nil, nil },
		{ "time tracker", nil, retina, positions.right30, nil, nil },
	}
	hs.layout.apply(layout)
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
