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
local ToggleMenuBtn = Instance.new("TextButton")
local Container = Instance.new("ScrollingFrame") -- Büyüyen özellikler için kaydırılabilir panel
local ButtonLayout = Instance.new("UIListLayout")

local success, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

ScreenGui.Name = "EclipseV5"
ScreenGui.ResetOnSpawn = false

-- CYBERPUNK PREMIUM MAX INTERFACE (Genişletilmiş Boyut)
MainFrame.Name = "MainPanel"
MainFrame.Size = UDim2.new(0, 280, 0, 420) -- GUI Büyütüldü
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(9, 9, 12)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

UIStroke.Color = Color3.fromRGB(0, 255, 150)
UIStroke.Thickness = 1.8
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

Title.Size = UDim2.new(0.8, 0, 0, 50)
Title.Position = UDim2.new(0.06, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "E C L I P S E  v5 : ULTRA"
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- KÜÇÜLME / AÇILMA BUTONU (Sağ Alt Köşe İçin Sabit Tetikleyici)
ToggleMenuBtn.Name = "ToggleMenuBtn"
ToggleMenuBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleMenuBtn.Position = UDim2.new(0.9, 0, 0.85, 0)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(11, 11, 14)
ToggleMenuBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
ToggleMenuBtn.Text = "E"
ToggleMenuBtn.TextSize = 18
ToggleMenuBtn.Font = Enum.Font.GothamBold
ToggleMenuBtn.Parent = ScreenGui

local TglCorner = Instance.new("UICorner")
TglCorner.CornerRadius = UDim.new(1, 0) -- Tam Yuvarlak
TglCorner.Parent = ToggleMenuBtn

local TglStroke = Instance.new("UIStroke")
TglStroke.Color = Color3.fromRGB(0, 255, 150)
TglStroke.Thickness = 1.5
TglStroke.Parent = ToggleMenuBtn

Container.Size = UDim2.new(0, 250, 0, 350)
Container.Position = UDim2.new(0, 15, 0, 55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.CanvasSize = UDim2.new(0, 0, 0, 520) -- İçerik kaydırma alanı genişletildi
Container.Parent = MainFrame

ButtonLayout.Padding = UDim.new(0, 8)
ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
ButtonLayout.Parent = Container

---------------------------------------------------------
-- ANIMATION SYSTEM (Menü Açılış Kapanış Efekti)
---------------------------------------------------------
local menuOpen = true
local originalSize = UDim2.new(0, 280, 0, 420)

ToggleMenuBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    if menuOpen then
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = originalSize, BackgroundTransparency = 0.1}):Play()
        ToggleMenuBtn.Text = "✕"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 280, 0, 0), BackgroundTransparency = 1}):Play()
        task.delay(0.2, function() if not menuOpen then MainFrame.Visible = false end end)
        ToggleMenuBtn.Text = "E"
    end
end)

---------------------------------------------------------
-- FEATURE BUTTON FACTORY
---------------------------------------------------------
local function CreateFeatureButton(name, text, order)
    local Btn = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    
    Btn.Name = name
    Btn.Size = UDim2.new(0.95, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Btn.TextColor3 = Color3.fromRGB(140, 140, 150)
    Btn.Text = text
    Btn.TextSize = 11
    Btn.Font = Enum.Font.GothamBold
    Btn.LayoutOrder = order
    Btn.Parent = Container
    
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn
    
    BtnStroke.Color = Color3.fromRGB(30, 30, 35)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Btn
    
    local active = false
    local function setVisualState(state)
        active = state
        if active then
            TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = Color3.fromRGB(22, 30, 26)}):Play()
            TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color3 = Color3.fromRGB(0, 255, 150)}):Play()
        else
            TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(140, 140, 150), BackgroundColor3 = Color3.fromRGB(18, 18, 24)}):Play()
            TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color3 = Color3.fromRGB(30, 30, 35)}):Play()
        end
    end
    
    return Btn, function() return active end, setVisualState
end

local FlyBtn, isFlying, setFlyVisual = CreateFeatureButton("Fly", "FLY ENGINE V5 (BODYPHYSICS)", 1)
local AimbotBtn, isAimbot, setAimbotVisual = CreateFeatureButton("Aimbot", "LOCK-ON AIMBOT (HEAD)", 2)
local EspBtn, isEsp, setEspVisual = CreateFeatureButton("Esp", "2D BOX RECON SENSOR", 3)
local SpeedBtn, isSpeed, setSpeedVisual = CreateFeatureButton("Speed", "SPEED MODIFIER (60)", 4)
local JumpBtn, isJump, setJumpVisual = CreateFeatureButton("Jump", "HIGH JUMP MODIFIER", 5)
local InfJumpBtn, isInfJump, setInfJumpVisual = CreateFeatureButton("InfJump", "INFINITE AIR JUMP", 6)
local NoclipBtn, isNoclip, setNoclipVisual = CreateFeatureButton("Noclip", "MATRIX NOCLIP", 7)

---------------------------------------------------------
-- SYSTEM MECHANICS & RE-WRITTEN MODULES
---------------------------------------------------------

