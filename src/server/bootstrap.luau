--!strict

local conveyerRefs = require(game.ReplicatedStorage.Shared.conveyerRefs)

local bootstrap = {}

function bootstrap.start()
	conveyerRefs.model()
	conveyerRefs.spawn()
	conveyerRefs.belt()
end

return bootstrap
