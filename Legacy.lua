-- G13 BLUE LOCK LEGACY: V2 FIX
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Btn = Instance.new("TextButton", ScreenGui)

Btn.Size = UDim2.new(0, 80, 0, 80)
Btn.Position = UDim2.new(0, 10, 0.4, 0)
Btn.Text = "LEGACY"
Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

local Active = false

Btn.MouseButton1Click:Connect(function()
    Active = not Active
    Btn.Text = Active and "ACTIVO" or "LEGACY"
    Btn.BackgroundColor3 = Active and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 30, 30)
    
    task.spawn(function()
        while Active and task.wait(0.1) do -- Más rápido para que no baje la barra
            local char = game.Players.LocalPlayer.Character
            local hum = char and char:FindFirstChild("Humanoid")
            
            if char and hum then
                -- 1. VELOCIDAD REAL (Forzada)
                hum.WalkSpeed = 28 -- Le subí a 28 para que SE NOTE el cambio
                
                -- 2. ESTAMINA INFINITA (Buscando el valor exacto)
                -- Intenta setearlo en diferentes lugares donde Legacy suele guardarlo
                if char:FindFirstChild("Stamina") then char.Stamina.Value = 100 end
                
                local stats = char:FindFirstChild("Stats")
                if stats and stats:FindFirstChild("Stamina") then
                    stats.Stamina.Value = 100
                end

                -- 3. SALTO (Bonus por si querés cabecear mejor)
                hum.JumpPower = 60 
            end
        end
    end)
end)

-- Si desactivas, vuelve todo a la normalidad
Btn.MouseButton1Click:Connect(function()
    if not Active then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 16
            char.Humanoid.JumpPower = 50
        end
    end
end)