-- 1. RE-WRITTEN HARDWARE FLY (Kesin Çözüm: BodyVelocity Mimari)
local flyBV, flyBG
local flySpeedSetting = 50

local function ClearFlyObjects()
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
end

FlyBtn.MouseButton1Click:Connect(function()
    local newState = not isFlying()
    setFlyVisual(newState)
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not newState then
        ClearFlyObjects()
        if hum then hum.PlatformStand = false end
        return
    end
    
    if not hrp or not hum then return end
    ClearFlyObjects()
    
    hum.PlatformStand = true
    
    flyBG = Instance.new("BodyGyro")
    flyBG.P = 9e4
    flyBG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBG.cframe = hrp.CFrame
    flyBG.Parent = hrp
    
    flyBV = Instance.new("BodyVelocity")
    flyBV.velocity = Vector3.new(0, 0.1, 0)
    flyBV.maxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.Parent = hrp
    
    task.spawn(function()
        while isFlying() and char and hrp and hum and Parent do
            RunService.Heartbeat:Wait()
            flyBG.cframe = Camera.CFrame
            
            local moveDir = hum.MoveDirection
            local velocityVector = Vector3.new(0, 0, 0)
            
            if moveDir.Magnitude > 0 then
                local camCFrame = Camera.CFrame
                velocityVector = (camCFrame.LookVector * -moveDir.Z + camCFrame.RightVector * moveDir.X).Unit * flySpeedSetting
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocityVector = velocityVector + Vector3.new(0, flySpeedSetting, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocityVector = velocityVector + Vector3.new(0, -flySpeedSetting, 0)
            end
            
            flyBV.velocity = velocityVector
        end
        ClearFlyObjects()
        if hum then hum.PlatformStand = false end
    end)
end)

-- 2. SILENT-STYLE COGNITIVE AIMBOT
local function GetClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildOfClass("Humanoid") then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum.Health > 0 then
                local headPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
                if onScreen then
                    local distance = (Vector2.new(headPos.X, headPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return closestPlayer
end

AimbotBtn.MouseButton1Click:Connect(function() setAimbotVisual(not isAimbot()) end)

RunService.RenderStepped:Connect(function()
    if isAimbot() and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then -- Sağ Tık Basılı Tutunca Çalışır
        local target = GetClosestPlayerToCursor()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- 3. PERFECTIONIST 2D BOX ESP
local boxes = {}
local function CreateDynamicBox()
    local BoxFrame = Instance.new("Frame")
    local Stroke = Instance.new("UIStroke")
    BoxFrame.Size = UDim2.new(0, 0, 0, 0)
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
                    local topWorld = hrp.Position + Camera.CFrame.UpVector * 3.2
                    local bottomWorld = hrp.Position - Camera.CFrame.UpVector * 4.2
                    local topScreen = Camera:WorldToViewportPoint(topWorld)
                    local bottomScreen = Camera:WorldToViewportPoint(bottomWorld)
                    local boxHeight = math.abs(topScreen.Y - bottomScreen.Y)
                    local boxWidth = boxHeight / 1.5
                    box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                    box.Position = UDim2.new(0, hrpPos.X - (boxWidth / 2), 0, hrpPos.Y - (boxHeight / 2))
                    box.Visible = true
                else box.Visible = false end
            else box.Visible = false end
        else box.Visible = false end
    end
end

local function RegisterPlayer(player)
    if player == LocalPlayer then return end
    if not boxes[player] then boxes[player] = CreateDynamicBox() end
    player.CharacterRemoving:Connect(function() if boxes[player] then boxes[player].Visible = false end end)
end

EspBtn.MouseButton1Click:Connect(function()
    local newState = not isEsp()
    setEspVisual(newState)
    if newState then
        for _, p in pairs(Players:GetPlayers()) do RegisterPlayer(p) end
    else
        for _, box in pairs(boxes) do box.Visible = false end
    end
end)
Players.PlayerAdded:Connect(RegisterPlayer)
RunService.RenderStepped:Connect(TrackESP)

-- 4. SPEED & JUMP MODIFIERS
SpeedBtn.MouseButton1Click:Connect(function() setSpeedVisual(not isSpeed()) end)
JumpBtn.MouseButton1Click:Connect(function() setJumpVisual(not isJump()) end)

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if isSpeed() then hum.WalkSpeed = 60 else hum.WalkSpeed = 16 end
        if isJump() then hum.JumpPower = 120; hum.UseJumpPower = true else if not isJump() and hum.JumpPower == 120 then hum.JumpPower = 50 end end
    end
end)

-- 5. INFINITE AIR JUMP
UserInputService.JumpRequest:Connect(function()
    if isInfJump() then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
InfJumpBtn.MouseButton1Click:Connect(function() setInfJumpVisual(not isInfJump()) end)

-- 6. NOCLIP ENGINE
NoclipBtn.MouseButton1Click:Connect(function() setNoclipVisual(not isNoclip()) end)
RunService.Stepped:Connect(function()
    if isNoclip() and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)
