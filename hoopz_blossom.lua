local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local currentTarget = nil
local highlight = nil

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                closestPlayer = player
            end
        end
    end

    return closestPlayer
end

local function createHighlight(targetPlayer)
    if highlight then
        highlight:Destroy()
        highlight = nil
    end

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        highlight = Instance.new("BoxHandleAdornment")
        highlight.Adornee = targetPlayer.Character.Head
        highlight.AlwaysOnTop = true
        highlight.ZIndex = 10
        highlight.Size = Vector3.new(2, 2, 2)
        highlight.Color3 = Color3.new(1, 0, 0)
        highlight.Transparency = 0.5
        highlight.Parent = targetPlayer.Character.Head
    end
end

RunService.RenderStepped:Connect(function()
    local target = getClosestPlayer()
    if target ~= currentTarget then
        currentTarget = target
        createHighlight(currentTarget)
    end
end)
