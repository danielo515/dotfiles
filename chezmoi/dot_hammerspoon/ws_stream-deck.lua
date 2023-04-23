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
local contexts = {}
local module = {
	server = nil,
}

-- Utility functions
---@param tbl table
---@param keyPath string
---@return any
local function getValueForKeyPath(tbl, keyPath)
	local keys = hs.fnutils.split(keyPath, ".", nil, true)
	local value = tbl

	for _, key in ipairs(keys) do
		value = value[key]
		if value == nil then
			return nil
		end
	end

	return value
end

---@param imagePath string
---@return string|nil
local function loadImageAsBase64(imagePath)
	local image = hs.image.imageFromPath(imagePath)
	if image then
		local imageData = image:encodeAsURLString()
		return imageData
	end
	return nil
end

-- Message handling functions
---@param id string
---@param imagePath string
---@return Event|nil
local function getImageMessage(id, imagePath)
	local imageBase64 = loadImageAsBase64(imagePath)
	if imageBase64 then
		return {
			event = "setImage",
			context = contexts[id],
			payload = {
				image = imageBase64,
				target = 0,
				state = 0,
			},
		}
	else
		hs.alert.show("Image not loaded: " .. imagePath)
		return nil
	end
end

---@param msg string
---@return string|nil
local function msgHandler(msg)
	local params = json.decode(msg)
	if params == nil then
		return
	end

	local event = params.event
	if event == nil then
		return
	end

	local id = getValueForKeyPath(params, "payload.settings.id")
	if id ~= nil and contexts[id] == nil then
		contexts[id] = params.context
		print("context added for id: " .. id)
		module.resetTitle(id, "Not loaded")
	end

	local response = {}
	if event == "keyDown" then
		if id == nil or contexts[id] == nil then
			return
		end
		response = { event = "showOk", context = contexts[id] }
	elseif event == "willAppear" then
		if id == "loadImage" then
			local imagePath = "~/Pictures/tv-test.png"
			response = getImageMessage(id, imagePath) or {}
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
module.server = server

---@param id string
---@param title string
function module.resetTitle(id, title)
	if id == nil or contexts[id] == nil then
		return
	end
	local message = { event = "setTitle", context = contexts[id], payload = { title = title, target = 0, state = 0 } }
	server:send(json.encode(message))
end

---@param id string
---@param title string
function module.setTitle(id, title)
	if id == nil or contexts[id] == nil then
		return
	end
	local message = { event = "setTitle", context = contexts[id], payload = { title = title, target = 0, state = 0 } }
	server:send(json.encode(message))
end

return module
