local Log = require "lvim.core.log"

local function is_file_ok(filePath)
  if vim.fn.filereadable(filePath) == 0 then
    Log:error("The provided file path does not exist: " .. filePath)
    return false
  end
  return true
end

--- Given a file path, reads it as json file
---@param path string
---@return table | nil
local function read_json_file(path)
  if not is_file_ok(path) then
    return nil
  end
  local content = vim.fn.readfile(path)
  local data = vim.fn.json_decode(content)
  return data
end

--- Reads a file from the current working directory
---@param filename string name of the file
---@return nil | table
local function read_local_json_file(filename)
  local filePath = join_paths(vim.fn.getcwd(), filename)
  if not is_file_ok(filePath) then
    return nil
  end
  local data = read_json_file(filePath)
  return data
end

local function read_relative_json_file(relative_path)
  local filePath = join_paths(vim.fn.expandcmd "%:p:h", relative_path)
  if not is_file_ok(filePath) then
    return nil
  end
  local data = read_json_file(filePath)
  return data
end

return {
  read_relative_json_file = read_relative_json_file,
  read_local_json_file = read_local_json_file,
  read_json_file = read_json_file,
  is_file_ok = is_file_ok,
}
