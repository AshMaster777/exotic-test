--!strict

local bagClickClient = require(script.Parent.bagClickClient)
local intervalUi = require(script.Parent.intervalUi)

local bootstrap = {}

function bootstrap.start()
	bagClickClient.start()
	intervalUi.start()
end

return bootstrap
