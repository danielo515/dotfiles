local u = require "user.util.files"
local log = require "lvim.core.log"
local default_sha1 = u.read_relative_json_file "../../../snapshots/default.json"
if default_sha1 == nil then
  log:debug "Can't load plugins snapshot"
  return
end

local get_default_sha1 = function(spec)
  local short_name, _ = require("packer.util").get_plugin_short_name(spec)
  return default_sha1[short_name] and default_sha1[short_name].commit
end

--- Injects the commits that are part of the packer snapshot into the provided list of plugins
---@param plugins_list table
local function inject_snapshot_commit(plugins_list)
  return vim.tbl_map(function(spec)
    if type(spec) ~= "table" then
      log:debug("There is an entry that is not a table in the plugins list: " .. spec, { title = "Danielo" })
      spec = { spec, commit = "" }
    end
    spec["commit"] = get_default_sha1(spec)
    return spec
  end, plugins_list)
end

vim.pretty_print(inject_snapshot_commit(require "user.plugins"))

return {
  inject_snapshot_commit = inject_snapshot_commit,
}
