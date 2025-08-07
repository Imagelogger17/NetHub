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

-- Create tab buttons and pages
local tabButtons = {}
local pages = {}

for i, tabName in ipairs(tabs) do
    local btn = createTabButton(tabName, (i-1)*45)
    tabButtons[tabName] = btn
    
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = (i == 1) -- Show first tab by default
    page.Parent = contentFrame
    pages[tabName] = page
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)
end

-- ==== Main Tab ====
local mainPage = pages["Main"]

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

coroutine.wrap(function()
    while true do
        RunService.Heartbeat:Wait()
        if autoShotEnabled then
            -- TODO: Add Hoopz auto shot logic here
            -- Example:
            -- print("Auto Shot active")
        end
    end
end)()

-- ==== Player Tab ====
local playerPage = pages["Player"]

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

-- ==== ESP Tab ====
local espPage = pages["ESP"]

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
    local head = player.Character and player.Character:FindFirstChild("Head")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Name = "ESPBillboard"
    billboard.Parent = head

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
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Head") then
                if not espLabels[plr] then
                    espLabels[plr] = createEspLabel(plr)
                end
            end
        end

        Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function(char)
                if espEnabled then
                    wait(1)
                    if char:FindFirstChild("Head") then
                        espLabels[plr] = createEspLabel(plr)
                    end
                end
            end)
        end)

        for _, plr in pairs(Players:GetPlayers()) do
            plr.CharacterAdded:Connect(function(char)
                if espEnabled then
                    wait(1)
                    if char:FindFirstChild("Head") then
                        espLabels[plr] = createEspLabel(plr)
                    end
                end
            end)
        end

    else
        for plr, label in pairs(espLabels) do
            if label and label.Parent then
                label:Destroy()
            end
            espLabels[plr] = nil
        end
    end
end)
