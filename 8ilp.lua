--[[
    8ilp HUB
    طبق الأصل من kaml
--]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "8ilp " .. Fluent.Version,
    SubTitle = "by 8ilp",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "8ilp",
        Content = "Loaded Successfully",
        Duration = 5
    })
end

-- Main Tab
Tabs.Main:AddParagraph({ Title = "8ilp Main", Content = "Main scripts" })

Tabs.Main:AddButton({
    Title = "Infinite Yield",
    Description = "Admin commands",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

Tabs.Main:AddButton({
    Title = "CMD-X",
    Description = "Advanced commands",
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
    Description = "View remotes",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpy.lua"))()
    end
})

-- Player Tab
Tabs.Player:AddParagraph({ Title = "Movement", Content = "Character mods" })

Tabs.Player:AddSlider("Speed", {
    Title = "Walk Speed",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})

Tabs.Player:AddSlider("Jump", {
    Title = "Jump Power",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
        end
    end
})

Tabs.Player:AddToggle("Fly", { Title = "Fly", Default = false }):OnChanged(function(s)
    if s then
        local p = game.Players.LocalPlayer
        local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bg = Instance.new("BodyGyro")
            bg.P = 9e4
            bg.Parent = hrp
            bg.Name = "8ilp"
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = hrp
            bv.Name = "8ilp"
            game:GetService("RunService").RenderStepped:Connect(function()
                if bg and bv and p.Character then
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
                end
            end)
        end
    else
        local p = game.Players.LocalPlayer
        if p.Character then
            for _, v in ipairs(p.Character:GetDescendants()) do
                if v.Name == "8ilp" and (v:IsA("BodyGyro") or v:IsA("BodyVelocity")) then
                    v:Destroy()
                end
            end
        end
    end
end)

Tabs.Player:AddToggle("Noclip", { Title = "Noclip", Default = false }):OnChanged(function(s)
    if s then
        game:GetService("RunService").Stepped:Connect(function()
            local p = game.Players.LocalPlayer
            if p.Character then
                for _, v in ipairs(p.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end)

Tabs.Player:AddToggle("InfJump", { Title = "Infinite Jump", Default = false }):OnChanged(function(s)
    if s then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            local p = game.Players.LocalPlayer
            if p.Character and p.Character:FindFirstChild("Humanoid") then
                p.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
end)

-- Visuals Tab
Tabs.Visuals:AddParagraph({ Title = "ESP", Content = "Player visuals" })

Tabs.Visuals:AddToggle("ESP", { Title = "Player ESP", Default = false }):OnChanged(function(s)
    if s then
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
            plr.CharacterAdded:Connect(function(c)
                task.wait(1)
                local h = Instance.new("Highlight")
                h.Parent = c
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

-- Settings Tab
Tabs.Settings:AddParagraph({ Title = "Config", Content = "Save and load" })

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("8ilp")
SaveManager:SetFolder("8ilp/configs")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "8ilp",
    Content = "Ready!",
    Duration = 5
})
