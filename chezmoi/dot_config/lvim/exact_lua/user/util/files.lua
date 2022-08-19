local Log = require "lvim.core.log"

--- Given a file path, reads it as json file
---@param path string
---@return table
local function read_json_file(path)
  local content = vim.fn.readfile(path)
  local data = vim.fn.json_decode(content)
  return data
end

--- Reads a file from the current working directory
---@param filename string name of the file
---@return nil | table
local function read_local_json_file(filename)
  local filePath = join_paths(vim.fn.getcwd(), filename)
  if not vim.fn.filereadable(filePath) then
    Log:error("The provided file does not exist: " .. filePath)
    return nil
  end
  local data = read_json_file(filePath)
  return data
end

local function read_relative_json_file(relative_path)
  local filePath = join_paths(vim.fn.expandcmd "%:p:h", relative_path)
  if not vim.fn.filereadable(filePath) then
    Log:error("The provided file path does not exist: " .. filePath)
    return nil
  end
  local data = read_json_file(filePath)
  return data
end

return {
  read_relative_json_file = read_relative_json_file,
  read_local_json_file = read_local_json_file,
  read_json_file = read_json_file,
}
