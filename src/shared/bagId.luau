--!strict

local HttpService = game:GetService("HttpService")

local bagId = {}

local attr = "BagId"

function bagId.make(): string
	return HttpService:GenerateGUID(false)
end

function bagId.put(part: BasePart, id: string)
	part:SetAttribute(attr, id)
end

function bagId.get(part: BasePart): string?
	local v = part:GetAttribute(attr)
	if typeof(v) == "string" then
		return v
	end
	return nil
end

return bagId
