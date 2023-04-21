--[[
{
  action = "org.tynsoe.streamdeck.wsproxy.proxy",
  context = "8354545232ac65ce1062784ccd581bab",
  device = "052B523D48DA807DD12736B4A4226765",
  event = "keyDown",
  payload = {
    coordinates = {
      column = 2,
      row = 1
    },
    isInMultiAction = false,
    settings = {
      id = "listWindows",
      remoteServer = "ws://localhost:3094/ws"
    }
  }
--]]
local json = hs.json
local inspect = hs.inspect
local context = nil

-- Function to load an image file from disk and return its base64-encoded representation

local function loadImageAsBase64(imagePath)
	local image = hs.image.imageFromPath(imagePath)
	if image then
		local imageData = image:encodeAsURLString()
		-- local imageBase64 = string.gsub(imageData, "^data:image/png;base64,", "")
		return imageData
	end
	return nil
end

local function msgHandler(msg)
	local params = json.decode(msg)
	local response = {}
	print("event", inspect(params))
	if params == nil then
		return
	end
	local event = params.event
	if event == nil then
		return
	end
	if context ~= params.context then
		context = params.context
		print("context changed: " .. context)
	end

	if event == "keyDown" then
		response = { event = "showOk", context = params.context }
	elseif event == "willAppear" then
		if params.payload.settings.id == "loadImage" then
			local imagePath = "~/Pictures/tv-test.png" -- Set the path to your image file here
			local imageBase64 = loadImageAsBase64(imagePath)
			if imageBase64 then
				response = {
					event = "setImage",
					context = params.context,
					payload = {
						image = imageBase64,
						target = 0,
						state = 0,
					},
				}
			else
				hs.alert.show("Image not loaded: " .. imagePath)
			end
		end
	end

	return json.encode(response)
end

local server = hs.httpserver.new(false, true)
server:setName("stream-deck")
server:setInterface("localhost")
server:setPort(3094)
server:setCallback(function(method, path, headers, body)
	print(method, path, headers, body)
	return "OK", 200, {}
end)

server:websocket("/ws", msgHandler)

local module = {
	server = server,
}

function module.setTitle(title)
	local message = { event = "setTitle", context = context, payload = { title = title, target = 0, state = 0 } }
	server:send(json.encode(message))
end

return module
