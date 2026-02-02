--// SONNA HUB V1 | FREE FLY WASD | DELTA SAFE | IY ANIM FIX

pcall(function()

    if game.CoreGui:FindFirstChild("SonnaHubV1") then

        game.CoreGui.SonnaHubV1:Destroy()

    end

end)

local Players = game:GetService("Players")

local UIS = game:GetService("UserInputService")

local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer

-- GUI ROOT

local gui = Instance.new("ScreenGui", game.CoreGui)

gui.Name = "FLY(PC)"

-- ICON

local icon = Instance.new("TextButton", gui)

icon.Size = UDim2.new(0,50,0,50)

icon.Position = UDim2.new(0,20,0.5,-25)

icon.Text = "🤯"

icon.TextSize = 24

icon.Font = Enum.Font.GothamBold

icon.BackgroundColor3 = Color3.fromRGB(35,35,35)

icon.TextColor3 = Color3.new(1,1,1)

icon.Active = true

icon.Draggable = true

Instance.new("UICorner", icon).CornerRadius = UDim.new(0,14)

-- MAIN

local main = Instance.new("Frame", gui)

main.Size = UDim2.new(0,260,0,180)

main.Position = UDim2.new(0.5,-130,0.5,-90)

main.BackgroundColor3 = Color3.fromRGB(25,25,25)

main.Active = true

main.Draggable = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

-- TITLE

local title = Instance.new("TextLabel", main)

title.Size = UDim2.new(1,0,0,35)

title.Text = "SONNA HUB V1 | FREE FLY"

title.BackgroundTransparency = 1

title.TextColor3 = Color3.new(1,1,1)

title.Font = Enum.Font.GothamBold

title.TextSize = 16

-- SPEED

local speedBox = Instance.new("TextBox", main)

speedBox.Position = UDim2.new(0,20,0,60)

speedBox.Size = UDim2.new(1,-40,0,35)

speedBox.Text = "50"

speedBox.Font = Enum.Font.Gotham

speedBox.TextSize = 14

speedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)

speedBox.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,10)

-- TOGGLE

local toggle = Instance.new("TextButton", main)

toggle.Position = UDim2.new(0,20,0,110)

toggle.Size = UDim2.new(1,-40,0,40)

toggle.Text = "FLY : OFF"

toggle.Font = Enum.Font.GothamBold

toggle.TextSize = 14

toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)

toggle.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,12)

icon.MouseButton1Click:Connect(function()

    main.Visible = not main.Visible

end)

-- ===== FLY LOGIC =====

local flying = false

local bv, bg

local hum, animate

local poseConn

local function stopAnimations(humanoid)

    local animator = humanoid:FindFirstChildOfClass("Animator")

    if not animator then return end

    for _,track in ipairs(animator:GetPlayingAnimationTracks()) do

        track:Stop(0)

    end

end

-- ===== R15 IY POSE FIX =====

local function applyR15PoseFix(char)

    local hum = char:WaitForChild("Humanoid")

    local animate = char:FindFirstChild("Animate")

    if animate then

        animate.Disabled = true

    end

    -- Reset khớp

    for _,v in ipairs(char:GetDescendants()) do

        if v:IsA("Motor6D") then

            v.Transform = CFrame.new()

        end

    end

    -- Giữ pose liên tục khi bay

    if poseConn then poseConn:Disconnect() end

    poseConn = RunService.Stepped:Connect(function()

        if flying and hum:GetState() == Enum.HumanoidStateType.Physics then

            for _,v in ipairs(char:GetDescendants()) do

                if v:IsA("Motor6D") then

                    v.Transform = CFrame.new()

                end

            end

        end

    end)

end

local function startFly()

    local char = lp.Character or lp.CharacterAdded:Wait()

    local hrp = char:WaitForChild("HumanoidRootPart")

    hum = char:WaitForChild("Humanoid")

    animate = char:FindFirstChild("Animate")

    stopAnimations(hum)

    if animate then animate.Disabled = true end

    applyR15PoseFix(char)

    hum.AutoRotate = false

    hum.PlatformStand = true

    hum:ChangeState(Enum.HumanoidStateType.Physics)

    hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)

    bv = Instance.new("BodyVelocity")

    bv.MaxForce = Vector3.new(9e9,9e9,9e9)

    bv.Velocity = Vector3.zero

    bv.Parent = hrp

    bg = Instance.new("BodyGyro")

    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)

    bg.P = 15000

    bg.CFrame = hrp.CFrame

    bg.Parent = hrp

end

local function stopFly()

    if bv then bv:Destroy() bv=nil end

    if bg then bg:Destroy() bg=nil end

    if poseConn then poseConn:Disconnect() poseConn=nil end

    if hum then

        hum.PlatformStand = false

        hum.AutoRotate = true

        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)

        hum:ChangeState(Enum.HumanoidStateType.GettingUp)

    end

    if animate then animate.Disabled = false end

end

local function toggleFly()

    flying = not flying

    toggle.Text = flying and "FLY : ON" or "FLY : OFF"

    if flying then startFly() else stopFly() end

end

toggle.MouseButton1Click:Connect(toggleFly)

UIS.InputBegan:Connect(function(i,gp)

    if gp then return end

    if i.KeyCode == Enum.KeyCode.F then

        toggleFly()

    end

end)

-- MOVE WASD

RunService.RenderStepped:Connect(function()

    if not flying or not bv or not bg then return end

    local cam = workspace.CurrentCamera

    local move = Vector3.zero

    local speed = tonumber(speedBox.Text) or 50

    if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end

    if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end

    if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end

    if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end

    bv.Velocity = move.Magnitude > 0 and move.Unit * speed or Vector3.zero

    bg.CFrame = cam.CFrame

end)
