-- BLUE LOCK LEGACY: KAISER IMPACT DEFINITIVO
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 150, 0, 160)
Main.Position = UDim2.new(0.8, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 20) -- Azul muy oscuro
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0.3, 0)
Title.Text = "KAISER IMPACT"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local function createBtn(name, pos, color, func)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9, 0, 0.3, 0)
    b.Position = pos
    b.Text = name
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
end

-- LA HABILIDAD MAESTRA
createBtn("EJECUTAR IMPACTO", UDim2.new(0.05, 0, 0.35, 0), Color3.fromRGB(0, 50, 200), function()
    local p = game.Players.LocalPlayer
    local char = p.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    -- BUSCADOR DE PELOTA POR CERCANÍA (No importa el nombre)
    local ball = nil
    local maxDist = 15
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("ball") or v.Name:lower():find("foot")) then
            local d = (root.Position - v.Position).Magnitude
            if d < maxDist then
                ball = v
                break
            end
        end
    end

    if ball and hum then
        -- [ANIMACIÓN DE CARGA]
        hum.WalkSpeed = 0 -- Te frena seco
        
        -- Efecto visual en el personaje (Brillo)
        local highlight = Instance.new("Highlight", char)
        highlight.FillColor = Color3.fromRGB(0, 255, 255)
        highlight.OutlineColor = Color3.new(1, 1, 1)

        task.wait(0.5) -- PAUSA DE CARGA (Kaiser Impact Pose)
        
        -- [EL DISPARO]
        hum.WalkSpeed = 20 -- Te libera (un poco más rápido)
        highlight:Destroy()
        
        -- Fuerza brutal hacia donde miras
        local targetDir = workspace.CurrentCamera.CFrame.LookVector
        ball.Velocity = (targetDir * 380) + Vector3.new(0, 15, 0)
        
        -- Rastro de energía
        local attachment = Instance.new("Attachment", ball)
        local beam = Instance.new("Trail", ball)
        beam.Attachment0 = attachment
        beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
        beam.Lifetime = 0.4
        
        task.wait(0.5)
        beam:Destroy()
        attachment:Destroy()
    end
end)

-- DASH PARA POSICIONARSE
createBtn("DASH", UDim2.new(0.05, 0, 0.7, 0), Color3.fromRGB(30, 30, 30), function()
    local root = game.Players.LocalPlayer.Character.HumanoidRootPart
    root.CFrame = root.CFrame * CFrame.new(0, 0, -12)
end)

-- ESTAMINA INFINITA AUTOMÁTICA
task.spawn(function()
    while task.wait(0.3) do
        local stats = game.Players.LocalPlayer.Character:FindFirstChild("Stamina") or game.Players.LocalPlayer:FindFirstChild("Stamina")
        if stats then stats.Value = 100 end
    end
end)
