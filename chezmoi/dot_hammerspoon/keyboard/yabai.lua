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

local yabaiPath = hs.execute('which yabai',true)

if yabaiPath == '' or yabaiPath == nil then
    hs.alert.show('yabai not found')
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

function yabaiQuery(command)
	local result = hs.execute(yabaiPath .. " -m query --" .. command)
	return hs.json.decode(result)
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
alt("z", { "window --toggle zoom-parent" })
alt("m", { "space --toggle mission-control" })
alt("g", { "space --toggle padding", "space --toggle gap" })
alt("r", { "space --rotate 90" })
alt("t", { "window --toggle float", "window --grid 4:4:1:1:2:2" })

-- special characters
alt("'", { "space --layout stack" })
alt(";", { "space --layout bsp" })
alt("tab", { "space --focus recent" })

local function altShift(key, commands, alt)
	hs.hotkey.bind({ "alt", "shift" }, key, function()
		yabai(commands, alt)
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

-- This allows to set a different alternative command for the l and h, which will be easier than handling that in the loop
alt('l', { "window --focus east"}, "window --focus first")
alt('h', { "window --focus west"}, "window --focus last")
alt('j', { "window --focus south"}, "window --focus north")
alt('k', { "window --focus north"}, "window --focus south")
altShift("l", { "window --swap east"   }, "window --swap first")
altShift("h", { "window --swap west"   }, "window --swap last")
altShift("j", { "window --swap south"  }, "window --swap north")
altShift("k", { "window --swap north"  }, "window --swap south")
-- VIM style hjkl window movement
local homeRow = { h = "west", j = "south", k = "north", l = "east" }
--for key, direction in pairs(homeRow) do
	--altShift(key, { "window --swap " .. direction }, "window --space next")
--end