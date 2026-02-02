--=====================================
-- FREE CAM (ROBLOX STUDIO LIKE)
-- SHIFT + P TO TOGGLE
--=====================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Notify
pcall(function()
	StarterGui:SetCore("SendNotification", {
		Title = "Free Cam",
		Text = "Free Cam has been activated",
		Duration = 4
	})
end)

-- Character helpers
local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function lockPlayer(state)
	local char = getChar()
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")

	if hum then
		if state then
			hum.WalkSpeed = 0
			hum.JumpPower = 0
			hum:Move(Vector3.zero, false)
		else
			hum.WalkSpeed = 16
			hum.JumpPower = 50
		end
	end
	if root then
		root.AssemblyLinearVelocity = Vector3.zero
	end
end

-- =====================
-- SETTINGS (Studio-like)
-- =====================
local BASE_SPEED = 1.5
local FAST_SPEED = 6
local ACCEL = 10
local DECEL = 14
local ROT_SMOOTH = 12
local MOVE_SMOOTH = 10
local SENSITIVITY = 0.0025

-- State
local enabled = false
local keys = {}

local camPos
local camVel = Vector3.zero

local yaw = 0
local pitch = 0
local targetYaw = 0
local targetPitch = 0

-- Enable
local function enable()
	enabled = true
	lockPlayer(true)

	camera.CameraType = Enum.CameraType.Scriptable
	camPos = camera.CFrame.Position
	yaw, pitch = camera.CFrame:ToEulerAnglesYXZ()
	targetYaw, targetPitch = yaw, pitch

	UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
	UIS.MouseIconEnabled = false
end

-- Disable
local function disable()
	enabled = false
	lockPlayer(false)

	camera.CameraType = Enum.CameraType.Custom
	UIS.MouseBehavior = Enum.MouseBehavior.Default
	UIS.MouseIconEnabled = true
end

-- Input
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end

	if input.KeyCode == Enum.KeyCode.P and UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
		if enabled then disable() else enable() end
	end

	keys[input.KeyCode] = true
end)

UIS.InputEnded:Connect(function(input)
	keys[input.KeyCode] = false
end)

UIS.InputChanged:Connect(function(input)
	if not enabled then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		targetYaw -= input.Delta.X * SENSITIVITY
		targetPitch -= input.Delta.Y * SENSITIVITY
		targetPitch = math.clamp(targetPitch, -math.rad(89), math.rad(89))
	end
end)

-- Main loop
RunService.RenderStepped:Connect(function(dt)
	if not enabled then return end

	-- Smooth rotation (Studio-like)
	yaw += (targetYaw - yaw) * math.clamp(dt * ROT_SMOOTH, 0, 1)
	pitch += (targetPitch - pitch) * math.clamp(dt * ROT_SMOOTH, 0, 1)

	local rotation = CFrame.fromEulerAnglesYXZ(pitch, yaw, 0)

	-- Movement input
	local inputDir = Vector3.zero
	if keys[Enum.KeyCode.W] then inputDir += Vector3.new(0, 0, -1) end
	if keys[Enum.KeyCode.S] then inputDir += Vector3.new(0, 0, 1) end
	if keys[Enum.KeyCode.A] then inputDir += Vector3.new(-1, 0, 0) end
	if keys[Enum.KeyCode.D] then inputDir += Vector3.new(1, 0, 0) end
	if keys[Enum.KeyCode.E] then inputDir += Vector3.new(0, 1, 0) end
	if keys[Enum.KeyCode.Q] then inputDir += Vector3.new(0, -1, 0) end

	local speed = UIS:IsKeyDown(Enum.KeyCode.LeftShift) and FAST_SPEED or BASE_SPEED
	local targetVel = rotation:VectorToWorldSpace(inputDir) * speed

	-- Accel / Decel like Studio
	local rate = (targetVel.Magnitude > camVel.Magnitude) and ACCEL or DECEL
	camVel += (targetVel - camVel) * math.clamp(dt * rate, 0, 1)

	camPos += camVel
	camera.CFrame = CFrame.new(camPos) * rotation
end)
