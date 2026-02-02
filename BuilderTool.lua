--==============================
-- BUILDER TOOL (NO ICON GUI)
--==============================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local Backpack = Player:WaitForChild("Backpack")

--==============================
-- CREATE TOOL
--==============================

local function createTool()
	if Backpack:FindFirstChild("BuilderTool") then return end

	local Tool = Instance.new("Tool")
	Tool.Name = "BuilderTool"
	Tool.RequiresHandle = false
	Tool.CanBeDropped = false
	Tool.Parent = Backpack
end

createTool()

-- Respawn không mất tool
Player.CharacterAdded:Connect(function()
	task.wait(0.5)
	createTool()
end)

--==============================
-- GUI
--==============================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BuilderGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.fromScale(0.3, 0.4)
Frame.Position = UDim2.fromScale(0.35, 0.3)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UIcorner = Instance.new("UICorner", Frame)

local AddBtn = Instance.new("TextButton", Frame)
AddBtn.Size = UDim2.fromScale(0.9, 0.2)
AddBtn.Position = UDim2.fromScale(0.05, 0.1)
AddBtn.Text = "➕ Add Block"
AddBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
AddBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", AddBtn)

local DelBtn = Instance.new("TextButton", Frame)
DelBtn.Size = UDim2.fromScale(0.9, 0.2)
DelBtn.Position = UDim2.fromScale(0.05, 0.4)
DelBtn.Text = "❌ Delete Selected"
DelBtn.BackgroundColor3 = Color3.fromRGB(80,40,40)
DelBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", DelBtn)

--==============================
-- BUILDER LOGIC
--==============================

local selectedPart = nil

AddBtn.MouseButton1Click:Connect(function()
	local part = Instance.new("Part")
	part.Size = Vector3.new(4,4,4)
	part.Position = Player.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
	part.Anchored = true
	part.Parent = workspace
	selectedPart = part
end)

DelBtn.MouseButton1Click:Connect(function()
	if selectedPart then
		selectedPart:Destroy()
		selectedPart = nil
	end
end)

-- Click chọn block
UIS.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local mouse = Player:GetMouse()
		if mouse.Target and mouse.Target:IsA("Part") then
			selectedPart = mouse.Target
		end
	end
end)

--==============================
-- TOOL EQUIP CONTROL
--==============================

local function hookTool()
	local Tool = Backpack:WaitForChild("BuilderTool")

	Tool.Equipped:Connect(function()
		ScreenGui.Enabled = true
	end)

	Tool.Unequipped:Connect(function()
		ScreenGui.Enabled = false
	end)
end

hookTool()
