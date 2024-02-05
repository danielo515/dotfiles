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

local yabaiPath = hs.execute('which yabai')

if yabaiPath == '' or yabaiPath == nil then
    alert.show('yabai not found')
    return
end

yabaiPath = trim(yabaiPath)

-- Helper function to execute yabai commands
-- and return true if the command was successful
-- @param command string
-- @return boolean
local function yabai1(command)
	local _,_,all_ok = os.execute(yabaiPath .. " -m " .. command)
	return all_ok == 0
end


-- executes yabai commands
-- If a command fails, it will try to execute the alt command
-- @param commands table
-- @param alt string an alternative command to execute if the first fails
function yabai(commands, alt)
    -- print("yabaiPath", yabaiPath)
	for _, cmd in ipairs(commands) do
		if not yabai1(cmd) then
			if alt ~= nil then
				os.execute(yabaiPath .. " -m " .. alt )
			else
				hs.alert.show("yabai command failed: " .. cmd)
			end
		end
	end
end

local function alt(key, commands, alt)
	hs.hotkey.bind({ "alt" }, key, function()
		yabai(commands, alt)
	end)
end

-- alpha
alt("f", { "window --toggle zoom-fullscreen" })
alt("m", { "space --toggle mission-control" })
alt("g", { "space --toggle padding", "space --toggle gap" })
alt("r", { "space --rotate 90" })
alt("t", { "window --toggle float", "window --grid 4:4:1:1:2:2" })

-- special characters
alt("'", { "space --layout stack" })
alt(";", { "space --layout bsp" })
alt("tab", { "space --focus recent" })

local function altShift(key, commands)
	hs.hotkey.bind({ "alt", "shift" }, key, function()
		yabai(commands)
	end)
end

local function altShiftNumber(number)
	altShift(number, { "window --space " .. number, "space --focus " .. number })
end

for i = 1, 9 do
	local num = tostring(i)
	alt(num, { "space --focus " .. num })
	altShiftNumber(num)
end

-- NOTE: use as arrow keys
local homeRow = { h = "west", j = "south", k = "north", l = "east" }

for key, direction in pairs(homeRow) do
	alt(key, { "window --focus " .. direction }, "window --focus last")
	altShift(key, { "window --swap " .. direction })
end