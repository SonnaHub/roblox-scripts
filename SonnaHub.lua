--==============================

-- RAYFIELD LOAD

--==============================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--==============================

-- SERVICES

--==============================

local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local TeleportService = game:GetService("TeleportService")

local HttpService = game:GetService("HttpService")

local VirtualUser = game:GetService("VirtualUser")

local UserInputService = game:GetService("UserInputService")

local Stats = game:GetService("Stats")

local lp = Players.LocalPlayer

--==============================

-- ANTI AFK (AUTO ENABLE)

--==============================

lp.Idled:Connect(function()

VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)

task.wait(1)

VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)

end)

--==============================

-- SERVER HOP SAVE (NO OLD SERVER)

--==============================

local ServerFile = "SonnaHub_JoinedServers.json"

local function getJoinedServers()

if isfile and isfile(ServerFile) then

return HttpService:JSONDecode(readfile(ServerFile))

end

return {}

end

local function saveJoinedServers(tbl)

if writefile then

writefile(ServerFile, HttpService:JSONEncode(tbl))

end

end

--==============================

-- WINDOW

--==============================

local Window = Rayfield:CreateWindow({

Name = "Sonna Hub | Rayfield",

LoadingTitle = "Sonna Hub",

LoadingSubtitle = "Rayfield UI",

ConfigurationSaving = { Enabled = false },

Discord = { Enabled = false },

KeySystem = false

})

--==============================

-- TABS

--==============================

local MainTab = Window:CreateTab("Main", 4483362458)

local ToolsTab = Window:CreateTab("Tools", 6031075938)

local ScriptTab = Window:CreateTab("Script", 6023426926)

ScriptTab:CreateSection("Scripts")

ScriptTab:CreateButton({

    Name = "Fly GUI V3",

    Callback = function()

        loadstring(game:HttpGet(

            "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"

        ))()

    end

})

ScriptTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
        ))()
    end
})

--==============================

-- HUMANOID SAFE

--==============================

local function getHumanoid()

local char = lp.Character or lp.CharacterAdded:Wait()

return char:WaitForChild("Humanoid")

end

--==============================

-- SPEED CONFIG

--==============================

MainTab:CreateSection("Speed")

local DEFAULT_SPEED = 16

local SPEED_MAX = 10000

local speedEnabled = false

local speedValue = DEFAULT_SPEED

local resettingSpeed = false

local syncingSpeed = false

local function applySpeed()

getHumanoid().WalkSpeed = speedEnabled and speedValue or DEFAULT_SPEED

end

local SpeedEnableToggle = MainTab:CreateToggle({

Name = "Enable WalkSpeed",

CurrentValue = false,

Callback = function(v)

if resettingSpeed then return end

speedEnabled = v

applySpeed()

end

})

local SpeedSlider

local SpeedInput

SpeedSlider = MainTab:CreateSlider({

Name = "WalkSpeed Slider",

Range = {0, SPEED_MAX},

Increment = 1,

CurrentValue = DEFAULT_SPEED,

Callback = function(v)

if resettingSpeed or syncingSpeed then return end

syncingSpeed = true

speedValue = v

SpeedInput:Set(tostring(v))

syncingSpeed = false

if speedEnabled then applySpeed() end

end

})

SpeedInput = MainTab:CreateInput({

Name = "Speed Value",

PlaceholderText = "Num",

RemoveTextAfterFocusLost = false,

Callback = function(text)

if resettingSpeed or syncingSpeed then return end

local num = tonumber(text)

if not num then return end

num = math.clamp(num, 0, SPEED_MAX)

syncingSpeed = true

speedValue = num

SpeedSlider:Set(num)

syncingSpeed = false

if speedEnabled then applySpeed() end

end

})

MainTab:CreateButton({

Name = "Reset Speed",

Callback = function()

resettingSpeed = true

speedEnabled = false

speedValue = DEFAULT_SPEED

SpeedEnableToggle:Set(false)

SpeedSlider:Set(DEFAULT_SPEED)

SpeedInput:Set(tostring(DEFAULT_SPEED))

applySpeed()

task.wait()

resettingSpeed = false

end

})

--==============================

-- JUMP CONFIG

--==============================

MainTab:CreateSection("Jump")

local DEFAULT_JUMP = 50

local JUMP_MAX = 10000

local jumpEnabled = false

local jumpValue = DEFAULT_JUMP

local resettingJump = false

local syncingJump = false

local function applyJump()

getHumanoid().JumpPower = jumpEnabled and jumpValue or DEFAULT_JUMP

end

