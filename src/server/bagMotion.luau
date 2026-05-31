--!strict

local TweenService = game:GetService("TweenService")

local config = require(game.ReplicatedStorage.Shared.config)
local conveyerRefs = require(game.ReplicatedStorage.Shared.conveyerRefs)

local bagMotion = {}

local moveInfo = TweenInfo.new(config.beltLength / config.beltSpeed, Enum.EasingStyle.Linear)
local fadeInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

function bagMotion.trip(bag: BasePart, onDone: () -> ())
	bag.CFrame = conveyerRefs.spawnCf()

	local tween = TweenService:Create(bag, moveInfo, { CFrame = conveyerRefs.endCf() })
	tween.Completed:Once(onDone)
	tween:Play()
end

function bagMotion.despawn(bag: BasePart, onDone: () -> ())
	local tween = TweenService:Create(bag, fadeInfo, {
		Transparency = 1,
		Size = bag.Size * 0.4,
	})
	tween.Completed:Once(onDone)
	tween:Play()
end

return bagMotion
