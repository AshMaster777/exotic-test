--!strict

local bagLook = {}

local mats = {
	Enum.Material.Plastic,
	Enum.Material.SmoothPlastic,
	Enum.Material.Wood,
	Enum.Material.Metal,
	Enum.Material.Glass,
	Enum.Material.Fabric,
	Enum.Material.Slate,
}

local rng = Random.new()

function bagLook.roll(): (Enum.Material, Color3)
	local mat = mats[rng:NextInteger(1, #mats)]
	local col = Color3.fromHSV(rng:NextNumber(), rng:NextNumber(0.35, 1), rng:NextNumber(0.5, 1))
	return mat, col
end

function bagLook.apply(part: BasePart, mat: Enum.Material, col: Color3)
	part.Material = mat
	part.Color = col
end

return bagLook
