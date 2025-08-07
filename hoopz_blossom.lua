local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Create GUI
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "BlossomHub"

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

-- Tabs
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

-- Main tab
local mainPage = Instance.new("Frame", contentFrame)
mainPage.Size = UDim2.new(1, 0, 1, 0)
mainPage.Visible = true
mainPage.BackgroundTransparency = 1
pages["Main"] = mainPage

-- Player tab
local playerPage = Instance.new("Frame", contentFrame)
playerPage.Size = UDim2.new(1, 0, 1, 0)
playerPage.Visible = false
playerPage.BackgroundTransparency = 1
pages["Player"] = playerPage

-- Aim tab
local aimPage = Instance.new("Frame", contentFrame)
aimPage.Size = UDim2.new(1, 0, 1, 0)
aimPage.Visible = false
aimPage.BackgroundTransparency = 1
pages["Aim"] = aimPage

-- Tab buttons
local tabButtons = {
    ["Main"] = createTab("Main", 0),
    ["Player"] = createTab("Player", 45),
    ["Aim"] = createTab("Silent Aim", 90),
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
autoShootToggle.TextColor3 = Color3.new(1,1,1)

local autoShoot = false
autoShootToggle.MouseButton1Click:Connect(function()
    autoShoot = not autoShoot
    autoShootToggle.Text = "Auto Shoot: " .. (autoShoot and "ON" or "OFF")
end)

-- Auto Shoot logic placeholder
RunService.Heartbeat:Connect(function()
    if autoShoot then
        -- insert auto shoot logic here
        -- e.g. fire a remote event or manipulate hoopz shooting function
    end
end)

-- Walkspeed Slider
local speedBox = Instance.new("TextBox", playerPage)
speedBox.Size = UDim2.new(0, 100, 0, 30)
speedBox.Position = UDim2.new(0, 20, 0, 20)
speedBox.Text = "16"
speedBox.ClearTextOnFocus = false
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

speedBox.FocusLost:Connect(function()
    local speed = tonumber(speedBox.Text)
    if speed and speed >= 16 and speed <= 100 then
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
silentAimToggle.TextColor3 = Color3.new(1,1,1)

local silentAim = false
silentAimToggle.MouseButton1Click:Connect(function()
    silentAim = not silentAim
    silentAimToggle.Text = "Silent Aim: " .. (silentAim and "ON" or "OFF")
end)

-- Silent Aim logic placeholder
-- You’ll need to hook into Hoopz shooting remotes to redirect shots
-- Add that here when ready
