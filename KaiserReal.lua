-- BLUE LOCK LEGACY: KAISER IMPACT (FIJO AL SUELO)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 150, 0, 110)
Main.Position = UDim2.new(0.8, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0.4, 0)
Title.Text = "KAISER IMPACT"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local function shoot()
    local p = game.Players.LocalPlayer
    local char = p.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    -- 1. BUSCAR LA PELOTA
    local ball = nil
    for _, v in pairs(workspace:GetDescendants()) do
        -- Busca algo que se llame Ball o que tenga propiedades de pelota cerca tuyo
        if v:IsA("BasePart") and (v.Name:lower():find("ball") or v.Name:lower():find("football")) then
            if (root.Position - v.Position).Magnitude < 15 then
                ball = v
                break
            end
        end
    end

    if ball and hum then
        -- [EFECTO DE CARGA]
        hum.WalkSpeed = 0 -- Te frena a vos
        local h = Instance.new("Highlight", char)
        h.FillColor = Color3.fromRGB(0, 150, 255)
        
        task.wait(0.5) -- Pausa dramática de Kaiser
        
        -- [EL DISPARO - AHORA SOLO A LA PELOTA]
        hum.WalkSpeed = 16 -- Volvés a la normalidad
        h:Destroy()
        
        local lookVec = workspace.CurrentCamera.CFrame.LookVector
        -- Aplicamos la fuerza SOLO a la pelota
        ball.Velocity = (lookVec * 390) + Vector3.new(0, 12, 0) 
        
        -- Efecto de rastro azul
        local trail = Instance.new("SelectionPartLasso", ball)
        trail.Color3 = Color3.fromRGB(0, 255, 255)
        trail.Part = ball
        trail.Humanoid = hum
        task.wait(0.4)
        trail:Destroy()
    end
end

local btn = Instance.new("TextButton", Main)
btn.Size = UDim2.new(0.9, 0, 0.5, 0)
btn.Position = UDim2.new(0.05, 0, 0.45, 0)
btn.Text = "¡DISPARAR!"
btn.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btn)
btn.MouseButton1Click:Connect(shoot)
