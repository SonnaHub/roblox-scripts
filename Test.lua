local plr = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- TẠO GUI CƠ BẢN (TỐI ƯU MOBILE)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "SonnaFlyMobile"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.5, 0) -- Đặt bên trái để không vướng nút nhảy
MainFrame.Size = UDim2.new(0, 120, 0, 60)
MainFrame.Active = true

-- Hàm làm cho GUI có thể kéo được trên điện thoại (Touch Draggable)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

ToggleButton.Parent = MainFrame
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Text = "FLY: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 20

-- BIẾN LOGIC
local flying = false
local speed = 50
local bv, bg

function toggleFly()
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    if flying then
        flying = false
        ToggleButton.Text = "FLY: OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 50, 50)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        hum.PlatformStand = false
    else
        flying = true
        ToggleButton.Text = "FLY: ON"
        ToggleButton.TextColor3 = Color3.fromRGB(50, 255, 50)
        
        hum.PlatformStand = true
        
        -- Lực nâng
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp
        
        -- Giữ hướng người theo Camera
        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 10000
        bg.Parent = hrp

        -- Vòng lặp xử lý di chuyển (Tương thích Joystick)
        task.spawn(function()
            while flying do
                local camera = workspace.CurrentCamera
                -- Lấy hướng di chuyển từ Joystick của Mobile thông qua MoveDirection
                if hum and hrp then
                    bg.CFrame = camera.CFrame
                    -- Nếu người dùng đang đẩy Joystick, MoveDirection sẽ khác 0
                    if hum.MoveDirection.Magnitude > 0 then
                        bv.Velocity = camera.CFrame.LookVector * (hum.MoveDirection.Magnitude * speed)
                    else
                        bv.Velocity = Vector3.new(0, 0, 0)
                    end
                end
                RunService.RenderStepped:Wait()
            end
        end)
    end
end

ToggleButton.MouseButton1Click:Connect(toggleFly)
