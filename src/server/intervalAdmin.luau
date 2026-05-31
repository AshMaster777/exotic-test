--!strict

local Players = game:GetService("Players")

local remotes = require(game.ReplicatedStorage.Shared.remotes)

local intervalAdmin = {}

local picked = false

local function tryPick(plr: Player)
	if picked then
		return
	end
	picked = true
	remotes.intervalAdmin.Value = plr.UserId
end

function intervalAdmin.start()
	Players.PlayerAdded:Connect(tryPick)
	for _, plr in Players:GetPlayers() do
		tryPick(plr)
	end

	remotes.setSpawnInterval.OnServerEvent:Connect(function(plr, val: unknown)
		if typeof(val) ~= "number" then
			return
		end
		if plr.UserId ~= remotes.intervalAdmin.Value then
			return
		end
		remotes.spawnInterval.Value = math.clamp(val, 0.15, 8)
	end)
end

return intervalAdmin
