--[[
    8ilp EXECUTOR v6.0
    Architect Engine 2099 | WORKING
--]]

local function loadCode()
    -- ============================================
    -- 🔐 CRYPTO
    -- ============================================
    local function xor_encrypt(data, key)
        local r = ""
        for i = 1, #data do
            local d = string.byte(data, i)
            local k = string.byte(key, ((i-1) % #key) + 1)
            r = r .. string.char(bit32.bxor(d, k))
        end
        return r
    end

    local function b64_encode(data)
        local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
        local result = {}
        for i = 1, #data, 3 do
            local a, b, c = string.byte(data, i, i+2)
            b, c = b or 0, c or 0
            local n = a * 65536 + b * 256 + c
            table.insert(result, string.sub(chars, math.floor(n/262144)%64+1, math.floor(n/262144)%64+1))
            table.insert(result, string.sub(chars, math.floor(n/4096)%64+1, math.floor(n/4096)%64+1))
            table.insert(result, string.sub(chars, math.floor(n/64)%64+1, math.floor(n/64)%64+1))
            table.insert(result, string.sub(chars, n%64+1, n%64+1))
        end
        if #data % 3 == 1 then result[#result-1], result[#result] = "=", "="
        elseif #data % 3 == 2 then result[#result] = "=" end
        return table.concat(result)
    end

    local function b64_decode(data)
        local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
        data = string.gsub(data, '[^'..chars..'=]', '')
        local result = {}
        for i = 1, #data, 4 do
            local a, b, c, d = string.byte(data, i, i+3)
            a = (string.find(chars, string.char(a))-1) or 0
            b = (string.find(chars, string.char(b))-1) or 0
            c = (string.find(chars, string.char(c))-1) or 0
            d = (string.find(chars, string.char(d))-1) or 0
            local n = a * 262144 + b * 4096 + c * 64 + d
            table.insert(result, string.char(math.floor(n/65536)))
            if c ~= 0 then table.insert(result, string.char(math.floor((n%65536)/256))) end
            if d ~= 0 then table.insert(result, string.char(n%256)) end
        end
        return table.concat(result)
    end

    -- ============================================
    -- 🧩 FRAMEWORK
    -- ============================================
    local Services = setmetatable({}, {__index = function(t, k)
        local s = game:GetService(k)
        t[k] = s
        return s
    end})

    local Player = Services.Players.LocalPlayer

    -- GUI
    local function createGUI(title)
        local sg = Instance.new("ScreenGui")
        sg.Parent = game:GetService("CoreGui")
        sg.ResetOnSpawn = false
        
        local mf = Instance.new("Frame")
        mf.Size = UDim2.new(0, 500, 0, 340)
        mf.Position = UDim2.new(0.5, -250, 0.5, -170)
        mf.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        mf.BorderSizePixel = 0
        mf.Parent = sg
        
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0, 30)
        bar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        bar.BorderSizePixel = 0
        bar.Parent = mf
        
        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.new(1, 0, 1, 0)
        tl.BackgroundTransparency = 1
        tl.TextColor3 = Color3.fromRGB(255, 255, 255)
        tl.Text = title or "8ilp HUB"
        tl.Font = Enum.Font.GothamBold
        tl.TextSize = 16
        tl.Parent = bar
        
        return sg, mf
    end

    local function createButton(parent, text, y, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.Parent = parent
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local function notify(text, dur)
        local sg = Instance.new("ScreenGui")
        sg.Parent = game:GetService("CoreGui")
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, 250, 0, 40)
        f.Position = UDim2.new(0.5, -125, 0, 10)
        f.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        f.BorderSizePixel = 0
        f.Parent = sg
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(0, 4, 1, 0)
        bar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        bar.BorderSizePixel = 0
        bar.Parent = f
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -14, 1, 0)
        l.Position = UDim2.new(0, 14, 0, 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(255, 255, 255)
        l.Text = text
        l.Font = Enum.Font.Gotham
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        task.delay(dur or 3, function() sg:Destroy() end)
    end

    -- ESP
    local function playerESP()
        for _, p in ipairs(Services.Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local h = Instance.new("Highlight")
                h.Parent = p.Character
                h.FillColor = Color3.fromRGB(255, 50, 50)
                h.FillTransparency = 0.4
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
        Services.Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function(c)
                task.wait(0.5)
                local h = Instance.new("Highlight")
                h.Parent = c
                h.FillColor = Color3.fromRGB(255, 50, 50)
                h.FillTransparency = 0.4
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
            end)
        end)
    end

    -- Auto Farm
    local function autoFarm(range)
        range = range or 100
        task.spawn(function()
            while task.wait(0.1) do
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = Player.Character.HumanoidRootPart
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                            if obj.Humanoid.Health > 0 and (obj.HumanoidRootPart.Position - hrp.Position).Magnitude <= range then
                                hrp.CFrame = obj.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2.5)
                                task.wait(0.2)
                            end
                        end
                    end
                end
            end
        end)
    end

    -- Fly
    local function fly(speed)
        speed = speed or 60
        if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
        local hrp = Player.Character.HumanoidRootPart
        local bg = Instance.new("BodyGyro")
        bg.P = 9e4
        bg.Parent = hrp
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = hrp
        local conn
        conn = game:GetService("RunService").RenderStepped:Connect(function()
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
    local function noclip()
        game:GetService("RunService").Stepped:Connect(function()
            if Player.Character then
                for _, v in ipairs(Player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end

    -- ============================================
    -- 🚀 BUILD HUB
    -- ============================================
    local gui, frame = createGUI("8ilp HUB v6.0")
    if not gui then return end

    local y = 40
    local function btn(t, c)
        createButton(frame, t, y, c)
        y = y + 35
    end

    btn("ESP PLAYERS", function() playerESP() notify("ESP ON", 2) end)
    btn("AUTO FARM", function() autoFarm(200) notify("Farm ON", 2) end)
    btn("SPEED 100", function() Player.Character.Humanoid.WalkSpeed = 100 notify("Speed 100", 2) end)
    btn("JUMP 150", function() Player.Character.Humanoid.JumpPower = 150 notify("Jump 150", 2) end)
    btn("FLY", function() fly(60) notify("Fly ON", 2) end)
    btn("NOCLIP", function() noclip() notify("Noclip ON", 2) end)
    btn("RESET SPEED", function() Player.Character.Humanoid.WalkSpeed = 16 notify("Reset", 2) end)
    btn("RESET JUMP", function() Player.Character.Humanoid.JumpPower = 50 notify("Reset", 2) end)

    notify("8ilp HUB Ready!", 3)
end

-- ============================================
-- 🎯 EXECUTE
-- ============================================
loadCode()
