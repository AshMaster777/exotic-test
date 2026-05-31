--!strict

local CollectionService = game:GetService("CollectionService")

local config = require(game.ReplicatedStorage.Shared.config)
local bagId = require(game.ReplicatedStorage.Shared.bagId)
local bagLook = require(game.ReplicatedStorage.Shared.bagLook)

local bagFactory = {}

local bagSize = Vector3.new(2.2, 2.2, 2.2)

function bagFactory.create(parent: Folder): BasePart
	local bag = Instance.new("Part")
	bag.Name = "Bag"
	bag.Size = bagSize
	bag.Anchored = false
	bag.CanCollide = true
	bag.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.35, 0.5)

	bagId.put(bag, bagId.make())

	local mat, col = bagLook.roll()
	bagLook.apply(bag, mat, col)

	local clicker = Instance.new("ClickDetector")
	clicker.MaxActivationDistance = 32
	clicker.Parent = bag

	CollectionService:AddTag(bag, config.bagTag)
	bag.Parent = parent

	return bag
end

return bagFactory
