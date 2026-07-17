local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- UI ROOT
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local Container = Instance.new("Frame")
local ButtonLayout = Instance.new("UIListLayout")

local success, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

ScreenGui.Name = "EclipseV4"
ScreenGui.ResetOnSpawn = false

-- CYBERPUNK PREMIUM INTERFACE
MainFrame.Name = "MainPanel"
MainFrame.Size = UDim2.new(0, 250, 0, 280)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 14)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

UIStroke.Color = Color3.fromRGB(0, 255, 150) -- Cyber Green Neon
UIStroke.Thickness = 1.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

Title.Size = UDim2.new(0.8, 0, 0, 50)
Title.Position = UDim2.new(0.06, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "E C L I P S E  v4"
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0.83, 0, 0.06, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 15, 18)
CloseBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Text = "✕"
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

Container.Size = UDim2.new(0, 220, 0, 210)
Container.Position = UDim2.new(0, 15, 0, 55)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

ButtonLayout.Padding = UDim.new(0, 10)
ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
ButtonLayout.Parent = Container

---------------------------------------------------------
-- ENGINE BUTTON FACTORY
---------------------------------------------------------
local function CreatePremiumButton(name, text, order)
    local Btn = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    
    Btn.Name = name
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Btn.TextColor3 = Color3.fromRGB(140, 140, 150)
    Btn.Text = text
    Btn.TextSize = 12
    Btn.Font = Enum.Font.GothamBold
    Btn.LayoutOrder = order
    Btn.Parent = Container
    
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn
    
    BtnStroke.Color = Color3.fromRGB(35, 35, 40)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Btn
    
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 35)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 25)}):Play()
    end)
    
    local active = false
    local function setVisualState(state)
        active = state
        if active then
            TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color3 = Color3.fromRGB(0, 255, 150)}):Play()
        else
            TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(140, 140, 150)}):Play()
            TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color3 = Color3.fromRGB(35, 35, 40)}):Play()
        end
    end
    
    return Btn, function() return active end, setVisualState
end

local FlyBtn, isFlying, setFlyVisual = CreatePremiumButton("Fly", "HYBRID FLY ENGINE", 1)
local NoclipBtn, isNoclip, setNoclipVisual = CreatePremiumButton("Noclip", "MATRIX NOCLIP", 2)
local EspBtn, isEsp, setEspVisual = CreatePremiumButton("ESP", "PERFECT 2D BOX ESP", 3)

---------------------------------------------------------
-- CORE MECHANICS
---------------------------------------------------------

-- 1. ENHANCED HYBRID FLY ENGINE (Örnek Kod Entegrasyonlu)
local flySpeed = 2.5
local flyConnection
local savedAnims = {}

local function toggleStates(humanoid, state)
    local enumStates = Enum.HumanoidStateType:GetEnumItems()
    for _, s in pairs(enumStates) do
        pcall(function() humanoid:SetStateEnabled(s, state) end)
    end
end

