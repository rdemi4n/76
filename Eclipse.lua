-- BLUE LOCK LEGACY: ESTILO ECLIPSE V2 (CON KAISER IMPACT)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 150, 0, 200)
Main.Position = UDim2.new(0.8, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Text = "ECLIPSE: KAISER"
Title.TextColor3 = Color3.fromRGB(0, 150, 255)
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
createSkill("SOMBRA (DASH)", UDim2.new(0.1, 0, 0.25, 0), Color3.fromRGB(30, 30, 30), function()
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = root.CFrame * CFrame.new(0, 0, -15)
    end
end)

-- 2. KAISER IMPACT (REEMPLAZA SALTO G)
createSkill("KAISER IMPACT", UDim2.new(0.1, 0, 0.50, 0), Color3.fromRGB(0, 80, 200), function()
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    -- Busca la pelota en el mapa
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "Football" or v.Name == "Ball" then
            local dist = (root.Position - v.Position).Magnitude
            if dist < 15 then -- Si la pelota está cerca tuyo
                -- Simula el impacto ultra-rápido de Kaiser
                v.Velocity = (game.Workspace.CurrentCamera.CFrame.LookVector * 280) + Vector3.new(0, 15, 0)
                
                -- Efecto visual (Flash azul)
                local flash = Instance.new("SelectionHighlight", v)
                flash.Color3 = Color3.fromRGB(0, 200, 255)
                task.wait(0.3)
                flash:Destroy()
            end
        end
    end
end)

-- 3. VISIÓN (ESP)
local espActive = false
createSkill("VISIÓN", UDim2.new(0.1, 0, 0.75, 0), Color3.fromRGB(0, 40, 100), function()
    espActive = not espActive
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            local highlight = p.Character:FindFirstChild("EclipseHighlight")
            if espActive then
                if not highlight then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "EclipseHighlight"
                    h.FillColor = Color3.fromRGB(0, 150, 255)
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

-- PASIVA: ESTAMINA INFINITA
task.spawn(function()
    while task.wait(0.5) do
        local p = game.Players.LocalPlayer
        if p.Character then
            for _, v in pairs(p.Character:GetDescendants()) do
                if v.Name:lower():find("stamina") and (v:IsA("NumberValue") or v:IsA("IntValue")) then
                    v.Value = 100
                end
            end
        end
    end
end)
