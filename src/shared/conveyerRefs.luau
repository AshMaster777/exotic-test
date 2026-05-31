--!strict

local config = require(script.Parent.config)

local conveyerRefs = {}

local conveyer: Model? = nil
local spawnPart: BasePart? = nil
local beltPart: BasePart? = nil

function conveyerRefs.model(): Model
	if conveyer then
		return conveyer
	end

	local m = workspace:WaitForChild(config.conveyerName) :: Model
	conveyer = m
	return m
end

function conveyerRefs.spawn(): BasePart
	if spawnPart then
		return spawnPart
	end

	local p = conveyerRefs.model():WaitForChild(config.spawnName) :: BasePart
	spawnPart = p
	return p
end

function conveyerRefs.belt(): BasePart
	if beltPart then
		return beltPart
	end

	local p = conveyerRefs.model():WaitForChild(config.beltName) :: BasePart
	beltPart = p
	return p
end

function conveyerRefs.forward(): Vector3
	return conveyerRefs.belt().CFrame.LookVector
end

function conveyerRefs.spawnCf(): CFrame
	return conveyerRefs.spawn().CFrame
end

function conveyerRefs.endCf(): CFrame
	return conveyerRefs.spawnCf() + conveyerRefs.forward() * config.beltLength
end

return conveyerRefs
