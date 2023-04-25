local M = {}

local alertStyle = {
	atScreenEdge = 0,
	fadeInDuration = 0.15,
	fadeOutDuration = 0.15,
	fillColor = {
		alpha = 0.75,
		white = 0,
	},
	radius = 10,
	strokeColor = {
		alpha = 1,
		white = 1,
	},
	strokeWidth = 2,
	textColor = {
		alpha = 1,
		red = 1,
	},
	textFont = ".AppleSystemUIFont",
	textSize = 27,
}

function M.important(msg)
	hs.alert.show(msg, alertStyle)
end

function M.info(msg)
	hs.alert.show(msg, hs.alert.defaultStyle)
end

return M
