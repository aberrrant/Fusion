--!strict
--!nolint LocalUnused
--!nolint LocalShadow
local task = nil -- Disable usage of Roblox's task scheduler

--[[
	Returns the input *only* if it is a state object.
]]

local Package = script.Parent.Parent
local Types = require(Package.Types)

local function castToState<T>(target: T): Types.StateObject<Types.PeekedType<T>>?
    if typeof(target) == "table" and (target :: Types.StateObject<Types.PeekedType<T>>).type == "State" then
        return target :: Types.StateObject<Types.PeekedType<T>>
    else
        return nil
    end
end

return castToState