local JumpEnableToggle = MainTab:CreateToggle({

Name = "Enable JumpPower",

CurrentValue = false,

Callback = function(v)

if resettingJump then return end

jumpEnabled = v

applyJump()

end

})

local JumpSlider

local JumpInput

JumpSlider = MainTab:CreateSlider({

Name = "Jump Slider",

Range = {0, JUMP_MAX},

Increment = 1,

CurrentValue = DEFAULT_JUMP,

Callback = function(v)

if resettingJump or syncingJump then return end

syncingJump = true

jumpValue = v

JumpInput:Set(tostring(v))

syncingJump = false

if jumpEnabled then applyJump() end

end

})

JumpInput = MainTab:CreateInput({

Name = "Jump Value",

PlaceholderText = "Num",

RemoveTextAfterFocusLost = false,

Callback = function(text)

if resettingJump or syncingJump then return end

local num = tonumber(text)

if not num then return end

num = math.clamp(num, 0, JUMP_MAX)

syncingJump = true

jumpValue = num

JumpSlider:Set(num)

syncingJump = false

if jumpEnabled then applyJump() end

end

})

MainTab:CreateButton({

Name = "Reset Jump",

Callback = function()

resettingJump = true

jumpEnabled = false

jumpValue = DEFAULT_JUMP

JumpEnableToggle:Set(false)

JumpSlider:Set(DEFAULT_JUMP)

JumpInput:Set(tostring(DEFAULT_JUMP))

applyJump()

task.wait()

resettingJump = false

end

})

--==============================

-- INFINITE JUMP

--==============================

MainTab:CreateSection("Infinite Jump")

local infiniteJump = false

local infConn

MainTab:CreateToggle({

Name = "Enable Infinite Jump",

CurrentValue = false,

Callback = function(v)

infiniteJump = v

if infiniteJump then

infConn = UserInputService.JumpRequest:Connect(function()

getHumanoid():ChangeState(Enum.HumanoidStateType.Jumping)

end)

else

if infConn then

infConn:Disconnect()

infConn = nil

end

end

end

})

--==============================

-- NOCLIP

--==============================

MainTab:CreateSection("Noclip")

local noclipEnabled = false

local noclipConnection

local function setNoclip(state)

noclipEnabled = state

if noclipEnabled then

noclipConnection = RunService.Stepped:Connect(function()

local char = lp.Character

if not char then return end

for _, v in ipairs(char:GetDescendants()) do

if v:IsA("BasePart") then

v.CanCollide = false

end

end

end)

else

if noclipConnection then

noclipConnection:Disconnect()

noclipConnection = nil

end

end

end

MainTab:CreateToggle({

Name = "Enable Noclip",

CurrentValue = false,

Callback = setNoclip

})

--==============================

-- TOOLS

--==============================

ToolsTab:CreateSection("Player Tools")

ToolsTab:CreateButton({

Name = "Reset Character",

Callback = function()

getHumanoid().Health = 0

end

})

ToolsTab:CreateButton({

Name = "Rejoin Server",

Callback = function()

TeleportService:Teleport(game.PlaceId, lp)

end

})

--==============================

-- SERVER HOP (NEW SERVER ONLY)

--==============================

ToolsTab:CreateButton({

Name = "Server Hop (New)",

Callback = function()

local joined = getJoinedServers()

local servers = {}

local cursor = ""

repeat  

        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId ..  

            "/servers/Public?sortOrder=Asc&limit=100" ..  

            (cursor ~= "" and "&cursor=" .. cursor or "")  

        local res = game:HttpGet(url)  

        local data = HttpService:JSONDecode(res)  

        for _, s in ipairs(data.data) do  

            if s.playing < s.maxPlayers and not joined[s.id] then  

                table.insert(servers, s.id)  

            end  

        end  

        cursor = data.nextPageCursor or ""  

    until #servers > 0 or cursor == ""  

    if #servers > 0 then  

        local sid = servers[math.random(#servers)]  

        joined[sid] = true  

        saveJoinedServers(joined)  

        TeleportService:TeleportToPlaceInstance(game.PlaceId, sid, lp)  

    else  

        Rayfield:Notify({  

            Title = "Sonna Hub",  

            Content = "Không còn server mới!",  

            Duration = 3  

        })  

    end  

end

})

--==============================

-- TELEPORT TOOL

--==============================

ToolsTab:CreateButton({

Name = "Teleport Tool",

Callback = function()

local backpack = lp:WaitForChild("Backpack")

if backpack:FindFirstChild("TPTool") then

backpack.TPTool:Destroy()

end

local tool = Instance.new("Tool")  

    tool.Name = "TPTool"  

    tool.RequiresHandle = false  

    tool.Parent = backpack  

    local mouse = lp:GetMouse()  

    tool.Activated:Connect(function()  

        local char = lp.Character  

        if not char then return end  

        local hrp = char:FindFirstChild("HumanoidRootPart")  

        if hrp and mouse and mouse.Hit then  

            hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))  

        end  

    end)  

end

})

