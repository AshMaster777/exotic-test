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
	local belt = conveyerRefs.belt()
	local look = belt.CFrame.LookVector
	local half = config.beltLength / 2
	local entry = belt.Position - look * half
	local exit = belt.Position + look * half
	local spawnPos = conveyerRefs.spawn().Position

	if (spawnPos - entry).Magnitude <= (spawnPos - exit).Magnitude then
		return look
	end
	return -look
end

function conveyerRefs.spawnCf(): CFrame
	return conveyerRefs.spawn().CFrame
end

function conveyerRefs.snapBag(bag: BasePart, worldPos: Vector3): CFrame
	local belt = conveyerRefs.belt()
	local fwd = conveyerRefs.forward()
	local up = belt.CFrame.UpVector
	local right = belt.CFrame.RightVector

	local rel = worldPos - belt.Position
	local along = rel:Dot(fwd)
	local side = rel:Dot(right)
	local top = up * (belt.Size.Y / 2 + bag.Size.Y / 2 - config.beltEmbed)

	local snapped = belt.Position + fwd * along + right * side + top
	if fwd.Magnitude < 0.001 then
		return CFrame.new(snapped)
	end
	return CFrame.lookAt(snapped, snapped + fwd, up)
end

function conveyerRefs.placementCf(bagSize: Vector3): CFrame
	local spawn = conveyerRefs.spawn()
	local belt = conveyerRefs.belt()
	local flat = spawn.Position - belt.Position
	local along = flat:Dot(conveyerRefs.forward())
	local onBelt = belt.Position + conveyerRefs.forward() * along
	local up = belt.CFrame.UpVector
	local top = up * (belt.Size.Y / 2 + bagSize.Y / 2 - config.beltEmbed)
	local snapped = belt.Position + conveyerRefs.forward() * along + top
	return CFrame.lookAt(snapped, snapped + conveyerRefs.forward(), up)
end

function conveyerRefs.dropCf(bagSize: Vector3): CFrame
	local onBelt = conveyerRefs.placementCf(bagSize)
	local up = conveyerRefs.belt().CFrame.UpVector
	return onBelt + up * config.dropHeight
end

function conveyerRefs.prepBelt()
	local belt = conveyerRefs.belt()
	belt.Anchored = true
	belt.CanCollide = true
end

return conveyerRefs
