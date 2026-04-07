-- BLUE LOCK LEGACY: KAISER IMPACT (FIXED TARGET)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 150, 0, 100)
Main.Position = UDim2.new(0.8, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 40)
Instance.new("UICorner", Main)

local function kaiserShot()
    local p = game.Players.LocalPlayer
    local char = p.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    
    -- BUSCADOR DE PELOTA (IGNORA AL JUGADOR)
    local ball = nil
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("foot")) then
            if (root.Position - obj.Position).Magnitude < 15 then
                ball = obj
                break
            end
        end
    end

    if ball then
        -- CARGA (Te ancla al piso)
        root.Anchored = true 
        local effect = Instance.new("Highlight", char)
        effect.FillColor = Color3.fromRGB(0, 200, 255)
        
        task.wait(0.5) -- Tiempo de carga
        
        -- DISPARO (Fuerza directa a la bola)
        root.Anchored = false
        effect:Destroy()
        
        local bv = Instance.new("BodyVelocity", ball)
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bv.Velocity = (workspace.CurrentCamera.CFrame.LookVector * 400) + Vector3.new(0, 15, 0)
        
        -- Limpieza del rastro
        game.Debris:AddItem(bv, 0.2)
        
        -- Efecto visual de rastro azul
        local p1 = Instance.new("ParticleEmitter", ball)
        p1.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
        p1.Size = NumberSequence.new(1)
        p1.Lifetime = NumberRange.new(0.5)
        game.Debris:AddItem(p1, 0.5)
    end
end

local btn = Instance.new("TextButton", Main)
btn.Size = UDim2.new(0.9, 0, 0.6, 0)
btn.Position = UDim2.new(0.05, 0, 0.2, 0)
btn.Text = "KAISER IMPACT"
btn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btn)
btn.MouseButton1Click:Connect(kaiserShot)
