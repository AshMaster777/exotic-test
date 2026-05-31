--!strict

local bagsFolder = {}

local folder: Folder? = nil

function bagsFolder.get(): Folder
	if folder then
		return folder
	end

	local f = workspace:FindFirstChild("ConveyorBags")
	if not f then
		f = Instance.new("Folder")
		f.Name = "ConveyorBags"
		f.Parent = workspace
	end

	folder = f :: Folder
	return folder
end

function bagsFolder.count(): number
	return #bagsFolder.get():GetChildren()
end

function bagsFolder.clear()
	for _, child in bagsFolder.get():GetChildren() do
		child:Destroy()
	end
end

return bagsFolder
