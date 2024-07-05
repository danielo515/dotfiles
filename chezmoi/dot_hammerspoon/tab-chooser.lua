local Chrome = require("browser")("Google Chrome")

-- Search Functionality
local chooser = hs.chooser.new(function(selection)
	hs.inspect("selection", selection)
	if not selection then
		return
	end
	Chrome.tabById(selection.action)
end)

chooser:rows(5)
chooser:width(20)
chooser:bgDark(true)
chooser:searchSubText(true)

-- Activate the chooser with a hotkey
hs.hotkey.bind({ "ctrl", "alt" }, "Space", function()
	local _, browserTabs, _ = Chrome.getTabs()
	local searchItems = {}
	for _, tab in ipairs(browserTabs) do
		table.insert(searchItems, { text = tab.title, action = tab.id })
	end
	chooser:choices(searchItems)
	chooser:show()
end)
