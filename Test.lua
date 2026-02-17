local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Biến lưu trữ giá trị
local WalkSpeedValue = 16
local JumpPowerValue = 50
local SpeedEnabled = false
local JumpEnabled = false

-- Hàm cập nhật chỉ số cho nhân vật
local function ApplyStats()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    -- Bật UseJumpPower để đảm bảo JumpPower có tác dụng
    humanoid.UseJumpPower = true

    if SpeedEnabled then
        humanoid.WalkSpeed = WalkSpeedValue
    else
        humanoid.WalkSpeed = 16 -- Tốc độ mặc định
    end

    if JumpEnabled then
        humanoid.JumpPower = JumpPowerValue
    else
        humanoid.JumpPower = 50 -- Nhảy mặc định
    end
end

-- Tự động áp dụng lại khi reset (CharacterAdded)
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5) -- Đợi nhân vật load xong hẳn
    ApplyStats()
end)

-- Tạo Window Sonnahub
local Window = Rayfield:CreateWindow({
   Name = "Sonnahub",
   LoadingTitle = "Đang tải Sonnahub...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SonnahubConfig",
      FileName = "MainConfig"
   },
   KeySystem = false -- Tắt hệ thống key để bạn dùng cho nhanh
})

-- Tạo Tab Main
local MainTab = Window:CreateTab("Player Control", 4483362458) -- Icon người

-- PHẦN SPEED (TỐC ĐỘ)
MainTab:CreateSection("Speed Settings")

MainTab:CreateToggle({
   Name = "Bật/Tắt Tốc độ",
   CurrentValue = false,
   Callback = function(Value)
      SpeedEnabled = Value
      ApplyStats()
   end,
})

MainTab:CreateSlider({
   Name = "Chỉnh Tốc độ (Speed)",
   Range = {16, 500},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Callback = function(Value)
      WalkSpeedValue = Value
      if SpeedEnabled then
          ApplyStats()
      end
   end,
})

-- PHẦN JUMP POWER (SỨC NHẢY)
MainTab:CreateSection("Jump Settings")

MainTab:CreateToggle({
   Name = "Bật/Tắt Nhảy cao",
   CurrentValue = false,
   Callback = function(Value)
      JumpEnabled = Value
      ApplyStats()
   end,
})

MainTab:CreateSlider({
   Name = "Chỉnh Sức nhảy (Jump)",
   Range = {50, 500},
   Increment = 1,
   Suffix = " Power",
   CurrentValue = 50,
   Callback = function(Value)
      JumpPowerValue = Value
      if JumpEnabled then
          ApplyStats()
      end
   end,
})

Rayfield:Notify({
   Title = "Thành công!",
   Content = "Chào mừng bạn đến với Sonnahub",
   Duration = 5,
   Image = 4483362458,
})

