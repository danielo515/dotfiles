-- Automatically copy firmwares to the keyboard
local sourceFilePath = "/Users/danielo/GIT/glove80-zmk-config/glove80.uf2"
local destinationVolumePath = "/Volumes/GLV80LHBOOT"

local function cpyGlove80uf2(data)
	if data.eventType == "added" and data.productName == "Glove80 LH Bootloader" then
		local fileExists = hs.fs.attributes(sourceFilePath, "mode")
		if fileExists == nil then
			hs.notify.new({ title = "File not found", informativeText = "The file to be copied was not found." }):send()
		else
			hs.timer.doAfter(3, function()
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
					hs.printf("Error message: '%s', Status: '%s'", stdout, status)
					hs.printf("CMD: %s", cmd)
					print("Signal: ", signal)
					print("Result: ", result)
				end
			end)
		end
	end
end

local usbWatcher = hs.usb.watcher.new(cpyGlove80uf2)
usbWatcher:start()
return usbWatcher
