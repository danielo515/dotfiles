--- === FileWatcher ===
---
--- File organization spoon that watches directories and moves files based on rules
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/FileWatcher.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/FileWatcher.spoon.zip)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "FileWatcher"
obj.version = "1.0"
obj.author = "Hammerspoon"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

---@class FileWatcher
---@field logger hs.logger
---@field watchers table<string, { watcher: hs.pathwatcher, rules: Rule[] }>
---@field name string
---@field version string
---@field author string
---@field homepage string
---@field license string

---@class Rule
---@field pattern string # Lua pattern to match filename
---@field destination string # Path where matching files should be moved
---@field action? "move" # Action to take (currently only "move" is supported)

-- Logger object used within the Spoon
obj.logger = hs.logger.new("FileWatcher")

-- Table containing all active directory watchers
obj.watchers = {}

---Expands tilde in path to user's home directory
---@param path string # Path that might contain tilde
---@return string # Path with tilde expanded to home directory
local function expandTilde(path)
	if path:sub(1, 1) == "~" then
		return os.getenv("HOME") .. path:sub(2)
	end
	return path
end

---Ensures path ends with a trailing slash
---@param path string # Path to check
---@return string # Path with trailing slash
local function ensureTrailingSlash(path)
	if path:sub(-1) ~= "/" then
		return path .. "/"
	end
	return path
end

---Extracts filename from a full path
---@param path string # Full file path
---@return string? # Filename or nil if no filename found
local function getFilename(path)
	return path:match("([^/]+)$")
end

---Gets file extension from filename
---@param filename string # Filename to extract extension from
---@return string # Extension without dot or empty string if no extension
local function getFileExtension(filename)
	return filename:match("%.([^%.]+)$") or ""
end

---Gets filename without extension
---@param filename string # Filename including extension
---@return string # Filename without extension
local function getBasename(filename)
	local ext = getFileExtension(filename)
	if ext ~= "" then
		return filename:sub(1, #filename - #ext - 1)
	end
	return filename
end

---Checks if a path exists
---@param path string # Path to check
---@return boolean # true if path exists, false otherwise
local function directoryExists(path)
	local file = io.open(path, "r")
	if file then
		io.close(file)
		return true
	end
	return false
end

---Creates a directory and its parent directories if they don't exist
---@param path string # Path to create
---@return boolean # true if directory was created or exists, false otherwise
local function createDirectory(path)
	path = expandTilde(path)
	if directoryExists(path) then
		return true
	end
	return os.execute('mkdir -p "' .. path .. '"') == 0
end

---Initialize the spoon
---@return FileWatcher
function obj:init()
	self.watchers = {}
	return self
end

---Process a single file according to the given rules
---@param file string # Full path to the file
---@param rules Rule[] # Array of rules to apply
---@return boolean # true if file was processed successfully, false otherwise
function obj:processFile(file, rules)
	local filename = getFilename(file)
	if not filename then
		return false
	end

	for _, rule in ipairs(rules) do
		local pattern = rule.pattern
		local destination = expandTilde(rule.destination)
		local action = rule.action or "move"

		if string.match(filename:lower(), pattern:lower()) then
			if action == "move" then
				-- Ensure destination directory exists
				if not createDirectory(destination) then
					self.logger.e(string.format("Failed to create directory %s", destination))
					return false
				end

				destination = ensureTrailingSlash(destination)
				local destPath = destination .. filename

				-- If file already exists at destination, append number
				local counter = 1
				while directoryExists(destPath) do
					local ext = getFileExtension(filename)
					local basename = getBasename(filename)
					destPath =
						string.format("%s%s_%d%s", destination, basename, counter, ext ~= "" and "." .. ext or "")
					counter = counter + 1
				end

				-- Move the file using os.rename
				local success, err = os.rename(file, destPath)
				if success then
					self.logger.i(string.format("Moved %s to %s", filename, destPath))
				else
					self.logger.e(string.format("Failed to move %s to %s: %s", filename, destPath, err))
				end
				return success
			end
		end
	end
	return false
end

---Start watching a directory with the specified rules
---@param directory string # Directory path to watch
---@param rules Rule[] # Array of rules to apply to matching files
---@return FileWatcher # The FileWatcher instance
function obj:watchDirectory(directory, rules)
	-- Expand the directory path
	directory = expandTilde(directory)
	directory = ensureTrailingSlash(directory)
	self.logger.i("Attemtp to watch directory: " .. directory)

	-- Create watcher for the directory
	local watcher = hs.pathwatcher.new(directory, function(files)
		for _, file in ipairs(files) do
			-- Check if it's a file (not a directory) using io.open
			local f = io.open(file, "r")
			if f then
				f:close()
				self:processFile(file, rules)
			end
		end
	end)

	-- Start the watcher
	watcher:start()

	-- Store the watcher
	self.watchers[directory] = {
		watcher = watcher,
		rules = rules,
	}

	self.logger.i(string.format("Started watching %s", directory))
	return self
end

---Stop watching a directory
---@param directory string # Directory path to stop watching
---@return FileWatcher # The FileWatcher instance
function obj:stopWatching(directory)
	directory = expandTilde(directory)
	directory = ensureTrailingSlash(directory)

	if self.watchers[directory] then
		self.watchers[directory].watcher:stop()
		self.watchers[directory] = nil
		self.logger.i(string.format("Stopped watching %s", directory))
	end
	return self
end

---Stop all directory watchers
---@return FileWatcher # The FileWatcher instance
function obj:stopAllWatchers()
	for directory, _ in pairs(self.watchers) do
		self:stopWatching(directory)
	end
	return self
end

return obj
