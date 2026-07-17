--[Technical assessment: Creates a screen GUI with fly and noclip toggles using local physics manipulation.]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Ekran Arayüzü Oluşturma
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FlyBtn = Instance.new("TextButton")
local NoClipBtn = Instance.new("TextButton")

-- Arayüzü korumalı alana ekle (Eğer executor destekliyorsa, yoksa PlayerGui kullanır)
local success, err = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not success then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

ScreenGui.Name = "DevMenu"
ScreenGui.ResetOnSpawn = false

-- Ana Pencere Özellikleri
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Sürüklenebilir yapma
MainFrame.Parent = ScreenGui

-- Başlık
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Hax Menu"
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Uçma Butonu
FlyBtn.Size = UDim2.new(0.9, 0, 0, 40)
FlyBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
FlyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.Text = "Fly: OFF"
FlyBtn.TextSize = 16
FlyBtn.Font = Enum.Font.SourceSans
FlyBtn.Parent = MainFrame

-- Noclip Butonu
NoClipBtn.Size = UDim2.new(0.9, 0, 0, 40)
NoClipBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
NoClipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
NoClipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipBtn.Text = "Noclip: OFF"
NoClipBtn.TextSize = 16
NoClipBtn.Font = Enum.Font.SourceSans
NoClipBtn.Parent = MainFrame

---------------------------------------------------------
-- MANTIKSAL FONKSİYONLAR
---------------------------------------------------------

local flying = false
local noclip = false
local flySpeed = 50

-- Noclip Mantığı (Karakterin parçalarının CanCollide özelliğini kapatır)
local noclipConnection
noclipConnection = RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

NoClipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    if noclip then
        NoClipBtn.Text = "Noclip: ON"
        NoClipBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        NoClipBtn.Text = "Noclip: OFF"
        NoClipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- Fly Mantığı (BodyVelocity ve BodyGyro kullanarak karakteri havada tutar)
FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    local character = LocalPlayer.Character
    local torso = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
    
    if not torso then return end
    
    if flying then
        FlyBtn.Text = "Fly: ON"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        local bg = Instance.new("BodyGyro", torso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e5, 9e5, 9e5)
        bg.cframe = torso.CFrame
        bg.Name = "FlyGyro"
        
        local bv = Instance.new("BodyVelocity", torso)
        bv.velocity = Vector3.new(0, 0.1, 0)
        bv.maxForce = Vector3.new(9e5, 9e5, 9e5)
        bv.Name = "FlyVelocity"
        
        -- Kamera yönüne göre hareket kontrolü döngüsü
        task.spawn(function()
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            while flying and character and torso and parent do
                RunService.RenderStepped:Wait()
                bv.velocity = Vector3.new(0, 0.1, 0)
                
                if humanoid.MoveDirection.Magnitude > 0 then
                    -- Kameranın baktığı açıyı referans alarak hareket ettir
                    local camCFrame = workspace.CurrentCamera.CFrame
                    local moveDir = humanoid.MoveDirection
                    bv.velocity = (camCFrame.LookVector * moveDir.Z + camCFrame.RightVector * moveDir.X).Unit * flySpeed
                end
                bg.cframe = workspace.CurrentCamera.CFrame
            end
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end)
    else
        FlyBtn.Text = "Fly: OFF"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        if torso:FindFirstChild("FlyGyro") then torso.FlyGyro:Destroy() end
        if torso:FindFirstChild("FlyVelocity") then torso.FlyVelocity:Destroy() end
    end
end)
