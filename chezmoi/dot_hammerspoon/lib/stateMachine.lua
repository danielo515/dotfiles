-- Define the createStateMachine function
local function createStateMachine(states)
  -- Define the initial state
  local currentStateIndex = 1
  -- Moves the state forward and returns that state
  local function stateMachine()
    -- Move to the next state
    currentStateIndex = currentStateIndex + 1

    -- If we've reached the end of the list, start from the beginning
    if currentStateIndex > #states then
      currentStateIndex = 1
    end
    return states[currentStateIndex]
  end

  -- Define the reset method
  local function reset()
    currentStateIndex = 1
  end

  local function getCurrentState()
    return states[currentStateIndex]
  end

  -- Return a callable table with both the stateMachine function and the reset method
  return setmetatable({}, {
    __call = stateMachine,
    __index = { reset = reset, getCurrentState = getCurrentState },
  })
end

return createStateMachine
