--[[
    8ilp HUB
    loadstring(game:HttpGet("https://raw.githubusercontent.com/8ilp/8ilp-hub/main/8ilp.lua"))()
--]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "8ilp HUB",
    SubTitle = "by 8ilp",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Teleports = Window:AddTab({ Title = "Teleports", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "8ilp HUB",
        Content = "Loaded Successfully",
        Duration = 5
    })
end

-- Main Tab
Tabs.Main:AddParagraph({ Title = "8ilp Main Features", Content = "Main scripts and features" })

Tabs.Main:AddButton({
    Title = "Infinite Yield",
    Description = "Admin commands script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

Tabs.Main:AddButton({
    Title = "CMD-X",
    Description = "Advanced admin commands",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source"))()
    end
})

Tabs.Main:AddButton({
    Title = "Dark Dex",
    Description = "Game explorer",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end
})

Tabs.Main:AddButton({
    Title = "Remote Spy",
    Description = "View remote events",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpy.lua"))()
    end
})

-- Visuals Tab
Tabs.Visuals:AddParagraph({ Title = "ESP Settings", Content = "Player ESP and visuals" })

local ESPToggle = Tabs.Visuals:AddToggle("MyToggle", { Title = "Player ESP", Default = false })
ESPToggle:OnChanged(function(state)
    if state then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character then
                local h = Instance.new("Highlight")
                h.Parent = plr.Character
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.FillTransparency = 0.5
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.Name = "8ilp_ESP"
            end
        end
        game.Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function(char)
                wait(1)
                local h = Instance.new("Highlight")
                h.Parent = char
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.FillTransparency = 0.5
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.Name = "8ilp_ESP"
            end)
        end)
    else
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character then
                local esp = plr.Character:FindFirstChild("8ilp_ESP")
                if esp then esp:Destroy() end
            end
        end
    end
end)

Tabs.Visuals:AddToggle("MyToggle2", { Title = "Box ESP", Default = false }):OnChanged(function(state)
    -- Box ESP placeholder
end)

Tabs.Visuals:AddToggle("MyToggle3", { Title = "Tracers", Default = false }):OnChanged(function(state)
    -- Tracers placeholder
end)

Tabs.Visuals:AddToggle("MyToggle4", { Title = "Chams", Default = false }):OnChanged(function(state)
    -- Chams placeholder
end)

-- Player Tab
Tabs.Player:AddParagraph({ Title = "Movement", Content = "Character modifications" })

local SpeedSlider = Tabs.Player:AddSlider("SpeedSlider", {
    Title = "Walk Speed",
    Description = "Change your speed",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 0,
    Callback = function(value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

local JumpSlider = Tabs.Player:AddSlider("JumpSlider", {
    Title = "Jump Power",
    Description = "Change your jump",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end
})

Tabs.Player:AddToggle("FlyToggle", { Title = "Fly", Default = false }):OnChanged(function(state)
    if state then
        local player = game.Players.LocalPlayer
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bg = Instance.new("BodyGyro")
            bg.P = 9e4
            bg.Parent = hrp
            bg.Name = "8ilp_Fly"
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = hrp
            bv.Name = "8ilp_Fly"
            game:GetService("RunService").RenderStepped:Connect(function()
                if bg and bv and player.Character then
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
                end
            end)
        end
    else
        local player = game.Players.LocalPlayer
        if player.Character then
            local bg = player.Character:FindFirstChild("8ilp_Fly", true)
            local bv = player.Character:FindFirstChild("8ilp_Fly", true)
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end
    end
end)

Tabs.Player:AddToggle("NoclipToggle", { Title = "Noclip", Default = false }):OnChanged(function(state)
    if state then
        game:GetService("RunService").Stepped:Connect(function()
            if game.Players.LocalPlayer.Character then
                for _, v in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end)

Tabs.Player:AddToggle("InfJumpToggle", { Title = "Infinite Jump", Default = false }):OnChanged(function(state)
    if state then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
end)

-- Teleports Tab
Tabs.Teleports:AddParagraph({ Title = "Teleport Locations", Content = "Click to teleport" })

local function teleport(pos)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

Tabs.Teleports:AddButton({
    Title = "Spawn",
    Description = "Teleport to spawn",
    Callback = function()
        local spawn = workspace:FindFirstChild("SpawnLocation")
        if spawn then
            teleport(spawn.Position)
        end
    end
})

Tabs.Teleports:AddButton({
    Title = "Waypoint",
    Description = "Teleport to waypoint",
    Callback = function()
        -- Waypoint placeholder
    end
})

-- Settings Tab
Tabs.Settings:AddParagraph({ Title = "UI Settings", Content = "Customize your experience" })

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("8ilp_HUB")
SaveManager:SetFolder("8ilp_HUB/config")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "8ilp HUB",
    Content = "Ready to use!",
    Duration = 5
})
