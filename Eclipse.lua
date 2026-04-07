-- BLUE LOCK LEGACY: ESTILO ECLIPSE V2.1 (FIX CACHÉ + KAISER IMPACT)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 150, 0, 200)
Main.Position = UDim2.new(0.8, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Text = "ECLIPSE: KAISER"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold

local function createSkill(name, pos, color, func)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.8, 0, 0.2, 0)
    b.Position = pos
    b.Text = name
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
end

-- 1. DASH
createSkill("SOMBRA (DASH)", UDim2.new(0.1, 0, 0.25, 0), Color3.fromRGB(40, 40, 40), function()
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = root.CFrame * CFrame.new(0, 0, -15) end
end)

-- 2. KAISER IMPACT (Poder de disparo)
createSkill("KAISER IMPACT", UDim2.new(0.1, 0, 0.50, 0), Color3.fromRGB(0, 100, 255), function()
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    for _, v in pairs(workspace:GetChildren()) do
        if (v.Name == "Football" or v.Name == "Ball") and v:IsA("BasePart") then
            local dist = (root.Position - v.Position).Magnitude
            if dist < 20 then
                -- El tiro sale disparado a donde mirás
                v.Velocity = (workspace.CurrentCamera.CFrame.LookVector * 300) + Vector3.new(0, 10, 0)
                
                -- Efecto de rastro azul
                local att = Instance.new("Attachment", v)
                local trail = Instance.new("Trail", v)
                trail.Attachment0 = att
                trail.Color = ColorSequence.new(Color3.fromRGB(0, 200, 255))
                task.wait(0.5)
                trail:Destroy()
                att:Destroy()
            end
        end
    end
end)

-- 3. VISIÓN (ESP)
local espActive = false
createSkill("VISIÓN", UDim2.new(0.1, 0, 0.75, 0), Color3.fromRGB(20, 20, 20), function()
    espActive = not espActive
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("EclipseHighlight")
            if espActive then
                if not h then
                    local highlight = Instance.new("Highlight", p.Character)
                    highlight.Name = "EclipseHighlight"
                    highlight.FillColor = Color3.fromRGB(0, 200, 255)
                end
            else
                if h then h:Destroy() end
            end
        end
    end
end)

-- ESTAMINA INFINITA
task.spawn(function()
    while task.wait(0.5) do
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v.Name:lower():find("stamina") and (v:IsA("NumberValue") or v:IsA("IntValue")) then
                    v.Value = 100
                end
            end
        end
    end
end)
