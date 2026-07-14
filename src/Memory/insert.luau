--!strict
--!nolint LocalUnused
--!nolint LocalShadow
local task = nil -- Disable usage of Roblox's task scheduler

--[[
	Inserts clean up tasks passed in to the scope.
]]
local Package = script.Parent.Parent
local Types = require(Package.Types)

local function insert<Tasks...>(scope: Types.Scope<unknown>, ...: Tasks...): Tasks...
    local tasks = scope :: { Types.Task }
    for index = 1, select("#", ...) do
        table.insert(tasks, (select(index, ...)))
    end
    return ...
end

return insert
