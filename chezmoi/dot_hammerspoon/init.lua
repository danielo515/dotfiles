hs.ipc.cliInstall("/opt/homebrew")
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
StreamDeck = hs.loadSpoon("StreamDeckButton")
StreamDeck:start()
StreamDeck:onWillAppear("vercelStatus", function(context, params)
	print("vercelStatus willAppear", context)
	return StreamDeck.getImageMessage(
		context,
		-- "~/Pictures/danielo515_programmer_fighting_blasphemy_5303f07b-4184-87fb-f043d10e18c2.png"
		"~/Pictures/tv-test.png"
	)
end)
hs.loadSpoon("EmmyLua")
hs.grid.setGrid("10x6")
local stateMachine = require("lib.stateMachine")

WorkStates = stateMachine({
	{ name = "Morning", icon = "~/.config/icons/cool.svg" },
	{ name = "Workout", icon = "~/.config/icons/workout.svg" },
	{ name = "Lunch", icon = "~/.config/icons/burguer.svg" },
})

StreamDeck:onWillAppear("routine", function(context, params)
	local state = WorkStates.getCurrentState()
	local message = StreamDeck:getImageMessage(context, state.icon)
	StreamDeck:setTitle("routine", state.name)
	return message
end)

StreamDeck:onKeyDown("routine", function(context, params)
	local state = WorkStates()
	StreamDeck:setTitle("routine", state.name)
	return StreamDeck:getImageMessage(context, state.icon)
end)

local secrets = require("secrets")
--[[ I specify not a hidden file because it is out of source control
In reality it lives encrypted in the chezmoi repo, and copied there on init ]]
secrets.start("secrets.json")

local retina = "Built-in Retina Display"
local primaryScreen = hs.screen.primaryScreen()
local statusbar = hs.menubar.new()
local featherWindowTitle = "Feather.*"
local chrome_app_name = "Google Chrome"
local wf = hs.window.filter
local positions = require("windowing").positions
WatchVercel = require("watch_vercel")
StreamDeck:onKeyDown("vercelStatus", function()
	print("vercelStatus keyDown")
	WatchVercel.openLatest()
end)
Chrome = require("browser")("Google Chrome")
Danielo = { timer = nil }
local vercel = hs.settings.get("secrets").tella.vercel
WatchVercel.start(function(status)
	StreamDeck:setTitle("vercelStatus", status)
	statusbar:setTitle("🚦" .. status)
end, vercel.teamId, vercel.token)

-- Windows
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

	local windowWidth = hs.window.focusedWindow():frame().w
	if windowWidth < 2000 then
		return
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
require("watch_files")

hs.loadSpoon("Hyper")

App = hs.application
Hyper = spoon.Hyper

Hyper:bindHotKeys({ hyperKey = { {}, "F1" } })

Hyper:bind({}, "j", function()
	App.launchOrFocusByBundleID("net.kovidgoyal.kitty")
end)

require("alert").important("Hammerspoon config loaded")
