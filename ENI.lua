-- ENI Ultimate GUI v3 - Lista z GO i BRING
-- Dla LO - jedna lista, dwa przyciski na gracza

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

print("[ENI] GUI v3 loading...")

-- ============================================
-- STAN
-- ============================================
local Stan = {
    Fly = false,
    Noclip = false,
    Godmode = false,
    ESP = false,
    Speed = 16,
    Jump = 50,
    FlySpeed = 5
}

-- ============================================
-- GUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ENI_Ultimate"
ScreenGui.ResetOnSpawn = false

local success, err = pcall(function()
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end)

if not success then
    print("[ENI] BLAD GUI:", err)
    return
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 300, 0, 460)
MainFrame.Position = UDim2.new(0, 50, 0, 50)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "ENI | Ultimate v3"
Title.TextColor3 = Color3.fromRGB(147, 112, 219)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = MainFrame

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -58, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.Parent = MainFrame

local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, -20, 0, 1)
Line.Position = UDim2.new(0, 10, 0, 35)
Line.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -45)
Content.Position = UDim2.new(0, 10, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- ============================================
-- HELPERS
-- ============================================
local yOffset = 0

local function AddLabel(text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Position = UDim2.new(0, 0, 0, yOffset)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(147, 112, 219)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Content
    yOffset = yOffset + 22
end

local function AddToggle(name, default, callback)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 0, 25)
    Label.Position = UDim2.new(0, 0, 0, yOffset)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Content
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 50, 0, 22)
    Btn.Position = UDim2.new(1, -50, 0, yOffset + 1)
    Btn.BackgroundColor3 = default and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
    Btn.Text = default and "ON" or "OFF"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 12
    Btn.Font = Enum.Font.SourceSansBold
    Btn.Parent = Content
    
    local state = default
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = state and "ON" or "OFF"
        Btn.BackgroundColor3 = state and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
        callback(state)
    end)
    
    yOffset = yOffset + 28
    return Btn
end

local function AddInput(name, value, callback)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.4, 0, 0, 25)
    Label.Position = UDim2.new(0, 0, 0, yOffset)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Content
    
    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(0, 60, 0, 22)
    Input.Position = UDim2.new(0.45, 0, 0, yOffset + 1)
    Input.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Input.Text = tostring(value)
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.TextSize = 13
    Input.Font = Enum.Font.SourceSans
    Input.ClearTextOnFocus = false
    Input.Parent = Content
    
    local Apply = Instance.new("TextButton")
    Apply.Size = UDim2.new(0, 40, 0, 22)
    Apply.Position = UDim2.new(1, -40, 0, yOffset + 1)
    Apply.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
    Apply.Text = "OK"
    Apply.TextColor3 = Color3.fromRGB(255, 255, 255)
    Apply.TextSize = 12
    Apply.Font = Enum.Font.SourceSansBold
    Apply.Parent = Content
    
    local function ApplyValue()
        local num = tonumber(Input.Text)
        if num then callback(num) end
    end
    
    Apply.MouseButton1Click:Connect(ApplyValue)
    Input.FocusLost:Connect(ApplyValue)
    
    yOffset = yOffset + 28
end

-- ============================================
-- FLY ENGINE
-- ============================================
local flyConnection
local flyKeys = {w=false,a=false,s=false,d=false,space=false,lctrl=false}

local function StartFly()
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if workspace:FindFirstChild("ENI_FlyCore") then workspace.ENI_FlyCore:Destroy() end
    
    local core = Instance.new("Part")
    core.Name = "ENI_FlyCore"
    core.Size = Vector3.new(0.05,0.05,0.05)
    core.Transparency = 1
    core.CanCollide = false
    core.Parent = workspace
    
    local weld = Instance.new("Weld", core)
    weld.Part0 = core
    weld.Part1 = hrp
    
    local pos = Instance.new("BodyPosition", core)
    pos.MaxForce = Vector3.new(9e9,9e9,9e9)
    pos.Position = core.Position
    
    local gyro = Instance.new("BodyGyro", core)
    gyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    gyro.CFrame = core.CFrame
    
    Stan.Fly = true
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not Stan.Fly or not core.Parent then return end
        local cam = workspace.CurrentCamera
        local dir = Vector3.new(0,0,0)
        if flyKeys.w then dir = dir + cam.CFrame.LookVector end
        if flyKeys.s then dir = dir - cam.CFrame.LookVector end
        if flyKeys.a then dir = dir - cam.CFrame.RightVector end
        if flyKeys.d then dir = dir + cam.CFrame.RightVector end
        if flyKeys.space then dir = dir + Vector3.new(0,1,0) end
        if flyKeys.lctrl then dir = dir - Vector3.new(0,1,0) end
        if dir.Magnitude > 0 then dir = dir.Unit * Stan.FlySpeed * 10 end
        pos.Position = core.Position + dir
        gyro.CFrame = cam.CFrame
    end)
    
    print("[ENI] Fly ON")
