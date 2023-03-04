local M = {}

function M.filename_without_extension()
  return vim.fn.expand "%:t:r"
end

function M.full_path_without_extension()
  return vim.fn.expand "%:p:r"
end

function M.is_file_ok(filePath)
  if vim.fn.filereadable(filePath) == 0 then
    return false
  end
  return true
end

--- Given a file path, reads it as json file
---@param path string
---@return table | nil
function M.read_json_file(path)
  if not M.is_file_ok(path) then
    return nil
  end
  local content = vim.fn.readfile(path)
  local data = vim.fn.json_decode(content)
  return data
end

--- Reads a file from the current working directory
---@param filename string name of the file
---@return nil | table
function M.read_local_json_file(filename)
  local filePath = join_paths(vim.fn.getcwd(), filename)
  if not M.is_file_ok(filePath) then
    return nil
  end
  local data = M.read_json_file(filePath)
  return data
end

function M.read_relative_json_file(relative_path)
  local filePath = join_paths(vim.fn.expandcmd "%:p:h", relative_path)
  if not M.is_file_ok(filePath) then
    return nil
  end
  local data = M.read_json_file(filePath)
  return data
end

return M
