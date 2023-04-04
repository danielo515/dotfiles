hs.ipc.cliInstall("/opt/homebrew")
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
hs.loadSpoon("EmmyLua")

local retina = "Built-in Retina Display"
local primaryScreen = hs.screen("C49J89x")
local featherWindowTitle = "Feather.*"
local chrome_app_name = "Google Chrome"
local tella_dev_window_title = "Danielo.*Tella "
local wf = hs.window.filter

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
	}
	hs.layout.apply(layout)
end)

local function osa(tabName)
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
		end
	end
end

local hyper = { "cmd", "shift", "alt", "ctrl" }
hs.hotkey.bind(hyper, "1", function()
	hs.application.launchOrFocus("Slack")
end)
hs.hotkey.bind(hyper, "2", function()
	hs.application.launchOrFocus("Kitty")
	hs.keycodes.setLayout("com.apple.keylayout.US")
end)
hs.hotkey.bind(hyper, "3", function()
	local opened = hs.application.launchOrFocus(chrome_app_name)
	if opened then
		hs.window.find(chrome_app_name):centerOnScreen()
	end
end)
hs.hotkey.bind(hyper, "w", osa("whatsapp"))
hs.hotkey.bind(hyper, "i", osa("inbox"))

-- Automatically copy firmwares to the keyboard
local sourceFilePath = "/Users/danielo/GIT/glove80-zmk-config/combined/glove80.uf2"
local destinationVolumePath = "/Volumes/GLV80LHBOOT"

function cpyGlove80uf2(data)
	if data.eventType == "added" and data.productName == "Glove80 LH Bootloader" then
		local fileExists = hs.fs.attributes(sourceFilePath, "mode")
		if fileExists == nil then
			hs.notify.new({ title = "File not found", informativeText = "The file to be copied was not found." }):send()
		else
			hs.timer.doAfter(2, function()
				local cmd = "cp " .. sourceFilePath .. " " .. destinationVolumePath .. "/"
				local stdout, status, signal, result = hs.execute(cmd)
				if result == 0 then
					hs.notify
						.new({
							title = "File copied",
							informativeText = "The file was successfully copied to the external drive.",
						})
						:send()
				else
					hs.notify
						.new({
							title = "Copy failed",
							informativeText = "There was an error copying the file to the external drive.",
						})
						:send()
					hs.printf("Error message: %s", stdout)
				end
			end)
		end
	end
end

usbWatcher = hs.usb.watcher.new(cpyGlove80uf2)
usbWatcher:start()

hs.alert.show("Config loaded", { text = "red" })