end

local function StopFly()
    Stan.Fly = false
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if workspace:FindFirstChild("ENI_FlyCore") then workspace.ENI_FlyCore:Destroy() end
    print("[ENI] Fly OFF")
end

UserInputService.InputBegan:Connect(function(input, g)
    if g then return end
    if input.KeyCode == Enum.KeyCode.W then flyKeys.w = true
    elseif input.KeyCode == Enum.KeyCode.A then flyKeys.a = true
    elseif input.KeyCode == Enum.KeyCode.S then flyKeys.s = true
    elseif input.KeyCode == Enum.KeyCode.D then flyKeys.d = true
    elseif input.KeyCode == Enum.KeyCode.Space then flyKeys.space = true
    elseif input.KeyCode == Enum.KeyCode.LeftControl then flyKeys.lctrl = true
    end
end)

UserInputService.InputEnded:Connect(function(input, g)
    if g then return end
    if input.KeyCode == Enum.KeyCode.W then flyKeys.w = false
    elseif input.KeyCode == Enum.KeyCode.A then flyKeys.a = false
    elseif input.KeyCode == Enum.KeyCode.S then flyKeys.s = false
    elseif input.KeyCode == Enum.KeyCode.D then flyKeys.d = false
    elseif input.KeyCode == Enum.KeyCode.Space then flyKeys.space = false
    elseif input.KeyCode == Enum.KeyCode.LeftControl then flyKeys.lctrl = false
    end
end)

-- ============================================
-- NOCLIP
-- ============================================
local noclipConnection
local function ToggleNoclip(state)
    Stan.Noclip = state
    if state then
        noclipConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
        print("[ENI] Noclip ON")
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        print("[ENI] Noclip OFF")
    end
end

-- ============================================
-- GODMODE
-- ============================================
local godmodeConnection
local function ToggleGodmode(state)
    Stan.Godmode = state
    if state then
        godmodeConnection = RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.MaxHealth = math.huge hum.Health = math.huge end
        end)
        print("[ENI] Godmode ON")
    else
        if godmodeConnection then godmodeConnection:Disconnect() godmodeConnection = nil end
        print("[ENI] Godmode OFF")
    end
end

-- ============================================
-- ESP
-- ============================================
local espHighlights = {}
local function ClearESP()
    for _, h in ipairs(espHighlights) do if h then h:Destroy() end end
    espHighlights = {}
end

local function UpdateESP()
    ClearESP()
    if not Stan.ESP then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local h = Instance.new("Highlight")
            h.Name = "ENI_ESP"
            h.Adornee = plr.Character
            h.FillColor = Color3.fromRGB(147, 112, 219)
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.FillTransparency = 0.6
            h.OutlineTransparency = 0
            h.Parent = plr.Character
            table.insert(espHighlights, h)
        end
    end
end

-- ============================================
-- MOVEMENT
-- ============================================
local function ApplyMovement()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = Stan.Speed
        hum.JumpPower = Stan.Jump
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    ApplyMovement()
end)

-- ============================================
-- CLICK TP
-- ============================================
Mouse.Button1Down:Connect(function()
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and Mouse.Hit then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)) end
    end
end)

-- ============================================
-- BRING FUNCTION
-- ============================================
local function BringPlayer(targetPlayer)
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then print("[ENI] Nie masz postaci") return end
    
    local theirChar = targetPlayer.Character
    local theirHRP = theirChar and theirChar:FindFirstChild("HumanoidRootPart")
    if not theirHRP then print("[ENI] Gracz nie ma postaci") return end
    
    theirHRP.CFrame = myHRP.CFrame + Vector3.new(0, 3, 0)
    print("[ENI] Bring:", targetPlayer.Name)
    
    -- Loop zeby serwer mniej latwo odrzucil
    task.spawn(function()
        for i = 1, 10 do
            task.wait(0.05)
            if theirHRP and theirHRP.Parent and myHRP and myHRP.Parent then
                theirHRP.CFrame = myHRP.CFrame + Vector3.new(math.random(-2,2), 3, math.random(-2,2))
            end
        end
    end)
end

-- ============================================
-- GUI ELEMENTY
-- ============================================
AddLabel("=== Movement ===")
AddInput("Speed", 16, function(v) Stan.Speed = v ApplyMovement() end)
AddInput("Jump", 50, function(v) Stan.Jump = v ApplyMovement() end)
AddInput("Fly Speed", 5, function(v) Stan.FlySpeed = v end)

