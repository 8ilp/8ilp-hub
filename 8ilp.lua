--[[
    8ilp HUB v7.0
    نفس هيكلة kaml
--]]

local Services = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    TweenService = game:GetService("TweenService"),
    HttpService = game:GetService("HttpService"),
    TeleportService = game:GetService("TeleportService"),
    CoreGui = game:GetService("CoreGui"),
    VirtualInputManager = game:GetService("VirtualInputManager")
}

local Player = Services.Players.LocalPlayer
local Mouse = Player:GetMouse()

-- GUI Builder
local function CreateGUI(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = Services.CoreGui
    ScreenGui.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 360)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -180)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.TextColor3 = Color3.fromRGB(255, 50, 50)
    Title.Text = title or "8ilp HUB"
    Title.Font = Enum.Font.SciFi
    Title.TextSize = 18
    Title.Parent = MainFrame
    
    return ScreenGui, MainFrame
end

local function CreateButton(parent, text, y, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 35)
    Button.Position = UDim2.new(0, 5, 0, y)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Font = Enum.Font.SciFi
    Button.TextSize = 14
    Button.BorderSizePixel = 0
    Button.Parent = parent
    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- ESP
local function ESP(target, color)
    local highlight = Instance.new("Highlight")
    highlight.Parent = target
    highlight.FillColor = color or Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    return highlight
end

local function PlayerESP()
    for _, plr in pairs(Services.Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            ESP(plr.Character, Color3.fromRGB(255, 0, 0))
        end
    end
    Services.Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function(char)
            wait(1)
            ESP(char, Color3.fromRGB(255, 0, 0))
        end)
    end)
end

-- Auto Farm
local function AutoFarm()
    task.spawn(function()
        while task.wait(0.1) do
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                for _, obj in pairs(Services.Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                        local hum = obj.Humanoid
                        local hrp = obj.HumanoidRootPart
                        if hum.Health > 0 and (hrp.Position - Player.Character.HumanoidRootPart.Position).Magnitude <= 200 then
                            Player.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 0, 2)
                            task.wait(0.3)
                        end
                    end
                end
            end
        end
    end)
end

-- Speed
local function SpeedHack(speed)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = speed
    end
end

-- Jump
local function JumpPower(power)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.JumpPower = power
    end
end

-- Fly
local function Fly(speed)
    speed = speed or 50
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = Player.Character.HumanoidRootPart
    local bg = Instance.new("BodyGyro")
    bg.P = 9e4
    bg.Parent = hrp
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = hrp
    local conn
    conn = Services.RunService.RenderStepped:Connect(function()
        if bg and bv and Player.Character then
            bg.CFrame = workspace.CurrentCamera.CFrame
            bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
        else
            conn:Disconnect()
            bg:Destroy()
            bv:Destroy()
        end
    end)
end

-- Noclip
local function Noclip(state)
    if not state then return end
    Services.RunService.Stepped:Connect(function()
        if Player.Character then
            for _, v in ipairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
end

-- Teleport
local function Teleport(pos)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = typeof(pos) == "Vector3" and CFrame.new(pos) or pos
    end
end

-- Infinite Jump
local function InfiniteJump(state)
    if state then
        Services.UserInputService.JumpRequest:Connect(function()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
end

-- Notification
local function Notify(text, dur)
    local gui = Instance.new("ScreenGui")
    gui.Parent = Services.CoreGui
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 40)
    frame.Position = UDim2.new(0.5, -150, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = text
    label.Font = Enum.Font.SciFi
    label.TextSize = 14
    label.Parent = frame
    task.delay(dur or 3, function() gui:Destroy() end)
end

-- ============================================
-- 🚀 BUILD HUB
-- ============================================
local gui, frame = CreateGUI("8ilp HUB")

local yPos = 40
local buttons = {
    {"ESP", function() PlayerESP() Notify("ESP Activated", 2) end},
    {"AUTO FARM", function() AutoFarm() Notify("Auto Farm Started", 2) end},
    {"SPEED [100]", function() SpeedHack(100) Notify("Speed 100", 2) end},
    {"JUMP [150]", function() JumpPower(150) Notify("Jump 150", 2) end},
    {"FLY", function() Fly(60) Notify("Fly Activated", 2) end},
    {"NOCLIP", function() Noclip(true) Notify("Noclip ON", 2) end},
    {"INF JUMP", function() InfiniteJump(true) Notify("Inf Jump ON", 2) end},
    {"RESET", function() SpeedHack(16) JumpPower(50) Notify("Reset", 2) end},
}

for _, btn in pairs(buttons) do
    CreateButton(frame, btn[1], yPos, btn[2])
    yPos = yPos + 40
end

Notify("8ilp HUB Loaded!", 3)
