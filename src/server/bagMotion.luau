--!strict

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local config = require(game.ReplicatedStorage.Shared.config)
local conveyerRefs = require(game.ReplicatedStorage.Shared.conveyerRefs)

local bagMotion = {}

local fadeInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

type rideState = {
	phase: "fall" | "ride",
	rideDist: number,
	onDone: () -> (),
	touchConn: RBXScriptConnection?,
	fallTimer: thread?,
}

local active: { [BasePart]: rideState } = {}
local hbConn: RBXScriptConnection? = nil

local function beltEntry(): Vector3
	local fwd = conveyerRefs.forward()
	return conveyerRefs.belt().Position - fwd * (config.beltLength / 2)
end

local function startRide(bag: BasePart, state: rideState)
	local fwd = conveyerRefs.forward()

	state.phase = "ride"
	state.rideDist = (bag.Position - beltEntry()):Dot(fwd)

	bag.Anchored = true
	bag.CanCollide = false
	bag.AssemblyLinearVelocity = Vector3.zero
	bag.AssemblyAngularVelocity = Vector3.zero
	bag.CFrame = conveyerRefs.snapBag(bag, bag.Position)

	if state.touchConn then
		state.touchConn:Disconnect()
		state.touchConn = nil
	end
	if state.fallTimer then
		task.cancel(state.fallTimer)
		state.fallTimer = nil
	end
end

local function finishBag(bag: BasePart, state: rideState)
	active[bag] = nil

	if state.touchConn then
		state.touchConn:Disconnect()
	end
	if state.fallTimer then
		task.cancel(state.fallTimer)
	end

	bag.Anchored = true
	bagMotion.despawn(bag, state.onDone)
end

local function ensureHeartbeat()
	if hbConn then
		return
	end

	hbConn = RunService.Heartbeat:Connect(function(dt)
		local fwd = conveyerRefs.forward()
		local entry = beltEntry()

		for bag, state in active do
			if not bag.Parent then
				active[bag] = nil
				continue
			end

			if state.phase == "ride" then
				state.rideDist += config.beltSpeed * dt
				local worldPos = entry + fwd * state.rideDist
				bag.CFrame = conveyerRefs.snapBag(bag, worldPos)

				if state.rideDist >= config.beltLength then
					finishBag(bag, state)
				end
			end
		end
	end)
end

function bagMotion.dropAndRide(bag: BasePart, onDone: () -> ())
	ensureHeartbeat()

	local belt = conveyerRefs.belt()

	bag.Anchored = false
	bag.CanCollide = true
	bag.CFrame = conveyerRefs.dropCf(bag.Size)

	local state: rideState = {
		phase = "fall",
		rideDist = 0,
		onDone = onDone,
	}

	active[bag] = state

	state.touchConn = bag.Touched:Connect(function(hit)
		if state.phase ~= "fall" then
			return
		end
		if hit ~= belt then
			return
		end
		startRide(bag, state)
	end)

	state.fallTimer = task.delay(4, function()
		if state.phase ~= "fall" or not bag.Parent then
			return
		end
		bag.CFrame = conveyerRefs.placementCf(bag.Size)
		startRide(bag, state)
	end)
end

function bagMotion.despawn(bag: BasePart, onDone: () -> ())
	local tween = TweenService:Create(bag, fadeInfo, {
		Transparency = 1,
		Size = bag.Size * 0.4,
	})
	tween.Completed:Once(function()
		onDone()
	end)
	tween:Play()
end

return bagMotion
