-- BLUE LOCK LEGACY: KAISER IMPACT (RE-FIXED TARGET)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 150, 0, 100)
Main.Position = UDim2.new(0.8, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 40)
Instance.new("UICorner", Main)

local function kaiserShot()
    local p = game.Players.LocalPlayer
    local char = p.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    
    -- BUSCADOR DE PELOTA MEJORADO
    local ball = nil
    for _, obj in pairs(workspace:GetDescendants()) do
        -- Filtramos: Que sea una parte, que esté cerca y que NO sea parte de nuestro cuerpo
        if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("football")) then
            if not obj:IsDescendantOf(char) then -- CLAVE: Si es parte de tu skin, la ignora
                if (root.Position - obj.Position).Magnitude < 15 then
                    ball = obj
                    break
                end
            end
        end
    end

    if ball then
        -- CARGA
        root.Anchored = true 
        local effect = Instance.new("Highlight", char)
        effect.FillColor = Color3.fromRGB(0, 200, 255)
        
        task.wait(0.3) -- Bajamos un poco el tiempo para que no te quiten la pelota
        
        -- DISPARO
        root.Anchored = false
        effect:Destroy()
        
        -- Usamos ApplyImpulse si es un MeshPart moderno o BodyVelocity con limpieza rápida
        -- Le bajé la velocidad de 400 a 250 para que no parezcas Flash de nuevo
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
        bv.Velocity = (workspace.CurrentCamera.CFrame.LookVector * 250) + Vector3.new(0, 20, 0)
        bv.Parent = ball
        
        -- Limpieza ultra rápida para evitar que el jugador se "pegue" a la fuerza
        game.Debris:AddItem(bv, 0.15)
        
        -- Efecto visual
        local p1 = Instance.new("ParticleEmitter", ball)
        p1.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
        p1.Rate = 100
        p1.Speed = NumberRange.new(5)
        p1.Size = NumberSequence.new(0.5)
        p1.Lifetime = NumberRange.new(0.3)
        game.Debris:AddItem(p1, 0.4)
    end
end

local btn = Instance.new("TextButton", Main)
btn.Size = UDim2.new(0.9, 0, 0.6, 0)
btn.Position = UDim2.new(0.05, 0, 0.2, 0)
btn.Text = "KAISER IMPACT"
btn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
Instance.new("UICorner", btn)
btn.MouseButton1Click:Connect(kaiserShot)