--==============================

-- TELEPORT TO PLAYER (TYPE NAME)

--==============================

ToolsTab:CreateSection("Teleport By Name")

local tpName = ""

local function findPlayerByPartialName(name)

name = name:lower()

for _, p in ipairs(Players:GetPlayers()) do

if p ~= lp and p.Name:lower():sub(1, #name) == name then

return p

end

end

end

ToolsTab:CreateInput({

Name = "Player Name",

PlaceholderText = "Gõ vài chữ",

RemoveTextAfterFocusLost = false,

Callback = function(text)

tpName = text

end

})

ToolsTab:CreateButton({

Name = "Teleport Now",

Callback = function()

if tpName == "" then return end

local target = findPlayerByPartialName(tpName)

if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then

lp.Character.HumanoidRootPart.CFrame =

target.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3)

end

end

})

--==============================

-- CAMERA / FREE CAM (RAYFIELD + SMOOTH)

--==============================

ToolsTab:CreateSection("Camera")

local cam = workspace.CurrentCamera

local FreeCam = false

local camConn

local CamSpeed = 60

local Sensitivity = 0.25

local Smoothness = 0.12 -- smooth mức nhẹ

local SmoothEnabled = true -- <<< BẬT / TẮT SMOOTH

-- rotation target & current

local targetX, targetY = 0, 0

local curX, curY = 0, 0

local camPos

local savedWalk, savedJump, savedAutoRotate

local savedCF

local rootAnchored = false

-- START FREE CAM

local function startFreeCam()

    if FreeCam then return end

    FreeCam = true

    local char = lp.Character

    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")

    local root = char:FindFirstChild("HumanoidRootPart")

    if not hum or not root then return end

    -- save state

    savedWalk = hum.WalkSpeed

    savedJump = hum.JumpPower

    savedAutoRotate = hum.AutoRotate

    savedCF = cam.CFrame

    -- lock player

    hum.WalkSpeed = 0

    hum.JumpPower = 0

    hum.AutoRotate = false

    root.Anchored = true

    rootAnchored = true

    -- camera

    cam.CameraType = Enum.CameraType.Scriptable

    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

    camPos = cam.CFrame.Position

    targetX, targetY = 0, 0

    curX, curY = 0, 0

    camConn = RunService.RenderStepped:Connect(function(dt)

        -- mouse input

        local delta = UserInputService:GetMouseDelta()

        targetX -= delta.Y * Sensitivity

        targetY -= delta.X * Sensitivity

        targetX = math.clamp(targetX, -89, 89)

        -- smooth / instant rotation

        if SmoothEnabled then

            curX = curX + (targetX - curX) * Smoothness

            curY = curY + (targetY - curY) * Smoothness

        else

            curX = targetX

            curY = targetY

        end

        -- movement (local camera space)

        local move = Vector3.zero

        local speed = CamSpeed * dt

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Vector3.new(0,0,-1) end

        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move += Vector3.new(0,0,1) end

        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move += Vector3.new(-1,0,0) end

        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Vector3.new(1,0,0) end

        if UserInputService:IsKeyDown(Enum.KeyCode.E) then move += Vector3.new(0,1,0) end

        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then move += Vector3.new(0,-1,0) end

        local rotCF =

            CFrame.Angles(0, math.rad(curY), 0) *

            CFrame.Angles(math.rad(curX), 0, 0)

        camPos += rotCF:VectorToWorldSpace(move * speed)

        cam.CFrame = CFrame.new(camPos) * rotCF

    end)

end

-- STOP FREE CAM

local function stopFreeCam()

    if not FreeCam then return end

    FreeCam = false

    if camConn then

        camConn:Disconnect()

        camConn = nil

    end

    cam.CameraType = Enum.CameraType.Custom

    UserInputService.MouseBehavior = Enum.MouseBehavior.Default

    local char = lp.Character

    if char then

        local hum = char:FindFirstChildOfClass("Humanoid")

        local root = char:FindFirstChild("HumanoidRootPart")

        if hum then

            hum.WalkSpeed = savedWalk or 16

            hum.JumpPower = savedJump or 50

            hum.AutoRotate = savedAutoRotate ~= false

        end

        if root and rootAnchored then

            root.Anchored = false

            rootAnchored = false

        end

    end

    if savedCF then

        cam.CFrame = savedCF

    end

