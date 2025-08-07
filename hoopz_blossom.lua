local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Set the shooting remote event name here
local shootRemote = ReplicatedStorage:WaitForChild("ShootingEvent")

-- Create GUI properly
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlossomHub"
screenGui.Parent = playerGui
print("BlossomHub GUI created")

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 450, 0, 500)
mainFrame.Position = UDim2.new(0, 100, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Active = true
mainFrame.Draggable = true

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "🌸 Blossom Hub - Hoopz"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Font = Enum.Font.GothamBold
title.TextSize = 24

-- Tabs frame
local tabsFrame = Instance.new("Frame", mainFrame)
tabsFrame.Size = UDim2.new(0, 100, 1, -50)
tabsFrame.Position = UDim2.new(0, 0, 0, 50)
tabsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -100, 1, -50)
contentFrame.Position = UDim2.new(0, 100, 0, 50)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local function createTab(name, posY)
    local btn = Instance.new("TextButton", tabsFrame)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    return btn
end

local pages = {}

-- Create tabs and pages
local mainPage = Instance.new("Frame", contentFrame)
mainPage.Size = UDim2.new(1, 0, 1, 0)
mainPage.Visible = true
mainPage.BackgroundTransparency = 1
pages["Main"] = mainPage

local playerPage = Instance.new("Frame", contentFrame)
playerPage.Size = UDim2.new(1, 0, 1, 0)
playerPage.Visible = false
playerPage.BackgroundTransparency = 1
pages["Player"] = playerPage

local aimPage = Instance.new("Frame", contentFrame)
aimPage.Size = UDim2.new(1, 0, 1, 0)
aimPage.Visible = false
aimPage.BackgroundTransparency = 1
pages["Silent Aim"] = aimPage

-- Create tab buttons
local tabButtons = {
    ["Main"] = createTab("Main", 0),
    ["Player"] = createTab("Player", 45),
    ["Silent Aim"] = createTab("Silent Aim", 90),
}

for tab, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        for pageName, page in pairs(pages) do
            page.Visible = (pageName == tab)
        end
    end)
end

-- Auto Shoot toggle
local autoShootToggle = Instance.new("TextButton", mainPage)
autoShootToggle.Size = UDim2.new(0, 200, 0, 40)
autoShootToggle.Position = UDim2.new(0, 20, 0, 20)
autoShootToggle.Text = "Auto Shoot: OFF"
autoShootToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
autoShootToggle.TextColor3 = Color3.new(1, 1, 1)

local autoShoot = false
autoShootToggle.MouseButton1Click:Connect(function()
    autoShoot = not autoShoot
    autoShootToggle.Text = "Auto Shoot: " .. (autoShoot and "ON" or "OFF")
end)

-- Walkspeed slider
local speedLabel = Instance.new("TextLabel", playerPage)
speedLabel.Text = "WalkSpeed: 16"
speedLabel.Position = UDim2.new(0, 20, 0, 20)
speedLabel.Size = UDim2.new(0, 150, 0, 30)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)

local speedBox = Instance.new("TextBox", playerPage)
speedBox.Size = UDim2.new(0, 100, 0, 30)
speedBox.Position = UDim2.new(0, 20, 0, 60)
speedBox.Text = "16"
speedBox.ClearTextOnFocus = false
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBox.TextColor3 = Color3.new(1, 1, 1)

speedBox.FocusLost:Connect(function()
    local speed = tonumber(speedBox.Text)
    if speed and speed >= 16 and speed <= 100 then
        speedLabel.Text = "WalkSpeed: " .. speed
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    else
        speedBox.Text = "16"
    end
end)

-- Silent Aim toggle
local silentAimToggle = Instance.new("TextButton", aimPage)
silentAimToggle.Size = UDim2.new(0, 200, 0, 40)
silentAimToggle.Position = UDim2.new(0, 20, 0, 20)
silentAimToggle.Text = "Silent Aim: OFF"
silentAimToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
silentAimToggle.TextColor3 = Color3.new(1, 1, 1)

local silentAim = false
silentAimToggle.MouseButton1Click:Connect(function()
    silentAim = not silentAim
    silentAimToggle.Text = "Silent Aim: " .. (silentAim and "ON" or "OFF")
end)

-- Body Aura toggle (green)
local auraToggle = Instance.new("TextButton", mainPage)
auraToggle.Size = UDim2.new(0, 200, 0, 40)
auraToggle.Position = UDim2.new(0, 20, 0, 80)
auraToggle.Text = "Auto Aura Shoot: OFF"
auraToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
auraToggle.TextColor3 = Color3.new(1, 1, 1)

local autoAura = false
auraToggle.MouseButton1Click:Connect(function()
    autoAura = not autoAura
    auraToggle.Text = "Auto Aura Shoot: " .. (autoAura and "ON" or "OFF")
end)

-- Helper: Create green aura effect
local function createAura(character)
    if character:FindFirstChild("Aura") then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "Aura"
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
    highlight.Adornee = character
    highlight.Parent = character
end

local function removeAura(character)
    local aura = character:FindFirstChild("Aura")
    if aura then
        aura:Destroy()
    end
end

-- Function to check if player can shoot (placeholder)
local function canShoot()
    -- Replace with actual Hoopz shooting cooldown or condition
    return true -- for demo, always true
end

-- Auto Aura + Jump + Auto Shoot loop
RunService.Heartbeat:Connect(function()
    if autoAura then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if canShoot() then
                createAura(LocalPlayer.Character)
                if LocalPlayer.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
                    LocalPlayer.Character.Humanoid.Jump = true
                end
                if autoShoot then
                    shootRemote:FireServer()
                end
            else
                removeAura(LocalPlayer.Character)
            end
        end
    else
        if LocalPlayer.Character then
            removeAura(LocalPlayer.Character)
        end
    end
end)