FlyBtn.MouseButton1Click:Connect(function()
    local newState = not isFlying()
    setFlyVisual(newState)
    
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if not char or not hum or not hrp then return end
    
    if newState then
        -- Animasyonları dondur (Örnek kod mantığı)
        pcall(function()
            char.Animate.Disabled = true
            for _, track in next, hum:GetPlayingAnimationTracks() do
                track:AdjustSpeed(0)
            end
        end)
        
        toggleStates(hum, false)
        hum:ChangeState(Enum.HumanoidStateType.Swimming)
        
        -- Heartbeat & TranslateBy Stabilizasyonu
        flyConnection = RunService.Heartbeat:Connect(function()
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
            local currentHrp = LocalPlayer.Character.HumanoidRootPart
            local currentHum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            
            currentHum.PlatformStand = true
            currentHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            currentHrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            
            -- Yön Hesaplama (Kamera LookVector Referanslı)
            local moveDir = currentHum.MoveDirection
            local flyVector = Vector3.new(0, 0, 0)
            
            if moveDir.Magnitude > 0 then
                local camCFrame = Camera.CFrame
                flyVector = (camCFrame.LookVector * -moveDir.Z + camCFrame.RightVector * moveDir.X).Unit * flySpeed
            end
            
            -- Dikey Eksen Kontrolleri (Space = Yukarı, LeftShift = Aşağı)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                flyVector = flyVector + Vector3.new(0, flySpeed, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                flyVector = flyVector + Vector3.new(0, -flySpeed, 0)
            end
            
            currentHrp.CFrame = currentHrp.CFrame + flyVector
        end)
    else
        if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
        
        if hum then
            toggleStates(hum, true)
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        
        pcall(function()
            char.Animate.Disabled = false
            local newHum = char:FindFirstChildOfClass("Humanoid")
            if newHum then
                for _, track in next, newHum:GetPlayingAnimationTracks() do
                    track:AdjustSpeed(1)
                end
            end
        end)
    end
end)

-- 2. NOCLIP ENGINE
RunService.Stepped:Connect(function()
    if isNoclip() and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)
NoclipBtn.MouseButton1Click:Connect(function() setNoclipVisual(not isNoclip()) end)

-- 3. FAULTLESS SCREEN-SPACE 2D BOX ESP
local boxes = {}

local function CreateDynamicBox()
    local BoxFrame = Instance.new("Frame")
    local Stroke = Instance.new("UIStroke")
    
    BoxFrame.Size = UDim2.new(0, 0, 0, 0)
    BoxFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BoxFrame.BackgroundTransparency = 1
    BoxFrame.Visible = false
    BoxFrame.Parent = ScreenGui
    
    Stroke.Color = Color3.fromRGB(0, 255, 150)
    Stroke.Thickness = 1.5
    Stroke.Parent = BoxFrame
    
    return BoxFrame
end

local function TrackESP()
    if not isEsp() then return end
    
    for player, box in pairs(boxes) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            
            if hum and hum.Health > 0 then
                local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                if onScreen then
                    -- Kusursuz hizalama: Kameranın yukarı eksenine göre gerçekçi yükseklik belirleme
                    local topWorld = hrp.Position + Camera.CFrame.UpVector * 3.2
                    local bottomWorld = hrp.Position - Camera.CFrame.UpVector * 4.2
                    
                    local topScreen = Camera:WorldToViewportPoint(topWorld)
                    local bottomScreen = Camera:WorldToViewportPoint(bottomWorld)
                    
                    local boxHeight = math.abs(topScreen.Y - bottomScreen.Y)
                    local boxWidth = boxHeight / 1.5
                    
                    box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                    box.Position = UDim2.new(0, hrpPos.X - (boxWidth / 2), 0, hrpPos.Y - (boxHeight / 2) - 2)
                    box.Visible = true
                else
                    box.Visible = false
                end
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
end

local function RegisterPlayer(player)
    if player == LocalPlayer then return end
    if not boxes[player] then
        boxes[player] = CreateDynamicBox()
    end
    
    player.CharacterRemoving:Connect(function()
        if boxes[player] then boxes[player].Visible = false end
    end)
end

-- Tüm Sunucuyu Döngüye Ekleme Mantığı (Fix)
local function InitESP(state)
    if state then
        for _, p in pairs(Players:GetPlayers()) do
            RegisterPlayer(p)
        end
    else
        for _, box in pairs(boxes) do
            box.Visible = false
        end
    end
end

EspBtn.MouseButton1Click:Connect(function()
    local newState = not isEsp()
    setEspVisual(newState)
    InitESP(newState)
end)

Players.PlayerAdded:Connect(RegisterPlayer)
Players.PlayerRemoving:Connect(function(p)
    if boxes[p] then
        boxes[p]:Destroy()
        boxes[p] = nil
    end
end)

RunService.RenderStepped:Connect(TrackESP)

---------------------------------------------------------
-- SHUTDOWN PROCESS
---------------------------------------------------------
CloseBtn.MouseButton1Click:Connect(function()
    if flyConnection then flyConnection:Disconnect() end
    
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        toggleStates(hum, true)
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
    pcall(function() char.Animate.Disabled = false end)
    
    for _, box in pairs(boxes) do box:Destroy() end
    table.clear(boxes)
    ScreenGui:Destroy()
end)
