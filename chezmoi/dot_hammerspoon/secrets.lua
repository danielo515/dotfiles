-- SECRETS
-- Modified from: https://github.com/evantravers/hammerspoon-config/blob/38a7d8c0ad2190d1563d681725628e4399dcbe6c/secrets.lua
-- Really stupid simple loading of secrets into `hs.settings`.

module = {}

function module.start(filename)
	if hs.fs.attributes(filename) then
		hs.settings.set("secrets", hs.json.read(filename))
	else
		hs.alert.show("You need to create a file at " .. filename)
	end
end

return module
