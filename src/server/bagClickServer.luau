--!strict

local bagId = require(game.ReplicatedStorage.Shared.bagId)
local remotes = require(game.ReplicatedStorage.Shared.remotes)
local bagsFolder = require(script.Parent.bagsFolder)

local bagClickServer = {}

local function findBag(id: string): BasePart?
	for _, child in bagsFolder.get():GetChildren() do
		if child:IsA("BasePart") and bagId.get(child) == id then
			return child
		end
	end
	return nil
end

function bagClickServer.start()
	remotes.bagClicked.OnServerEvent:Connect(function(_plr, id: unknown)
		if typeof(id) ~= "string" then
			return
		end
		if not findBag(id) then
			return
		end
		print("[server] bag id", id)
	end)
end

return bagClickServer
