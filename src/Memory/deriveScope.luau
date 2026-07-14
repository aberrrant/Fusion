--!strict
--!nolint LocalUnused
--!nolint LocalShadow
local task = nil -- Disable usage of Roblox's task scheduler

--[[
	Creates an empty scope with the same metatables as the original scope. Used
	for preserving access to constructors when creating inner scopes.

	This is the public version of the function, which implements external
	debugging hooks.
]]
local Package = script.Parent.Parent
local Types = require(Package.Types)
local ExternalDebug = require(Package.ExternalDebug)
local deriveScopeImpl = require(Package.Memory.deriveScopeImpl)

local function deriveScope(...)
    -- Same reasoning as innerScope.luau: forwarding an untyped vararg pack
    -- into deriveScopeImpl's overloaded generic type can't match any single
    -- overload, so this call is narrowed to `any`.
    local scope = (deriveScopeImpl :: any)(...)
    ExternalDebug.trackScope(scope)
    return scope
end

-- deriveScope's inferred type (forwarding untyped `...` into deriveScopeImpl)
-- shares no structure with the overloaded generic constructor type below, so
-- this has to go through `any` same as deriveScopeImpl's own last line does.
return (deriveScope :: any) :: Types.DeriveScopeConstructor
