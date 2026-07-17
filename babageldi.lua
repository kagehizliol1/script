--[Technical assessment: Implements modern VectorForce/LinearVelocity mechanics for the fly exploit, embeds an highlight-based ESP system, and builds a dark-neon sleek UI.]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- UI OLUŞTURMA & MODERNİZASYON
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local ButtonLayout = Instance.new("UIListLayout")

-- Koşullu Parent Belirleme (CoreGui desteği kontrolü)
local success, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

ScreenGui.Name = "SleekEclipse"
ScreenGui.ResetOnSpawn = false

-- Ana Panel Tasarımı (Karanlık/Neon Tema)
MainFrame.Name = "MainPanel"
MainFrame.Size = UDim2.new(0, 240, 0, 320)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Premium İnce Neon Çerçeve
UIStroke.Color = Color3.fromRGB(0, 210, 255)
UIStroke.Thickness = 1.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

-- Başlık
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "E C L I P S E  v2"
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Butonları Hizalayıcı Container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(0, 210, 0, 250)
Container.Position = UDim2.new(0, 15, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

ButtonLayout.Padding = UDim.new(0, 10)
ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
ButtonLayout.Parent = Container

---------------------------------------------------------
-- ULTRA COOL BUTON FABRİKASI (Animasyonlu & Glow Efektli)
---------------------------------------------------------
local function CreateCoolButton(name, text, order)
    local Btn = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    
    Btn.Name = name
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.Text = text
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamMedium
    Btn.LayoutOrder = order
    Btn.Parent = Container
    
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn
    
    BtnStroke.Color = Color3.fromRGB(45, 45, 50)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Btn
    
    -- Hover ve Tıklama Efektleri (Tween)
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
    end)
    
    local active = false
    local function setVisualState(state)
        active = state
        if active then
            TweenService:Create(Btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(BtnStroke, TweenInfo.new(0.3), {Color3 = Color3.fromRGB(0, 210, 255)}):Play()
        else
            TweenService:Create(Btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
            TweenService:Create(BtnStroke, TweenInfo.new(0.3), {Color3 = Color3.fromRGB(45, 45, 50)}):Play()
        end
    end
    
    return Btn, function() return active end, setVisualState
end

local FlyBtn, isFlying, setFlyVisual = CreateCoolButton("Fly", "FLY MECHANICS", 1)
local NoclipBtn, isNoclip, setNoclipVisual = CreateCoolButton("Noclip", "PHASE / NOCLIP", 2)
local InfJumpBtn, isInfJump, setInfJumpVisual = CreateCoolButton("InfJump", "INFINITE JUMP", 3)
local EspBtn, isEsp, setEspVisual = CreateCoolButton("ESP", "PLAYER RADAR (ESP)", 4)

---------------------------------------------------------
-- ÖZELLİK MANTIKLARI (FIXED & MODERNIZED)
---------------------------------------------------------

-- 1. FİXED FLY (Modern Attachment tabanlı LinearVelocity & AlignOrientation)
local flySpeed = 60
local att, lv, ao

local function clearFlyPhysics()
    if lv then lv:Destroy(); lv = nil end
    if ao then ao:Destroy(); ao = nil end
    if att then att:Destroy(); att = nil end
end

FlyBtn.MouseButton1Click:Connect(function()
    local newState = not isFlying()
    setFlyVisual(newState)
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if newState then
        clearFlyPhysics()
        
        att = Instance.new("Attachment", hrp)
        att.Name = "FlyAtt"
        
        lv = Instance.new("LinearVelocity", hrp)
        lv.Attachment0 = att
        lv.MaxForce = 9e9
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        lv.VectorVelocity = Vector3.new(0, 0, 0)
        
        ao = Instance.new("AlignOrientation", hrp)
        ao.Attachment0 = att
        ao.MaxTorque = 9e9
        ao.Responsiveness = 200
        ao.CFrame = hrp.CFrame
        
        task.spawn(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            while isFlying() and char and hrp and lv and ao do
                RunService.RenderStepped:Wait()
                local cam = workspace.CurrentCamera
                if hum.MoveDirection.Magnitude > 0 then
                    local moveDir = hum.MoveDirection
                    lv.VectorVelocity = (cam.CFrame.LookVector * moveDir.Z + cam.CFrame.RightVector * moveDir.X).Unit * flySpeed
                else
                    lv.VectorVelocity = Vector3.new(0, 0, 0)
                end
                ao.CFrame = cam.CFrame
            end
            clearFlyPhysics()
        end)
    else
        clearFlyPhysics()
    end
end)

-- 2. NOCLIP
RunService.Stepped:Connect(function()
    if isNoclip() and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)
NoclipBtn.MouseButton1Click:Connect(function() setNoclipVisual(not isNoclip()) end)

-- 3. INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if isInfJump() and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
InfJumpBtn.MouseButton1Click:Connect(function() setInfJumpVisual(not isInfJump()) end)

-- 4. VISUAL ESP (Modern Highlight Nesnesiyle Duvar Arkası Görme)
local function applyESP(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function(char)
        if isEsp() then
            local hl = Instance.new("Highlight", char)
            hl.Name = "EclipseESP"
            hl.FillColor = Color3.fromRGB(0, 210, 255)
            hl.FillTransparency = 0.5
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end)
    if player.Character then
        local hl = Instance.new("Highlight", player.Character)
        hl.Name = "EclipseESP"
        hl.FillColor = Color3.fromRGB(0, 210, 255)
        hl.FillTransparency = 0.5
    end
end

EspBtn.MouseButton1Click:Connect(function()
    local newState = not isEsp()
    setEspVisual(newState)
    
    if newState then
        for _, p in pairs(Players:GetPlayers()) do applyESP(p) end
        Players.PlayerAdded:Connect(applyESP)
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("EclipseESP") then
                p.Character.EclipseESP:Destroy()
            end
        end
    end
end)
