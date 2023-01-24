hs.ipc.cliInstall("/opt/homebrew")
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
hs.loadSpoon("EmmyLua")

local retina = "Built-in Retina Display"
local featherWindowTitle = "Feather.*"
local chrome_app_name = "Google Chrome"
local wf = hs.window.filter

local function locateFeather(window)
	local windowLayout = {
		{ nil, window, retina, hs.layout.left50, nil, nil },
	}
	hs.layout.apply(windowLayout)
end

local feather_filter = wf.new(false):setAppFilter(chrome_app_name, { allowTitles = featherWindowTitle })
feather_filter:subscribe(hs.window.filter.windowFocused, locateFeather, true)

local function findWhatsapp()
	local chrome = hs.application.find("Google Chrome")
	local tabName = "whatsapp"
	local chromeWindows = hs.window.filter.new(chrome:name()):setCurrentSpace(nil):getWindows()
	hs.printf("Found: %s chrome windows for chrome name: %s", #chromeWindows, chrome:name())
	print(chromeWindows)

	for _, window in ipairs(chromeWindows) do
		local tabs = hs.tabs.tabWindows(window)
		print(tabs)
		local title = window:title()
		hs.printf("tab: %s", title)
		if string.match(title, tabName) then
			window:focus()
			return
		end
	end
	hs.alert.show("Could not find the window")
end

local function osa()
	local tabName = "whatsapp"
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

	local success, windowID, errors = hs.osascript.applescript(string.format(script, tabName))

	print(success, windowID, type(windowID), hs.inspect(errors))
	if success == false then
		hs.alert.show("Tab with name '" .. tabName .. "' not found.")
	else
		hs.alert.show("Tab '" .. tabName .. "' found and brought to front.")
	end
end

local hyper = { "cmd", "shift", "alt", "ctrl" }
hs.hotkey.bind(hyper, "1", function()
	hs.application.launchOrFocus("Slack")
end)
hs.hotkey.bind(hyper, "2", function()
	hs.application.launchOrFocus("Kitty")
end)
hs.hotkey.bind(hyper, "w", osa)

hs.alert.show("Config loaded", { text = "red" })
