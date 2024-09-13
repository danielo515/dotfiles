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
	local result = hs.execute(yabaiPath .. " -m query " .. command)
	return hs.json.decode(result)
end

function yabaiWindows()
	return yabaiQuery("--windows id,app,title")
end

---Queries yabai for the current  space
function yabaiSpace()
	return yabaiQuery("--spaces --space")
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

---binds a key to a yabai command using the default modifiers
---that I have chosen for yabai
---@param key string
---@param commands string[]
---@param fallback string?
local function bindYabai(key, commands, fallback)
	local modifiers = { "alt", "control", "shift" }
	if not hs.hotkey.assignable(modifiers, key) then
		hs.alert.show("Conflicting yabai keymap " .. key)
		return
	end
	hs.hotkey.bind(modifiers, key, function()
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
bindYabai("m", { "space --toggle mission-control" })
-- alt("r", { "space --rotate 90" })
bindYabai("t", { "window --toggle float", "window --grid 4:4:1:1:2:2" })

-- special characters
bindYabai("'", { "space --layout stack" })
bindYabai(";", { "space --layout bsp" })
bindYabai("tab", { "space --focus recent" })

---@param key string
---@param commands string[]
---@param fallback string?
local function altControl(key, commands, fallback)
	local modifiers = { "alt", "control" }
	if not hs.hotkey.assignable(modifiers, key) then
		hs.alert.show("Conflicting altShift key " .. key)
		return
	end
	hs.hotkey.bind(modifiers, key, function()
		yabai(commands, fallback)
	end)
end

---Binds a number to a yabai command that sends the current window to that space
---@param number "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "0"
local function yabaiSendToSpace(number)
	local dest = number == "0" and "10" or number
	altControl(number, { "window --space " .. dest, "space --focus " .. dest })
end

for i = 0, 9 do
	local num = tostring(i)
	bindYabai(num, { "space --focus " .. num })
	yabaiSendToSpace(num)
end

-- This allows to set a different alternative command for the l and h, which will be easier than handling that in the loop
bindYabai("l", { "window --focus east" }, "window --focus first")
bindYabai("h", { "window --focus west" }, "window --focus last")
bindYabai("j", { "window --focus south" }, "window --focus north")
bindYabai("k", { "window --focus north" }, "window --focus south")
altControl("l", { "window --swap east" }, "window --swap first")
altControl("h", { "window --swap west" }, "window --swap last")
altControl("j", { "window --swap south" }, "window --swap north")
altControl("k", { "window --swap north" }, "window --swap south")
-- Split window horizontaly
-- altControl("s", { "window --warp south" }, "window --warp north")
altControl("w", { "window --warp west" })
-- VIM style hjkl window movement
local homeRow = { h = "west", j = "south", k = "north", l = "east" }
--for key, direction in pairs(homeRow) do
--altShift(key, { "window --swap " .. direction }, "window --space next")
--end
