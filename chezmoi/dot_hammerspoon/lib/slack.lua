local slack = nil;
local M = {}

local function get()
  if slack ~= nil then
    return slack;
  end
  slack = hs.application.get("Slack")
  return slack
end

function M.gotoChat()
  local slack = get()
  if slack == nil then
    return
  end
  slack:selectMenuItem({ "History", "#chat" })
end

return M;
