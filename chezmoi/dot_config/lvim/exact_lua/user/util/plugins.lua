local u = require "user.util.files"
local log = require "lvim.core.log"

local get_default_sha1 = function(spec, default_sha1)
  local short_name, _ = require("packer.util").get_plugin_short_name(spec)
  return default_sha1[short_name] and default_sha1[short_name].commit
end

---Performs the real injection, recursively if needed
---@param plugins_list table
---@param default_sha1 table
---@return table
local function inject_rec(plugins_list, default_sha1)
  local result = vim.tbl_map(function(spec)
    if type(spec) ~= "table" then
      log:debug(
        "There is an entry that is not a table in the plugins list: " .. vim.inspect(spec),
        { title = "Danielo" }
      )
      spec = { spec, commit = "" }
    end
    if type(spec[1]) == "table" then
      spec = inject_rec(spec, default_sha1)
    else
      spec["commit"] = get_default_sha1(spec, default_sha1)
    end
    return spec
  end, plugins_list)
  return result
end

--- Injects the commits that are part of the packer snapshot into the provided list of plugins
---@param plugins_list table
---@param snapshot_path string the path of the snapshot where you want to extract commits from
---@return table
local function inject_snapshot_commit(plugins_list, snapshot_path)
  local default_sha1 = u.read_json_file(snapshot_path)
  log:debug("list of plugins read? " .. vim.inspect(default_sha1 ~= nil))
  if default_sha1 == nil then
    log:warn "Can't load plugins snapshot"
    return plugins_list
  end
  return inject_rec(plugins_list, default_sha1)
end

---Takes a packer snapshot to the provided path.
-- if no path is provided, then it defaults to current lunarvim config directory and
-- the file is named packer_lock.json
local function take_snapshot(snapshot_path)
  local ok, packer = pcall(require, "packer")
  if not ok then
    return
  end
  snapshot_path = snapshot_path or join_paths(get_config_dir(), "packer_lock.json")
  packer.snapshot(snapshot_path)
  return snapshot_path
end

-- Exports
return {
  inject_snapshot_commit = inject_snapshot_commit,
  take_snapshot = take_snapshot,
}
