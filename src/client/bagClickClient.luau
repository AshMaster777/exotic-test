--!strict

local CollectionService = game:GetService("CollectionService")

local config = require(game.ReplicatedStorage.Shared.config)
local bagId = require(game.ReplicatedStorage.Shared.bagId)
local remotes = require(game.ReplicatedStorage.Shared.remotes)

local bagClickClient = {}

local linked: { [BasePart]: boolean } = {}

local function hook(bag: BasePart)
	if linked[bag] then
		return
	end
	linked[bag] = true

	local clicker = bag:FindFirstChildOfClass("ClickDetector")
	if not clicker then
		return
	end

	clicker.MouseClick:Connect(function()
		local id = bagId.get(bag)
		if not id then
			return
		end
		print("[client] bag id", id)
		remotes.bagClicked:FireServer(id)
	end)
end

function bagClickClient.start()
	for _, bag in CollectionService:GetTagged(config.bagTag) do
		if bag:IsA("BasePart") then
			hook(bag)
		end
	end

	CollectionService:GetInstanceAddedSignal(config.bagTag):Connect(function(inst)
		if inst:IsA("BasePart") then
			hook(inst)
		end
	end)
end

return bagClickClient
