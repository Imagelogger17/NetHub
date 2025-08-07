-- Net Hub | Steal a Brainrot - Stable Version (GUI never destroyed)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()

-- Prevent multiple GUIs
if Player.PlayerGui:FindFirstChild("NetHubGui") then
    warn("NetHubGui already exists! Preventing duplicate.")
    return
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NetHubGui"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Main Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 320, 0, 550)
Frame.Position = UDim2.new(0, 10, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Text = "🧠 Net Hub | Brainrot"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22

-- Helper to create buttons with icons
local function createButton(text, yPos, iconId, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0, 300, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 20
    btn.Text = "  "..text

    if iconId then
        local icon = Instance.new("ImageLabel", btn)
        icon.Size = UDim2.new(0, 30, 0, 30)
        icon.Position = UDim2.new(0, 5, 0.5, -15)
        icon.BackgroundTransparency = 1
        icon.Image = iconId
    end

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Helper to create sliders
local function createSlider(text, yPos, min, max, default, callback)
    local label = Instance.new("TextLabel", Frame)
    label.Text = text..": "..default
    label.Size = UDim2.new(0, 300, 0, 25)
    label.Position = UDim2.new(0, 10, 0, yPos)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18

    local slider = Instance.new("TextBox", Frame)
    slider.Size = UDim2.new(0, 300, 0, 25)
    slider.Position = UDim2.new(0, 10, 0, yPos+25)
    slider.Text = tostring(default)
    slider.ClearTextOnFocus = false
    slider.TextColor3 = Color3.new(0,0,0)
    slider.Font = Enum.Font.SourceSans
    slider.TextSize = 18

    slider.FocusLost:Connect(function()
        local val = tonumber(slider.Text)
        if val and val >= min and val <= max then
            label.Text = text..": "..val
            callback(val)
        else
            slider.Text = tostring(default)
        end
    end)

    return slider
end

-- Variables to track toggles
local AutoSteal = false
local KillAura = false
local ESPEnabled = false
local ESPBoxes = {}

-- Auto Steal loop thread
local autoStealThread
local function startAutoSteal()
    autoStealThread = coroutine.create(function()
        while AutoSteal do
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        ReplicatedStorage.Events.StealBrain:FireServer(v)
                        wait(0.3)
                        local base = workspace:FindFirstChild(Player.Name.."'s Base") or workspace:FindFirstChild(Player.Name.."_Base")
                        if base and base:FindFirstChild("Spawn") then
                            Character:MoveTo(base.Spawn.Position + Vector3.new(0, 3, 0))
                        end
                    end)
                end
            end
            wait(1)
        end
    end)
    coroutine.resume(autoStealThread)
end

-- Kill Aura loop thread
local killAuraThread
local function startKillAura()
    killAuraThread = coroutine.create(function()
        while KillAura do
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (v.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                    if dist < 10 then
                        pcall(function()
                            ReplicatedStorage.Events.Attack:FireServer(v)
                        end)
                    end
                end
            end
            wait(0.5)
        end
    end)
    coroutine.resume(killAuraThread)
end

-- Auto Steal Button
local autoStealBtn = createButton("Toggle Auto Steal Brains", 50, "rbxassetid://6031094671", function()
    AutoSteal = not AutoSteal
    autoStealBtn.Text = (AutoSteal and "✅ " or "❌ ").."Auto Steal Brains"
    if AutoSteal then
        startAutoSteal()
    end
end)

-- Kill Aura Button
local killAuraBtn = createButton("Toggle Kill Aura", 100, "rbxassetid://6031294684", function()
    KillAura = not KillAura
    killAuraBtn.Text = (KillAura and "✅ " or "❌ ").."Kill Aura"
    if KillAura then
        startKillAura()
    end
end)

-- ESP Button and logic
local espBtn = createButton("Toggle ESP", 150, "rbxassetid://6031286733", function()
    ESPEnabled = not ESPEnabled
    espBtn.Text = (ESPEnabled and "✅ " or "❌ ").."ESP"

    if not ESPEnabled then
        for _, box in pairs(ESPBoxes) do
            if box and box.Visible ~= nil then
                box.Visible = false
                box:Remove()
            end
        end
        ESPBoxes = {}
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                local ch = plr.Character
                if ch and ch:FindFirstChild("HumanoidRootPart") then
                    if Drawing and Drawing.new then
                        local box = Drawing.new("Square")
                        box.Visible = true
                        box.Color = Color3.new(1, 0, 0)
                        box.Thickness = 2
                        ESPBoxes[plr.Name] = box
                    end
                end
            end
        end
    end
end)

-- Teleport to Player Label
local tpLabel = Instance.new("TextLabel", Frame)
tpLabel.Text = "Teleport to Player (click name):"
tpLabel.Size = UDim2.new(0, 300, 0, 25)
tpLabel.Position = UDim2.new(0, 10, 0, 200)
tpLabel.BackgroundTransparency = 1
tpLabel.TextColor3 = Color3.new(1,1,1)
tpLabel.Font = Enum.Font.SourceSans
tpLabel.TextSize = 18

-- Teleport List Frame
local tpList = Instance.new("ScrollingFrame", Frame)
tpList.Size = UDim2.new(0, 300, 0, 150)
tpList.Position = UDim2.new(0, 10, 0, 225)
tpList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tpList.BorderSizePixel = 0
tpList.CanvasSize = UDim2.new(0, 0, 0, 0)
tpList.ScrollBarThickness = 6

local UIListLayout = Instance.new("UIListLayout", tpList)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

local function refreshPlayerList()
    tpList.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 30)
    for _, child in pairs(tpList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local btn = Instance.new("TextButton", tpList)
            btn.Size = UDim2.new(1, 0, 0, 25)
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 18
            btn.Text = plr.Name

            btn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0,3,0))
                end
            end)
        end
    end
end

refreshPlayerList()

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- WalkSpeed Slider
createSlider("WalkSpeed", 390, 16, 100, 16, function(val)
    Humanoid.WalkSpeed = val
end)

-- JumpPower Slider
createSlider("JumpPower", 440, 50, 200, 50, function(val)
    Humanoid.JumpPower = val
end)

-- Infinite Jump Button
local infiniteJumpBtn = createButton("Enable Infinite Jump", 490, "rbxassetid://6031201750", function()
    UserInputService.JumpRequest:Connect(function()
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end)
    infiniteJumpBtn.Text = "✅ Infinite Jump Enabled"
    infiniteJumpBtn.Active = false
end)

-- Click TP Button
local clickTPBtn = createButton("Enable Click TP (Ctrl + Click)", 540, "rbxassetid://6031268835", function()
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            if Mouse.Target then
                Character:MoveTo(Mouse.Hit.Position)
            end
        end
    end)
    clickTPBtn.Text = "✅ Click TP Enabled"
    clickTPBtn.Active = false
end)

-- ESP Update Loop
if Drawing and Drawing.new then
    RunService.RenderStepped:Connect(function()
        if ESPEnabled then
            for plrName, box in pairs(ESPBoxes) do
                local plr = Players:FindFirstChild(plrName)
                if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                    if onScreen then
                        box.Position = Vector2.new(pos.X - box.Size / 2, pos.Y - box.Size / 2)
                        box.Size = Vector2.new(30, 40)
                        box.Visible = true
                    else
                        box.Visible = false
                    end
                else
                    if box then
                        box.Visible = false
                    end
                end
            end
        end
    end)
else
    print("Drawing API not available. ESP will not work.")
end
