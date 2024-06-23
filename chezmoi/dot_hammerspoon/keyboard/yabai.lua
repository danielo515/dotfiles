-- cSpell:words koekeishiya yabai fullscreen unfloat hjkl
--
-- ██╗   ██╗ █████╗ ██████╗  █████╗ ██╗
-- ╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗██║
--  ╚████╔╝ ███████║██████╔╝███████║██║
--   ╚██╔╝  ██╔══██║██╔══██╗██╔══██║██║
--    ██║   ██║  ██║██████╔╝██║  ██║██║
--    ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝
--
-- https://github.com/koekeishiya/yabai
-- Original source: https://github.com/joshmedeski/dotfiles/blob/a1713162226f770fdd27178947fefbdefc6fff2f/.hammerspoon/keyboard/yabai.lua
--
local function trim(str)
	return str:gsub("^%s+", ""):gsub("%s+$", "")
end

local yabaiPath = hs.execute("which yabai", true)

if yabaiPath == "" or yabaiPath == nil then
	hs.alert.show("yabai not found")
	return
end

yabaiPath = trim(yabaiPath)

-- Helper function to execute yabai commands
-- and return true if the command was successful
---@param command string
---@return boolean, string
local function yabai1(command)
	local cmd = yabaiPath .. " -m " .. command
	local _, _, all_ok = os.execute(cmd)
	return all_ok == 0, cmd
end

---@param command string
function yabaiQuery(command)
	local result = hs.execute(yabaiPath .. " -m query --" .. command)
	return hs.json.decode(result)
end

function yabaiWindows()
	return yabaiQuery("windows --window")
end

-- executes yabai commands
-- If a command fails, it will try to execute the alt command
---@param commands string[]
---@param alt string? an alternative command to execute if the first fails
function yabai(commands, alt)
	-- print("yabaiPath", yabaiPath)
	for _, cmd in ipairs(commands) do
		local status, fullCmd = yabai1(cmd)
		if not status then
			if alt ~= nil then
				yabai({ alt })
			else
				hs.alert.show("yabai command failed: " .. fullCmd)
			end
		end
	end
end

---comment
---@param key string
---@param commands string[]
---@param fallback string?
local function bind(key, commands, fallback)
	hs.hotkey.bind({ "alt", "control", "shift" }, key, function()
		yabai(commands, fallback)
	end)
end

local hyperKey = { "cmd", "shift", "alt", "ctrl" }

---@param key string
---@param commands string[]
---@param fallback string?
local function hyper(key, commands, fallback)
	if not hs.hotkey.assignable(hyperKey, key) then
		hs.alert.show("Conflicting hyper key " .. key)
		return
	end
	hs.hotkey.bind(hyperKey, key, function()
		yabai(commands, fallback)
	end)
end

-- alpha
hyper("f", { "window --toggle zoom-fullscreen" })
hyper("z", { "window --toggle zoom-parent" })
hyper("g", { "window --toggle float", "window --grid 2:2:1:1:1:1" })
hyper("right", { "window --east --resize right:50:0" }, "window --resize right:50:0")
hyper("left", { "window --west --resize right:-50:0" }, "window --resize right:-50:0")
bind("m", { "space --toggle mission-control" })
-- alt("r", { "space --rotate 90" })
bind("t", { "window --toggle float", "window --grid 4:4:1:1:2:2" })

-- special characters
bind("'", { "space --layout stack" })
bind(";", { "space --layout bsp" })
bind("tab", { "space --focus recent" })

---@param key string
---@param commands string[]
---@param fallback string?
local function altShift(key, commands, fallback)
	hs.hotkey.bind({ "alt", "shift" }, key, function()
		yabai(commands, fallback)
	end)
end

local function altShiftNumber(number)
	altShift(number, { "window --space " .. number, "space --focus " .. number })
end

for i = 1, 9 do
	local num = tostring(i)
	bind(num, { "space --focus " .. num })
	altShiftNumber(num)
end

-- This allows to set a different alternative command for the l and h, which will be easier than handling that in the loop
bind("l", { "window --focus east" }, "window --focus first")
bind("h", { "window --focus west" }, "window --focus last")
bind("j", { "window --focus south" }, "window --focus north")
bind("k", { "window --focus north" }, "window --focus south")
altShift("l", { "window --swap east" }, "window --swap first")
altShift("h", { "window --swap west" }, "window --swap last")
altShift("j", { "window --swap south" }, "window --swap north")
altShift("k", { "window --swap north" }, "window --swap south")
-- Split window horizontaly
altShift("s", { "window --warp south" }, "window --warp north")
altShift("w", { "window --warp west" })
-- VIM style hjkl window movement
local homeRow = { h = "west", j = "south", k = "north", l = "east" }
--for key, direction in pairs(homeRow) do
--altShift(key, { "window --swap " .. direction }, "window --space next")
--end
