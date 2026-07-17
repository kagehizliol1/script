--[Technical assessment: Overrides Humanoid state to Physics for flawless fly synchronization, implements dynamic 2D bounding boxes using camera projection, and applies an ultra-sleek UI layout with global cleanup functions.]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local Container = Instance.new("Frame")
local ButtonLayout = Instance.new("UIListLayout")

-- CoreGui Entegrasyonu
local success, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

ScreenGui.Name = "EclipseV3"
ScreenGui.ResetOnSpawn = false

-- Ultra-Cool Neon Panel Tasarımı
MainFrame.Name = "MainPanel"
MainFrame.Size = UDim2.new(0, 260, 0, 320)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

-- Glow / Neon Çerçeve Efekti
UIStroke.Color = Color3.fromRGB(255, 0, 128) -- Siber Pembe Neon
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

-- Başlık Grafiği
Title.Size = UDim2.new(0.8, 0, 0, 50)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Ξ C L I P S Ξ  v3"
Title.TextSize = 18
Title.Font = Enum.Font.FredokaOne
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Kapatma Butonu (X)
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(0.83, 0, 0.05, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 10, 15)
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Buton Taşıyıcı Panel
Container.Size = UDim2.new(0, 230, 0, 250)
Container.Position = UDim2.new(0, 15, 0, 55)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

ButtonLayout.Padding = UDim.new(0, 12)
ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
ButtonLayout.Parent = Container

---------------------------------------------------------
-- PREMIUM BUTON GENERATOR
---------------------------------------------------------
local function CreateCoolButton(name, text, order)
    local Btn = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    
    Btn.Name = name
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Btn.TextColor3 = Color3.fromRGB(150, 150, 160)
    Btn.Text = text
    Btn.TextSize = 12
    Btn.Font = Enum.Font.GothamBold
    Btn.LayoutOrder = order
    Btn.Parent = Container
    
    BtnCorner.CornerRadius = UDim.new(0, 10)
    BtnCorner.Parent = Btn
    
    BtnStroke.Color = Color3.fromRGB(40, 40, 45)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Btn
    
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 38)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 25)}):Play()
    end)
    
    local active = false
    local function setVisualState(state)
        active = state
        if active then
            TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color3 = Color3.fromRGB(255, 0, 128)}):Play()
        else
            TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 160)}):Play()
            TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color3 = Color3.fromRGB(40, 40, 45)}):Play()
        end
    end
    
    return Btn, function() return active end, setVisualState
end

local FlyBtn, isFlying, setFlyVisual = CreateCoolButton("Fly", "FLY ENGINE (FIXED)", 1)
local NoclipBtn, isNoclip, setNoclipVisual = CreateCoolButton("Noclip", "NOCLIP WALLPASS", 2)
local EspBtn, isEsp, setEspVisual = CreateCoolButton("ESP", "2D BOX RADAR (ESP)", 3)

---------------------------------------------------------
-- MANTIKSAL ÇEKİRDEK (MECANICS)
---------------------------------------------------------

-- 1. HARD-FIXED FLY MANTITY
local flySpeed = 50
local flyConnection

FlyBtn.MouseButton1Click:Connect(function()
    local newState = not isFlying()
    setFlyVisual(newState)
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not hrp or not hum then return end
    
    if newState then
        if flyConnection then flyConnection:Disconnect() end
        
        -- Karakter yerçekimi etkileşimini kesmek için fizik moduna alınır
        flyConnection = RunService.RenderStepped:Connect(function()
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
            local currentHrp = LocalPlayer.Character.HumanoidRootPart
            local currentHum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            
            currentHum:ChangeState(Enum.HumanoidStateType.Physics)
            
            local moveVelocity = Vector3.new(0, 0, 0)
            if currentHum.MoveDirection.Magnitude > 0 then
                local moveDir = currentHum.MoveDirection
                moveVelocity = (Camera.CFrame.LookVector * moveDir.Z + Camera.CFrame.RightVector * moveDir.X).Unit * flySpeed
            else
                -- Sabit dururken havada asılı kalması için hızı sıfırlıyoruz
                moveVelocity = Vector3.new(0, 0, 0)
            end
            
            -- Doğrudan montaj hızını ezerek yerçekimi düşüşünü tamamen engelleriz
            currentHrp.AssemblyLinearVelocity = moveVelocity
            currentHrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end)

-- 2. NOCLIP MECHANIC
RunService.Stepped:Connect(function()
    if isNoclip() and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)
NoclipBtn.MouseButton1Click:Connect(function() setNoclipVisual(not isNoclip()) end)

-- 3. MATEMATİKSEL 2D BOX ESP SYSTEM
local boxes = {}

local function CreateBox()
    local BoxFrame = Instance.new("Frame")
    local Stroke = Instance.new("UIStroke")
    
    BoxFrame.Size = UDim2.new(0, 0, 0, 0)
    BoxFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BoxFrame.BackgroundTransparency = 1
    BoxFrame.Visible = false
    BoxFrame.Parent = ScreenGui
    
    Stroke.Color = Color3.fromRGB(255, 0, 128)
    Stroke.Thickness = 1.5
    Stroke.Parent = BoxFrame
    
    return BoxFrame
end

local function UpdateESP()
    for player, box in pairs(boxes) do
        if isEsp() and player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local hrp = player.Character.HumanoidRootPart
            local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                -- Karakterin boyutlarını ekrana göre oranlama
                local topPos = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
                local bottomPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.5, 0))
                
                local boxHeight = math.abs(topPos.Y - bottomPos.Y)
                local boxWidth = boxHeight / 1.8
                
                box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                box.Position = UDim2.new(0, hrpPos.X - (boxWidth / 2), 0, hrpPos.Y - (boxHeight / 2))
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
end

local function ManagePlayerESP(player)
    if player == LocalPlayer then return end
    if not boxes[player] then
        boxes[player] = CreateBox()
    end
    
    player.CharacterRemoving:Connect(function()
        if boxes[player] then boxes[player].Visible = false end
    end)
end

EspBtn.MouseButton1Click:Connect(function()
    local newState = not isEsp()
    setEspVisual(newState)
    
    if newState then
        for _, p in pairs(Players:GetPlayers()) do ManagePlayerESP(p) end
    else
        for _, box in pairs(boxes) do box.Visible = false end
    end
end)

Players.PlayerAdded:Connect(ManagePlayerESP)
Players.PlayerRemoving:Connect(function(p)
    if boxes[p] then
        boxes[p]:Destroy()
        boxes[p] = nil
    end
end)

RunService.RenderStepped:Connect(UpdateESP)

---------------------------------------------------------
-- KUKLA VE TEMİZLİK (SHUTDOWN PROCESS)
---------------------------------------------------------
CloseBtn.MouseButton1Click:Connect(function()
    -- Tüm aktif döngüleri sonlandır
    if flyConnection then flyConnection:Disconnect() end
    
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    
    -- ESP Kutularını kaldır
    for _, box in pairs(boxes) do
        box:Destroy()
    end
    table.clear(boxes)
    
    -- GUI'yi imha et
    ScreenGui:Destroy()
end)
