-- BLUE LOCK LEGACY: CUSTOM STYLE "ECLIPSE" (V1)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 150, 0, 200)
Main.Position = UDim2.new(0.8, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Text = "ESTILO: ECLIPSE"
Title.TextColor3 = Color3.fromRGB(170, 0, 255)
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

-- 1. DASH (SOMBRA VELOZ)
createSkill("SOMBRA (DASH)", UDim2.new(0.1, 0, 0.25, 0), Color3.fromRGB(50, 0, 80), function()
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = root.CFrame * CFrame.new(0, 0, -15) -- Te empuja 15 metros adelante
    end
end)

-- 2. SALTO (GRAVITATORIO)
createSkill("SALTO G", UDim2.new(0.1, 0, 0.50, 0), Color3.fromRGB(80, 0, 120), function()
    local char = game.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        task.wait(0.1)
        char.HumanoidRootPart.Velocity = Vector3.new(0, 80, 0) -- Impulso vertical
    end
end)

-- 3. ESP (VISIÓN)
local espActive = false
createSkill("VISIÓN", UDim2.new(0.1, 0, 0.75, 0), Color3.fromRGB(120, 0, 200), function()
    espActive = not espActive
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            local highlight = p.Character:FindFirstChild("EclipseHighlight")
            if espActive then
                if not highlight then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "EclipseHighlight"
                    h.FillColor = Color3.fromRGB(170, 0, 255)
                    h.OutlineColor = Color3.new(1, 1, 1)
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

-- PASIVA: ESTAMINA SIEMPRE AL 100
task.spawn(function()
    while task.wait(0.5) do
        local p = game.Players.LocalPlayer
        for _, v in pairs(p.Character:GetDescendants()) do
            if v.Name:lower():find("stamina") and (v:IsA("NumberValue") or v:IsA("IntValue")) then
                v.Value = 100
            end
        end
    end
end)
