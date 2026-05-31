--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local settingsFolder = ReplicatedStorage:WaitForChild("ConveyorSettings")

local remotes = {
	bagClicked = remotesFolder:WaitForChild("BagClicked") :: RemoteEvent,
	setSpawnInterval = remotesFolder:WaitForChild("SetSpawnInterval") :: RemoteEvent,
	spawnInterval = settingsFolder:WaitForChild("SpawnInterval") :: NumberValue,
	intervalAdmin = settingsFolder:WaitForChild("IntervalAdmin") :: IntValue,
}

return remotes
