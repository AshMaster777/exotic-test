--!strict

local conveyerRefs = require(game.ReplicatedStorage.Shared.conveyerRefs)
local bagSpawner = require(script.Parent.bagSpawner)
local intervalAdmin = require(script.Parent.intervalAdmin)
local bagClickServer = require(script.Parent.bagClickServer)

local bootstrap = {}

function bootstrap.start()
	conveyerRefs.model()
	conveyerRefs.spawn()
	conveyerRefs.belt()
	conveyerRefs.prepBelt()

	intervalAdmin.start()
	bagClickServer.start()
	bagSpawner.start()
end

return bootstrap
