-- Hoopz GUI - Delta Compatible by Imagelogger17

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hum = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NetHoopzGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BorderSizePixel = 0

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 8)

local tabs = {
    "Main",
    "Visual",
    "Player"
}

local tabButtons = {}
local pages = {}

for i, tabName in ipairs(tabs) do
    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0, 100, 0, 30)
    button.Position = UDim2.new(0, (i - 1) * 105 + 5, 0, 5)
    button.Text = tabName
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.new(1, 1, 1)

    local page = Instance.new("Frame", frame)
    page.Size = UDim2.new(1, -10, 1, -45)
    page.Position = UDim2.new(0, 5, 0, 40)
    page.Visible = i == 1
    page.BackgroundTransparency = 1

    button.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)

    tabButtons[tabName] = button
    pages[tabName] = page
end

--- Features ---

-- Auto Shoot Toggle
local autoShoot = false
local shootButton = Instance.new("TextButton", pages["Main"])
shootButton.Size = UDim2.new(0, 200, 0, 40)
shootButton.Position = UDim2.new(0, 10, 0, 10)
shootButton.Text = "Auto Shoot [OFF]"
shootButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
shootButton.TextColor3 = Color3.new(1, 1, 1)

shootButton.MouseButton1Click:Connect(function()
    autoShoot = not autoShoot
    shootButton.Text = "Auto Shoot [" .. (autoShoot and "ON" or "OFF") .. "]"
end)

-- Aura Highlight + Auto Shoot Logic
local aura = Instance.new("SelectionBox", root)
aura.Adornee = root
aura.LineThickness = 0.05
aura.Color3 = Color3.new(0, 1, 0)
aura.Visible = false

RunService.RenderStepped:Connect(function()
    character = player.Character or player.CharacterAdded:Wait()
    root = character:FindFirstChild("HumanoidRootPart")
    aura.Adornee = root

    -- Sample condition to show aura
    local canShoot = root.Velocity.Magnitude < 5
    aura.Visible = canShoot

    if autoShoot and canShoot then
        local shootingRemote = ReplicatedStorage:FindFirstChild("ShootingEvent")
        if shootingRemote then
            shootingRemote:FireServer()
        end
        hum.Jump = true
        wait(1) -- delay to prevent spam
    end
end)

-- Speed Toggle
local speed = false
local speedButton = Instance.new("TextButton", pages["Player"])
speedButton.Size = UDim2.new(0, 200, 0, 40)
speedButton.Position = UDim2.new(0, 10, 0, 10)
speedButton.Text = "Speed [OFF]"
speedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedButton.TextColor3 = Color3.new(1, 1, 1)

speedButton.MouseButton1Click:Connect(function()
    speed = not speed
    speedButton.Text = "Speed [" .. (speed and "ON" or "OFF") .. "]"
end)

RunService.Stepped:Connect(function()
    if speed and hum then
        hum.WalkSpeed = 30
    else
        hum.WalkSpeed = 16
    end
end)

-- Basic Silent Aim (you can expand this later)

--- Done ---
print("Hoopz GUI Loaded - Blossom Style [Delta Compatible]")
