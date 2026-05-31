--!strict

local config = require(game.ReplicatedStorage.Shared.config)
local remotes = require(game.ReplicatedStorage.Shared.remotes)

local bagFactory = require(script.Parent.bagFactory)
local bagsFolder = require(script.Parent.bagsFolder)
local bagMotion = require(script.Parent.bagMotion)
local bagSpawnAnim = require(script.Parent.bagSpawnAnim)

local bagSpawner = {}

local targetBagSize = Vector3.new(2.2, 2.2, 2.2)
local running = false

local function canSpawnMore(): boolean
	return bagsFolder.count() < config.maxBags
end

local function finishBag(bag: BasePart)
	bagMotion.fadeOut(bag, function()
		bag:Destroy()
	end)
end

local function startBagTrip(bag: BasePart)
	bagMotion.runAlong(bag, function()
		finishBag(bag)
	end)
end

function bagSpawner.spawnOne()
	if not canSpawnMore() then
		return
	end

	local bag = bagFactory.create(bagsFolder.get())
	bagSpawnAnim.play(bag, targetBagSize, function()
		startBagTrip(bag)
	end)
end

local function waitInterval()
	local t = remotes.spawnInterval.Value
	if t < 0.15 then
		t = 0.15
	end
	task.wait(t)
end

function bagSpawner.startLoop()
	if running then
		return
	end
	running = true

	task.spawn(function()
		bagSpawner.spawnOne()

		while running do
			waitInterval()
			if canSpawnMore() then
				bagSpawner.spawnOne()
			end
		end
	end)
end

return bagSpawner
