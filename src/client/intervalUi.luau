--!strict

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local config = require(game.ReplicatedStorage.Shared.config)
local remotes = require(game.ReplicatedStorage.Shared.remotes)

local intervalUi = {}

local minI = 0.15
local maxI = 8

local function isAdmin(plr: Player): boolean
	return remotes.intervalAdmin.Value == plr.UserId
end

local function build(plr: Player)
	if plr.PlayerGui:FindFirstChild("ConveyorIntervalUi") then
		return
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "ConveyorIntervalUi"
	gui.ResetOnSpawn = false
	gui.Parent = plr.PlayerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(280, 90)
	frame.Position = UDim2.new(0, 16, 0, 16)
	frame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
	frame.BorderSizePixel = 0
	frame.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 28)
	label.Position = UDim2.fromOffset(10, 8)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(235, 235, 240)
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local track = Instance.new("TextButton")
	track.Size = UDim2.new(1, -20, 0, 18)
	track.Position = UDim2.fromOffset(10, 48)
	track.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
	track.Text = ""
	track.AutoButtonColor = false
	track.Parent = frame

	local fill = Instance.new("Frame")
	fill.Size = UDim2.fromScale(0.5, 1)
	fill.BackgroundColor3 = Color3.fromRGB(90, 170, 255)
	fill.BorderSizePixel = 0
	fill.Parent = track

	local dragging = false

	local function toAlpha(v: number): number
		return (v - minI) / (maxI - minI)
	end

	local function toInterval(a: number): number
		return minI + a * (maxI - minI)
	end

	local function show(v: number)
		fill.Size = UDim2.fromScale(toAlpha(v), 1)
		label.Text = string.format("spawn interval %.2fs", v)
	end

	local function push(v: number)
		v = math.clamp(v, minI, maxI)
		remotes.setSpawnInterval:FireServer(v)
		show(v)
	end

	local function fromMouse()
		local rel = track.AbsolutePosition.X
		local w = track.AbsoluteSize.X
		local mx = UserInputService:GetMouseLocation().X
		local a = math.clamp((mx - rel) / w, 0, 1)
		push(toInterval(a))
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			fromMouse()
		end
	end)

	track.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			fromMouse()
		end
	end)

	show(remotes.spawnInterval.Value)

	remotes.spawnInterval.Changed:Connect(function()
		if isAdmin(plr) then
			show(remotes.spawnInterval.Value)
		end
	end)
end

function intervalUi.start()
	local plr = Players.LocalPlayer
	if not plr then
		return
	end

	local function refresh()
		if isAdmin(plr) then
			build(plr)
		end
	end

	refresh()
	remotes.intervalAdmin.Changed:Connect(refresh)
end

return intervalUi
