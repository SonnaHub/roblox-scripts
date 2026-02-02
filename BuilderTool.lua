--==============================
-- BUILDER TOOL FULL
--==============================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

--==============================
-- SETTINGS
--==============================

local BLOCK_SIZE = Vector3.new(4,1,2)
local GRID = 1

--==============================
-- STATE
--==============================

local selectedPart = nil
local mode = "Move" -- Move / Resize

--==============================
-- SELECTION BOX
--==============================

local selectionBox = Instance.new("SelectionBox")
selectionBox.Color3 = Color3.new(1,1,1)
selectionBox.LineThickness = 0.05
selectionBox.SurfaceTransparency = 1
selectionBox.Parent = workspace

--==============================
-- MOVE GIZMO
--==============================

local moveFolder = Instance.new("Folder", workspace)
moveFolder.Name = "MoveGizmo"

local arrows = {}

local function createArrow(dir)
    local p = Instance.new("Part")
    p.Size = Vector3.new(0.3,0.3,2)
    p.Material = Enum.Material.Neon
    p.Color = Color3.fromRGB(255,70,70)
    p.Anchored = true
    p.CanCollide = false
    p.Parent = moveFolder

    local cd = Instance.new("ClickDetector", p)
    cd.MaxActivationDistance = 30

    table.insert(arrows,{part=p,dir=dir,cd=cd})
end

createArrow(Vector3.new(1,0,0))
createArrow(Vector3.new(-1,0,0))
createArrow(Vector3.new(0,0,1))
createArrow(Vector3.new(0,0,-1))

local moveDir = nil

for _,a in ipairs(arrows) do
    a.cd.MouseDown:Connect(function()
        moveDir = a.dir
    end)
    a.cd.MouseUp:Connect(function()
        moveDir = nil
    end)
end

local function updateMoveGizmo()
    if not selectedPart or mode ~= "Move" then
        moveFolder.Parent = nil
        return
    end

    moveFolder.Parent = workspace
    local p,s = selectedPart.Position, selectedPart.Size

    arrows[1].part.CFrame = CFrame.new(p + Vector3.new(s.X/2+1,0,0)) * CFrame.Angles(0,0,math.rad(90))
    arrows[2].part.CFrame = CFrame.new(p - Vector3.new(s.X/2+1,0,0)) * CFrame.Angles(0,0,math.rad(90))
    arrows[3].part.CFrame = CFrame.new(p + Vector3.new(0,0,s.Z/2+1))
    arrows[4].part.CFrame = CFrame.new(p - Vector3.new(0,0,s.Z/2+1))
end

--==============================
-- RESIZE GIZMO
--==============================

local resizeFolder = Instance.new("Folder", workspace)
resizeFolder.Name = "ResizeGizmo"

local handles = {}

local function createHandle(axis,sign)
    local h = Instance.new("Part")
    h.Shape = Enum.PartType.Ball
    h.Size = Vector3.new(0.5,0.5,0.5)
    h.Material = Enum.Material.Neon
    h.Color = Color3.fromRGB(0,170,255)
    h.Anchored = true
    h.CanCollide = false
    h.Parent = resizeFolder

    local cd = Instance.new("ClickDetector", h)
    cd.MaxActivationDistance = 30

    table.insert(handles,{part=h,axis=axis,sign=sign,cd=cd})
end

createHandle("X",1)
createHandle("X",-1)
createHandle("Z",1)
createHandle("Z",-1)

local function updateResizeGizmo()
    if not selectedPart or mode ~= "Resize" then
        resizeFolder.Parent = nil
        return
    end

    resizeFolder.Parent = workspace
    local p,s = selectedPart.Position, selectedPart.Size

    handles[1].part.Position = p + Vector3.new(s.X/2,0,0)
    handles[2].part.Position = p - Vector3.new(s.X/2,0,0)
    handles[3].part.Position = p + Vector3.new(0,0,s.Z/2)
    handles[4].part.Position = p - Vector3.new(0,0,s.Z/2)
end

for _,h in ipairs(handles) do
    h.cd.MouseDown:Connect(function()
        if not selectedPart then return end

        local size = selectedPart.Size
        local pos = selectedPart.Position

        if h.axis == "X" then
            size += Vector3.new(h.sign,0,0)
            pos += Vector3.new(h.sign/2,0,0)
        else
            size += Vector3.new(0,0,h.sign)
            pos += Vector3.new(0,0,h.sign/2)
        end

        if size.X >= 1 and size.Z >= 1 then
            selectedPart.Size = size
            selectedPart.Position = pos
        end
    end)
end

--==============================
-- INPUT
--==============================

UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.G then
        mode = "Move"
    elseif i.KeyCode == Enum.KeyCode.R then
        mode = "Resize"
    elseif i.KeyCode == Enum.KeyCode.B then
        -- ADD BLOCK
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local part = Instance.new("Part")
        part.Size = BLOCK_SIZE
        part.Anchored = true
        part.Material = Enum.Material.Plastic
        part.Color = Color3.fromRGB(160,160,160)
        part.Parent = workspace

        local pos = hrp.Position + hrp.CFrame.LookVector * 6
        pos = Vector3.new(math.floor(pos.X+0.5),0.5,math.floor(pos.Z+0.5))
        part.Position = pos
    elseif i.KeyCode == Enum.KeyCode.Delete and selectedPart then
        selectedPart:Destroy()
        selectedPart = nil
        selectionBox.Adornee = nil
    end
end)

mouse.Button1Down:Connect(function()
    if mouse.Target and mouse.Target:IsA("Part") then
        selectedPart = mouse.Target
        selectionBox.Adornee = selectedPart
    end
end)

--==============================
-- UPDATE LOOP
--==============================

RunService.RenderStepped:Connect(function()
    if moveDir and selectedPart and mode == "Move" then
        selectedPart.Position += moveDir * GRID
    end
    updateMoveGizmo()
    updateResizeGizmo()
end)
