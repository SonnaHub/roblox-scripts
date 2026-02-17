local plr = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- TẠO GUI CƠ BẢN (TỐI ƯU MOBILE)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "SonnaFlyMobile_V2"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0) 
MainFrame.Size = UDim2.new(0, 120, 0, 60)
MainFrame.Active = true

-- Hàm làm cho GUI có thể kéo được trên điện thoại
local dragging, dragStart, startPos
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
ToggleButton.TextColor3 = Color3.fromRGB(255, 50, 50)
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
        
        -- Lực vận tốc
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp
        
        -- Giữ hướng người theo Camera
        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 10000
        bg.Parent = hrp

        -- Vòng lặp xử lý di chuyển đa hướng cho Mobile
        task.spawn(function()
            while flying and char and char:Parent do
                local camera = workspace.CurrentCamera
                if hum and hrp then
                    -- Xoay nhân vật theo góc nhìn Camera
                    bg.CFrame = camera.CFrame
                    
                    if hum.MoveDirection.Magnitude > 0 then
                        -- TÍNH TOÁN HƯỚNG BAY ĐA HƯỚNG:
                        -- Lấy vector di chuyển của Joystick (hum.MoveDirection)
                        -- Chuyển đổi nó để nó tương ứng với hướng Camera hiện tại
                        local lookV = camera.CFrame.LookVector
                        local rightV = camera.CFrame.RightVector
                        local upV = camera.CFrame.UpVector
                        
                        -- Công thức tính toán để Joystick đẩy hướng nào bay hướng đó:
                        -- Chúng ta lấy hướng di chuyển thô và "xoay" nó theo Camera
                        local sideVec = rightV * (hum.MoveDirection:Dot(rightV))
                        local forwardVec = lookV * (hum.MoveDirection:Dot(lookV))
                        
                        -- Nếu bạn đang nhìn lên/xuống, hướng LookVector sẽ có thành phần Y, giúp bay lên/xuống
                        bv.Velocity = (hum.MoveDirection + (lookV * hum.MoveDirection.Magnitude)).Unit * speed
                        
                        -- Tuy nhiên, cách đơn giản nhất và mượt nhất cho Mobile là:
                        -- Lấy hướng xoay của Camera nhân với hướng Joystick đẩy
                        local finalVelocity = camera.CFrame:VectorToWorldSpace(Vector3.new(
                            hum.MoveDirection:Dot(camera.CFrame.RightVector), 
                            hum.MoveDirection:Dot(camera.CFrame.UpVector), 
                            hum.MoveDirection:Dot(camera.CFrame.LookVector)
                        ))
                        
                        -- Gán vận tốc (đã tối ưu để nhạy hơn với Joystick)
                        bv.Velocity = hum.MoveDirection * speed + (camera.CFrame.LookVector * (hum.MoveDirection.Magnitude * speed))
                        -- Lưu ý: Dòng trên giúp "đẩy" mạnh hơn theo hướng nhìn của bạn.
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

-- Tự động tắt fly khi nhân vật chết để tránh lỗi
plr.CharacterAdded:Connect(function()
    flying = false
    ToggleButton.Text = "FLY: OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 50, 50)
end)
