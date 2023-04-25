local fileToWatch = "/tmp/webhook"
local statusbar = hs.menubar.new()

local function updateStatusbar(timeStamp)
	statusbar:setTitle("📟 " .. timeStamp)
end

function fileWatcher(...)
	print(hs.inspect({ ... }))
	local timeStamp = os.date("%Y-%m-%d %H:%M:%S")
	hs.alert.show(fileToWatch .. " has been modified " .. timeStamp)
	updateStatusbar(timeStamp)
end

local watcher = hs.pathwatcher.new(fileToWatch, fileWatcher):start()

return watcher
