--!strict

local conveyerRefs = require(game.ReplicatedStorage.Shared.conveyerRefs)
local bagSpawner = require(script.Parent.bagSpawner)

local bootstrap = {}

function bootstrap.start()
	conveyerRefs.model()
	conveyerRefs.spawn()
	conveyerRefs.belt()
	conveyerRefs.prepBelt()

	bagSpawner.start()
end

return bootstrap
