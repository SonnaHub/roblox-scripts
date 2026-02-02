--=====================================

-- FREE CAM (ROBLOX STUDIO LIKE) [FIX XOAY CAM]

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

	StarterGui:SetCore("SendNotification", {		Title = "shift + P",

		Text = "Free Cam has been activated",

		Duration = 3

	})

end)

--=====================

-- CHARACTER HELPERS

--=====================

local function getChar()

	return player.Character or player.CharacterAdded:Wait()

end

local function getHumanoid()

	return getChar():FindFirstChildOfClass("Humanoid")

end

local function lockPlayer(state)

	local hum = getHumanoid()

	local root = getChar():FindFirstChild("HumanoidRootPart")

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

--=====================

-- SETTINGS

--=====================

local BASE_SPEED = 1.5

local FAST_SPEED = 6

local ACCEL = 10

local DECEL = 14

local ROT_SMOOTH = 5

local SENSITIVITY = 0.0055

--=====================

-- STATE

--=====================

local enabled = false

local keys = {}

local camPos

local camVel = Vector3.zero

local yaw, pitch = 0, 0

local targetYaw, targetPitch = 0, 0

--=====================

-- ENABLE / DISABLE

--=====================

local function enable()

	enabled = true

	lockPlayer(true)

	camera.CameraType = Enum.CameraType.Scriptable

	camera.CameraSubject = nil

	camPos = camera.CFrame.Position

	pitch, yaw = camera.CFrame:ToEulerAnglesYXZ()

	targetPitch = pitch

	targetYaw = yaw

	UIS.MouseBehavior = Enum.MouseBehavior.LockCenter

	UIS.MouseIconEnabled = false

end

local function disable()

	enabled = false

	lockPlayer(false)

	camera.CameraType = Enum.CameraType.Custom

	camera.CameraSubject = getHumanoid()

	UIS.MouseBehavior = Enum.MouseBehavior.Default

	UIS.MouseIconEnabled = true

end

--=====================

-- INPUT

--=====================

UIS.InputBegan:Connect(function(input, gp)

	if gp then return end

	if input.KeyCode == Enum.KeyCode.P and UIS:IsKeyDown(Enum.KeyCode.LeftShift) then

		if enabled then

			disable()

		else

			enable()

		end

	end

	keys[input.KeyCode] = true

end)

UIS.InputEnded:Connect(function(input)

	keys[input.KeyCode] = false

end)

--=====================

-- MAIN LOOP (🔥 FIX XOAY CAM Ở ĐÂY)

--=====================

RunService.RenderStepped:Connect(function(dt)

	if not enabled then return end

	-- 🔥 RAW MOUSE DELTA (KHÔNG BỊ ROBLOX CHẶN)

	local delta = UIS:GetMouseDelta()

	targetYaw -= delta.X * SENSITIVITY

	targetPitch -= delta.Y * SENSITIVITY

	targetPitch = math.clamp(targetPitch, -math.rad(80), math.rad(80))

	-- Smooth rotation

	yaw += (targetYaw - yaw) * math.clamp(dt * ROT_SMOOTH, 0, 1)

	pitch += (targetPitch - pitch) * math.clamp(dt * ROT_SMOOTH, 0, 1)

	local rotation = CFrame.fromEulerAnglesYXZ(pitch, yaw, 0)

	-- Movement

	local dir = Vector3.zero

	if keys[Enum.KeyCode.W] then dir += Vector3.new(0, 0, -1) end

	if keys[Enum.KeyCode.S] then dir += Vector3.new(0, 0, 1) end

	if keys[Enum.KeyCode.A] then dir += Vector3.new(-1, 0, 0) end

	if keys[Enum.KeyCode.D] then dir += Vector3.new(1, 0, 0) end

	if keys[Enum.KeyCode.E] then dir += Vector3.new(0, 1, 0) end

	if keys[Enum.KeyCode.Q] then dir += Vector3.new(0, -1, 0) end

	local speed = UIS:IsKeyDown(Enum.KeyCode.LeftShift) and FAST_SPEED or BASE_SPEED

	local targetVel = rotation:VectorToWorldSpace(dir) * speed

	local rate = (targetVel.Magnitude > camVel.Magnitude) and ACCEL or DECEL

	camVel += (targetVel - camVel) * math.clamp(dt * rate, 0, 1)

	camPos += camVel

	camera.CFrame = CFrame.new(camPos) * rotation

end)
