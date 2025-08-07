local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HoopzBlossomHub"
screenGui.Parent = Player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0, 100, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- Title
local title = Instance.new("TextLabel")
title.Text = "Blossom Hub | Hoopz"
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = mainFrame

-- Tabs Frame
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(0, 100, 1, -50)
tabsFrame.Position = UDim2.new(0, 0, 0, 50)
tabsFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
tabsFrame.Parent = mainFrame

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -100, 1, -50)
contentFrame.Position = UDim2.new(0, 100, 0, 50)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentFrame.Parent = mainFrame

-- Utility function to create buttons
local function createTabButton(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Parent = tabsFrame
    return btn
end

-- Tabs
local tabs = {"Main", "Player", "ESP"}

-- Create tab buttons
local tabButtons = {}
for i, tabName in ipairs(tabs) do
    local btn = createTabButton(tabName, (i-1)*45)
    tabButtons[tabName] = btn
end

-- Content for each tab
local pages = {}

-- === Main Tab ===
local mainPage = Instance.new("Frame")
mainPage.Size = UDim2.new(1, 0, 1, 0)
mainPage.BackgroundTransparency = 1
mainPage.Parent = contentFrame
pages["Main"] = mainPage

local autoShotToggle = Instance.new("TextButton")
autoShotToggle.Size = UDim2.new(0, 200, 0, 40)
autoShotToggle.Position = UDim2.new(0, 20, 0, 20)
autoShotToggle.Text = "Auto Shot: OFF"
autoShotToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
autoShotToggle.TextColor3 = Color3.new(1,1,1)
autoShotToggle.Parent = mainPage

local autoShotEnabled = false
autoShotToggle.MouseButton1Click:Connect(function()
    autoShotEnabled = not autoShotEnabled
    autoShotToggle.Text = "Auto Shot: "..(autoShotEnabled and "ON" or "OFF")
end)

-- Placeholder: Auto Shot logic
spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        if autoShotEnabled then
            -- Add your hoopz auto shot code here
            -- Example: print("Auto shot triggered")
        end
    end
end)

-- === Player Tab ===
local playerPage = Instance.new("Frame")
playerPage.Size = UDim2.new(1, 0, 1, 0)
playerPage.BackgroundTransparency = 1
playerPage.Parent = contentFrame
playerPage.Visible = false
pages["Player"] = playerPage

local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "WalkSpeed: 16"
speedLabel.Position = UDim2.new(0, 20, 0, 20)
speedLabel.Size = UDim2.new(0, 150, 0, 30)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Parent = playerPage

local speedSlider = Instance.new("TextBox")
speedSlider.Text = "16"
speedSlider.Position = UDim2.new(0, 20, 0, 60)
speedSlider.Size = UDim2.new(0, 100, 0, 30)
speedSlider.ClearTextOnFocus = false
speedSlider.Parent = playerPage

speedSlider.FocusLost:Connect(function()
    local val = tonumber(speedSlider.Text)
    if val and val >= 16 and val <= 100 then
        speedLabel.Text = "WalkSpeed: "..val
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = val
        end
    else
        speedSlider.Text = "16"
    end
end)

-- === ESP Tab ===
local espPage = Instance.new("Frame")
espPage.Size = UDim2.new(1, 0, 1, 0)
espPage.BackgroundTransparency = 1
espPage.Parent = contentFrame
espPage.Visible = false
pages["ESP"] = espPage

local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0, 200, 0, 40)
espToggle.Position = UDim2.new(0, 20, 0, 20)
espToggle.Text = "ESP: OFF"
espToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
espToggle.TextColor3 = Color3.new(1,1,1)
espToggle.Parent = espPage

local espEnabled = false
local espLabels = {}

local function createEspLabel(player)
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = player.Character and player.Character:FindFirstChild("Head")
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = player.Character and player.Character:FindFirstChild("Head")

    local label = Instance.new("TextLabel")
    label.Text = player.Name
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextStrokeColor3 = Color3.new(0,0,0)
    label.TextStrokeTransparency = 0
    label.Parent = billboard

    return billboard
end

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = "ESP: "..(espEnabled and "ON" or "OFF")

    if espEnabled then
        -- Create ESP for all players except local
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Head") then
                espLabels[plr
