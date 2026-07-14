--!strict
--!nolint LocalUnused
--!nolint LocalShadow
local task = nil -- Disable usage of Roblox's task scheduler

--[[
	Evaluates the graph object if necessary, so that it is up to date.
	Returns true if it meaningfully changed.

	https://fluff.blog/2024/04/16/monotonic-painting.html
]]

local Package = script.Parent.Parent
local Types = require(Package.Types)
local External = require(Package.External)

local function evaluate(target: Types.GraphObject, forceComputation: boolean): boolean
    if target.validity == "busy" then
        External.logError("infiniteLoop")
        return false
    end
    local firstEvaluation = target.lastChange == nil
    local isInvalid = target.validity == "invalid"
    if firstEvaluation or isInvalid or forceComputation then
        local needsComputation = firstEvaluation or forceComputation
        if not needsComputation then
            for dependency in target.dependencySet do
                evaluate(dependency, false)
                -- target.lastChange is provably non-nil here (firstEvaluation
                -- is false in this branch), and a nil dependency.lastChange
                -- means it's never meaningfully changed, so it can't be
                -- newer than target -- but both are optional numbers to the
                -- type checker, which can't compare `number?` with `>`.
                if dependency.lastChange ~= nil and target.lastChange ~= nil and dependency.lastChange > target.lastChange then
                    needsComputation = true
                    break
                end
            end
        end
        local targetMeaningfullyChanged = false
        if needsComputation then
            for dependency in target.dependencySet do
                dependency.dependentSet[target] = nil
                target.dependencySet[dependency] = nil
            end
            target.validity = "busy"
            targetMeaningfullyChanged = target:_evaluate() or firstEvaluation
        end
        if targetMeaningfullyChanged then target.lastChange = os.clock() end
        target.validity = "valid"
        return targetMeaningfullyChanged
    else
        return false
    end
end

return evaluate