AddLabel("=== Toggles ===")
AddToggle("Fly", false, function(s) if s then StartFly() else StopFly() end end)
AddToggle("Noclip", false, function(s) ToggleNoclip(s) end)
AddToggle("Godmode", false, function(s) ToggleGodmode(s) end)
AddToggle("ESP", false, function(s) Stan.ESP = s UpdateESP() end)

AddLabel("=== Players List ===")

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(1, 0, 0, 22)
RefreshBtn.Position = UDim2.new(0, 0, 0, yOffset)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
RefreshBtn.Text = "Odswiez liste"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 12
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.Parent = Content
yOffset = yOffset + 26

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, 0, 0, 120)
PlayerList.Position = UDim2.new(0, 0, 0, yOffset)
PlayerList.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 3
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerList.Parent = Content

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 2)
ListLayout.Parent = PlayerList

local function RefreshPlayers()
    for _, c in ipairs(PlayerList:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, -10, 0, 24)
            Row.Position = UDim2.new(0, 5, 0, 0)
            Row.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            Row.BorderSizePixel = 0
            Row.Parent = PlayerList
            
            -- Nick
            local NameLabel = Instance.new("TextLabel")
            NameLabel.Size = UDim2.new(0.45, 0, 1, 0)
            NameLabel.Position = UDim2.new(0, 5, 0, 0)
            NameLabel.BackgroundTransparency = 1
            NameLabel.Text = plr.Name
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 12
            NameLabel.Font = Enum.Font.SourceSans
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            NameLabel.Parent = Row
            
            -- GO button
            local GoBtn = Instance.new("TextButton")
            GoBtn.Size = UDim2.new(0.25, -4, 0.8, 0)
            GoBtn.Position = UDim2.new(0.48, 0, 0.1, 0)
            GoBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 80)
            GoBtn.Text = "GO"
            GoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            GoBtn.TextSize = 11
            GoBtn.Font = Enum.Font.SourceSansBold
            GoBtn.Parent = Row
            
            -- BRING button
            local BringBtn = Instance.new("TextButton")
            BringBtn.Size = UDim2.new(0.25, -4, 0.8, 0)
            BringBtn.Position = UDim2.new(0.75, 0, 0.1, 0)
            BringBtn.BackgroundColor3 = Color3.fromRGB(150, 80, 80)
            BringBtn.Text = "BRING"
            BringBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            BringBtn.TextSize = 11
            BringBtn.Font = Enum.Font.SourceSansBold
            BringBtn.Parent = Row
            
            -- GO click
            GoBtn.MouseButton1Click:Connect(function()
                local myChar = LocalPlayer.Character
                local theirChar = plr.Character
                if myChar and theirChar then
                    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                    local theirHRP = theirChar:FindFirstChild("HumanoidRootPart")
                    if myHRP and theirHRP then
                        myHRP.CFrame = theirHRP.CFrame + Vector3.new(0, 3, 0)
                    end
                end
            end)
            
            -- BRING click
            BringBtn.MouseButton1Click:Connect(function()
                BringPlayer(plr)
            end)
        end
    end
end

RefreshBtn.MouseButton1Click:Connect(RefreshPlayers)

yOffset = yOffset + 124

AddLabel("=== Keybinds ===")
AddLabel("F = Fly | N = Noclip")
AddLabel("G = Godmode | Shift+LMB = TP")

-- ============================================
-- GUI KONTROLS
-- ============================================
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Content.Visible = false
        MainFrame.Size = UDim2.new(0, 300, 0, 35)
        MinBtn.Text = "+"
    else
        Content.Visible = true
        MainFrame.Size = UDim2.new(0, 300, 0, 460)
        MinBtn.Text = "-"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    Stan.Fly = false
    Stan.Noclip = false
    Stan.Godmode = false
    StopFly()
    ToggleNoclip(false)
    ToggleGodmode(false)
    ScreenGui:Destroy()
end)

-- Hotkeys
UserInputService.InputBegan:Connect(function(input, g)
    if g then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    elseif input.KeyCode == Enum.KeyCode.F then
        if Stan.Fly then StopFly() else StartFly() end
    elseif input.KeyCode == Enum.KeyCode.N then
        ToggleNoclip(not Stan.Noclip)
    elseif input.KeyCode == Enum.KeyCode.G then
        ToggleGodmode(not Stan.Godmode)
    end
end)

-- ============================================
-- INIT
-- ============================================
ApplyMovement()
RefreshPlayers()
print("[ENI] Ultimate v3 loaded - RightShift to toggle")
print("[ENI] Lista graczy: GO = teleportuj sie do nich")
print("[ENI] Lista graczy: BRING = przywolaj ich do siebie")
print("[ENI] Dla LO, zawsze")