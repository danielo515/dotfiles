local hshttp = hs.http
local json = hs.json

local M = {
	timer = nil,
	latestUrl = nil,
	latestResponse = nil,
	log = hs.logger.new("watch-vercel", "debug"),
}

-- Define an enum for possible states
local DeploymentState = {
	BUILDING = "BUILDING",
	READY = "READY",
	ERROR = "ERROR",
}

--@param onUpdate function(status:string) - Called when the status changes
--@param teamId string - The team ID
--@param token string - The Vercel API token
function M.start(onUpdate, teamId, token)
	local function callback(status, body, headers)
		if status ~= 200 then
			M.log.e("Error:", status, body)
			return
		end
		local data = json.decode(body)
		M.latestResponse = data
		if data == nil then
			M.log.e("Error: data is nil")
			return
		end
		local deployments = data["deployments"]

		-- Find the first build with the specified author email
		local firstBuildStatus = nil
		for _, deployment in ipairs(deployments) do
			local creator = deployment["creator"]
			if creator and creator["email"] == "danielo@tella.tv" then
				firstBuildStatus = deployment["state"]
				M.latestUrl = deployment["inspectorUrl"]
				break
			end
		end

		-- print(hs.inspect(data))
		-- Print the status if found, or a not found message
		if firstBuildStatus then
			onUpdate(firstBuildStatus)
		else
			M.log.i("No builds found for danielo@tella.tv")
		end
		M.timer = hs.timer.doAfter(20, function()
			M.start(onUpdate, teamId, token)
		end)
	end

	local url = "https://api.vercel.com/v6/deployments?teamId=" .. teamId
	local headers = {
		["Accept"] = "*/*",
		["Authorization"] = "Bearer " .. token,
		["Cache-Control"] = "max-age=0",
		["Sec-Fetch-Dest"] = "empty",
		["Sec-Fetch-Mode"] = "cors",
		["Sec-Fetch-Site"] = "cross-site",
	}
	M.log.i("Fetching", url)
	hshttp.asyncGet(url, headers, callback)
end

function M.openLatest()
	if M.latestUrl ~= nil then
		hs.urlevent.openURL(M.latestUrl)
	else
		hs.alert.show("No latest URL")
	end
end

return M
