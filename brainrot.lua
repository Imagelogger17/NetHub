-- Minimal GUI for Steal a Brainrot (No Orion) - Delta Friendly

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "NetHubSimple"

-- Main Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 350)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Text = "🧠 Net Hub Simple"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22

-- Utility function to create buttons
local function createButton(text, posY, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 20
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Utility function to create sliders
local function createSlider(text, posY, min, max, default, callback)
    local label = Instance.new("TextLabel", Frame)
    label.Text = text..": "..default
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18

    local slider = Instance.new("TextBox", Frame)
    slider.Size = UDim2.new(1, -20, 0, 25)
    slider.Position = UDim2.new(0, 10, 0, posY + 25)
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

-- Variables
local AutoSteal = false
local KillAura = false

-- Auto Steal Toggle Button
local autoStealBtn = createButton("Toggle Auto Steal Brains: OFF", 50, function()
    AutoSteal = not AutoSteal
    autoStealBtn.Text = "Toggle Auto Steal Brains: "..(AutoSteal and "ON" or "OFF")
    if AutoSteal then
        spawn(function()
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
    end
end)

-- Kill Aura Toggle Button
local killAuraBtn = createButton("Toggle Kill Aura: OFF", 100, function()
    KillAura = not KillAura
    killAuraBtn.Text = "Toggle Kill Aura: "..(KillAura and "ON" or "OFF")
    if KillAura then
        spawn(function()
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
    end
end)

-- WalkSpeed Slider
createSlider("WalkSpeed", 150, 16, 100, 16, function(val)
    Humanoid.WalkSpeed = val
end)

-- JumpPower Slider
createSlider("JumpPower", 210, 50, 200, 50, function(val)
    Humanoid.JumpPower = val
end)

-- Infinite Jump
local infiniteJumpBtn = createButton("Enable Infinite Jump", 270, function()
    UserInputService.JumpRequest:Connect(function()
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end)
    infiniteJumpBtn.Text = "Infinite Jump Enabled"
    infiniteJumpBtn.Active = false
end)

-- Click TP Button
local clickTPBtn = createButton("Enable Click TP (Hold Ctrl + Click)", 310, function()
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            if Mouse.Target then
                Character:MoveTo(Mouse.Hit.Position)
            end
        end
    end)
    clickTPBtn.Text = "Click TP Enabled"
    clickTPBtn.Active = false
end)
