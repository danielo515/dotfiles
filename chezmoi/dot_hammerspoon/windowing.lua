local function arrangeAppWindowsInGrid(appName)
	-- Get the screen size
	local screenFrame = hs.screen.mainScreen():frame()

	-- Find all windows of the specified application in the current space
	local appWindows = hs.window.filter.new(false):setAppFilter(appName, { currentSpace = true }):getWindows()

	-- Calculate the grid dimensions
	local gridColumns = math.ceil(math.sqrt(#appWindows))
	local gridRows = math.ceil(#appWindows / gridColumns)

	-- Calculate window size for grid
	local windowWidth = screenFrame.w / gridColumns
	local windowHeight = screenFrame.h / gridRows

	-- Calculate the number of windows that need to be taller to fill the gaps
	local windowsInLastRow = #appWindows % gridColumns
	local tallerWindows = windowsInLastRow > 0 and gridColumns - windowsInLastRow or 0

	-- Disable window animations
	local originalAnimationDuration = hs.window.animationDuration
	hs.window.animationDuration = 0

	-- Iterate through windows and position them in the grid
	for index, win in ipairs(appWindows) do
		local row = math.floor((index - 1) / gridColumns)
		local column = (index - 1) % gridColumns

		-- Check if the window is in the row previous to the last one and if its index is within the last columns that need to be taller
		local isRightmostTallerWindow = row == (gridRows - 2) and column >= (gridColumns - tallerWindows)

		local x = screenFrame.x + (column * windowWidth)
		local y = screenFrame.y + (row * windowHeight)

		if isRightmostTallerWindow then
			-- Adjust the size and position of the necessary rightmost windows to fill the gaps
			win:setFrame({ x = x, y = y, w = windowWidth, h = windowHeight * 2 })
		else
			win:setFrame({ x = x, y = y, w = windowWidth, h = windowHeight })
		end

		-- Focus on the window to make it visible
		win:focus()
	end

	-- Refocus on the first window in the list
	if #appWindows > 0 then
		appWindows[1]:focus()
	end

	-- Restore the original window animation duration
	hs.window.animationDuration = originalAnimationDuration
end

return {
	arrangeAppWindowsInGrid = arrangeAppWindowsInGrid,
}
