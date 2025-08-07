local OrionLib = OrionLib
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()

local Window = OrionLib:MakeWindow({
    Name = "🧠 Net | Steal a Brainrot Hub",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "BrainrotNet"
})

-- MAIN TAB
local Main = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Main:AddToggle({
    Name = "Auto Steal Brains (TP to Base)",
    Default = false,
    Callback = function(state)
        getgenv().AutoSteal = state
        while getgenv().AutoSteal do
            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("StealBrain"):FireServer(v)
                        task.wait(0.2)
                        local base = workspace:FindFirstChild(Player.Name.."'s Base") or workspace:FindFirstChild(Player.Name.."_Base")
                        if base and base:FindFirstChild("Spawn") then
                            Character:MoveTo(base.Spawn.Position + Vector3.new(0, 3, 0))
                        else
                            warn("Base not found or missing spawn part.")
                        end
                    end)
                end
                task.wait(1)
            end
        end
    end
})

Main:AddToggle({
    Name = "Kill Aura",
    Default = false,
    Callback = function(state)
        getgenv().KillAura = state
        while getgenv().KillAura do
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (v.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                    if dist < 10 then
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Attack"):FireServer(v)
                    end
                end
            end
            task.wait(0.5)
        end
    end
})

-- PLAYER TAB
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Increment = 1,
    Callback = function(val)
        Humanoid.WalkSpeed = val
    end
})

PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 200,
    Default = 50,
    Increment = 1,
    Callback = function(val)
        Humanoid.JumpPower = val
    end
})

PlayerTab:AddButton({
    Name = "Click TP (Ctrl + Click)",
    Callback = function()
        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
                if Mouse.Target then
                    Character:MoveTo(Mouse.Hit.Position)
                end
            end
        end)
    end
})

PlayerTab:AddButton({
    Name = "Infinite Jump",
    Callback = function()
        game:GetService("UserInputService").JumpRequest:Connect(function()
            Humanoid:ChangeState("Jumping")
        end)
    end
})

-- MISC TAB
local Misc = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Misc:AddButton({
    Name = "Anti-AFK",
    Callback = function()
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
})

OrionLib:Init()