end

-- GUI TOGGLE

local FreeCamToggle

FreeCamToggle = ToolsTab:CreateToggle({

    Name = "Free Camera",

    CurrentValue = false,

    Callback = function(v)

        if v then

            startFreeCam()

        else

            stopFreeCam()

        end

    end

})

-- SMOOTH TOGGLE

ToolsTab:CreateToggle({

    Name = "Camera Smooth",

    CurrentValue = SmoothEnabled,

    Callback = function(v)

        SmoothEnabled = v

    end

})

-- SPEED SLIDER

ToolsTab:CreateSlider({

    Name = "FreeCam Speed",

    Range = {10, 300},

    Increment = 5,

    CurrentValue = CamSpeed,

    Callback = function(v)

        CamSpeed = v

    end

})

-- RAYFIELD KEYBIND

ToolsTab:CreateKeybind({

    Name = "Free Camera Keybind",

    CurrentKeybind = "F",

    HoldToInteract = false,

    Flag = "FreeCamKey",

    Callback = function()

        FreeCamToggle:Set(not FreeCamToggle.CurrentValue)

    end

})

--==============================
-- BUILDER TOOL (WORK WITH FREECAM)
--==============================

ToolsTab:CreateSection("Builder Tool")

local BuilderEnabled = false
local BuildFolder = Instance.new("Folder", workspace)
BuildFolder.Name = "SonnaBuilder"

local SelectedPart
local MoveSpeed = 1
local SizeStep = 0.5

local function createBlock(pos)
    local p = Instance.new("Part")
    p.Size = Vector3.new(4,4,4)
    p.Anchored = true
    p.Material = Enum.Material.SmoothPlastic
    p.Color = Color3.fromRGB(0, 170, 255)
    p.Position = pos or (cam.CFrame.Position + cam.CFrame.LookVector * 10)
    p.Parent = BuildFolder
    return p
end

local function selectPart(part)
    if SelectedPart then
        SelectedPart.Color = Color3.fromRGB(0,170,255)
    end
    SelectedPart = part
    if part then
        part.Color = Color3.fromRGB(255, 170, 0)
    end
end

-- Toggle Builder
ToolsTab:CreateToggle({
    Name = "Enable Builder Tool",
    CurrentValue = false,
    Callback = function(v)
        BuilderEnabled = v
        if v and #BuildFolder:GetChildren() == 0 then
            selectPart(createBlock())
        end
        if not v then
            selectPart(nil)
        end
    end
})

-- Create new block
ToolsTab:CreateButton({
    Name = "Add Block",
    Callback = function()
        if not BuilderEnabled then return end
        selectPart(createBlock())
    end
})

-- Delete block
ToolsTab:CreateButton({
    Name = "Delete Selected Block",
    Callback = function()
        if SelectedPart then
            SelectedPart:Destroy()
            SelectedPart = nil
        end
    end
})

-- Input handling
UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not BuilderEnabled or not SelectedPart then return end

    local move = Vector3.zero

    if input.KeyCode == Enum.KeyCode.Up then move = Vector3.new(0,0,-MoveSpeed) end
    if input.KeyCode == Enum.KeyCode.Down then move = Vector3.new(0,0,MoveSpeed) end
    if input.KeyCode == Enum.KeyCode.Left then move = Vector3.new(-MoveSpeed,0,0) end
    if input.KeyCode == Enum.KeyCode.Right then move = Vector3.new(MoveSpeed,0,0) end

    if move ~= Vector3.zero then
        SelectedPart.CFrame += cam.CFrame:VectorToWorldSpace(move)
    end

    -- Resize
    if input.KeyCode == Enum.KeyCode.R then
        SelectedPart.Size += Vector3.new(SizeStep, SizeStep, SizeStep)
    end
    if input.KeyCode == Enum.KeyCode.F then
        SelectedPart.Size -= Vector3.new(SizeStep, SizeStep, SizeStep)
    end

    -- Delete
    if input.KeyCode == Enum.KeyCode.Delete then
        SelectedPart:Destroy()
        SelectedPart = nil
    end

    -- New block
    if input.KeyCode == Enum.KeyCode.G then
        selectPart(createBlock())
    end
end)

-- Mouse select
local mouse = lp:GetMouse()
mouse.Button1Down:Connect(function()
    if not BuilderEnabled then return end
    if mouse.Target and mouse.Target:IsDescendantOf(BuildFolder) then
        selectPart(mouse.Target)
    end
end)
