--!strict

local config = require(game.ReplicatedStorage.Shared.config)
local remotes = require(game.ReplicatedStorage.Shared.remotes)

local bagFactory = require(script.Parent.bagFactory)
local bagsFolder = require(script.Parent.bagsFolder)
local bagMotion = require(script.Parent.bagMotion)

local bagSpawner = {}

local loopOn = false

local function roomLeft(): boolean
	return bagsFolder.count() < config.maxBags
end

function bagSpawner.spawnOne()
	if not roomLeft() then
		return
	end

	local bag = bagFactory.create(bagsFolder.get())

	bagMotion.dropAndRide(bag, function()
		if bag.Parent then
			bag:Destroy()
		end
	end)
end

local function waitTick()
	local t = remotes.spawnInterval.Value
	if t < 0.15 then
		t = 0.15
	end
	task.wait(t)
end

function bagSpawner.start()
	if loopOn then
		return
	end
	loopOn = true

	bagsFolder.clear()

	task.spawn(function()
		bagSpawner.spawnOne()

		while loopOn do
			waitTick()
			if roomLeft() then
				bagSpawner.spawnOne()
			end
		end
	end)
end

return bagSpawner
