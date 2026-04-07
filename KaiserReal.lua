-- ==========================================
-- KAISER RIVALS REPLICA FOR BLUE LOCK LEGACY
-- ==========================================
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local p = Players.LocalPlayer
local mouse = p:GetMouse()

-- ==========================================
-- 1. INTERFAZ GRÁFICA (UI) ESTILO RIVALS
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "KaiserRivalsUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 300)
MainFrame.Position = UDim2.new(0.8, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
MainFrame.BackgroundTransparency = 0.2
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0.15, 0)
Title.BackgroundTransparency = 1
Title.Text = "KAISER KIT"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextScaled = true

local function createBtn(name, pos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Name = name
    btn.Size = UDim2.new(0.9, 0, 0.18, 0)
    btn.Position = UDim2.new(0.05, 0, pos, 0)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    Instance.new("UICorner", btn)
    return btn
end

local btnImpact = createBtn("Kaiser Impact", 0.18, Color3.fromRGB(0, 80, 200))
local btnRoute = createBtn("Emperor's Route", 0.38, Color3.fromRGB(0, 150, 150))
local btnAwaken = createBtn("Awakening", 0.58, Color3.fromRGB(100, 0, 200))
local btnMagnus = createBtn("Magnus Shot", 0.78, Color3.fromRGB(150, 0, 50))

-- ==========================================
-- 2. UTILIDADES Y VARIABLES GLOBALES
-- ==========================================
local isAwakened = false
local routeActive = false

-- Función maestra para buscar la pelota sin buguear al jugador
local function getBall(range)
    local char = p.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    
    local foundBall = nil
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("football")) then
            if not obj:IsDescendantOf(char) then 
                if (root.Position - obj.Position).Magnitude < range then
                    foundBall = obj
                    break
                end
            end
        end
    end
    return foundBall
end

-- ==========================================
-- 3. HABILIDADES
-- ==========================================

-- [A] KAISER IMPACT (Rápido, recto, rastro celeste)
local function kaiserImpact()
    local char = p.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getBall(12)

    if ball and root then
        -- Efecto de carga
        local flash = Instance.new("Highlight", char)
        flash.FillColor = Color3.fromRGB(0, 255, 255)
        Debris:AddItem(flash, 0.3)
        task.wait(0.15)
        
        -- Multiplicador si está "Awakened"
        local power = isAwakened and 450 or 300
        
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
        bv.Velocity = (workspace.CurrentCamera.CFrame.LookVector * power) + Vector3.new(0, 5, 0)
        bv.Parent = ball
        Debris:AddItem(bv, 0.1) -- Limpieza rápida para no anclarla

        -- Rastro visual
        local trail = Instance.new("Trail", ball)
        local a0 = Instance.new("Attachment", ball); a0.Position = Vector3.new(0, 0.5, 0)
        local a1 = Instance.new("Attachment", ball); a1.Position = Vector3.new(0, -0.5, 0)
        trail.Attachment0 = a0; trail.Attachment1 = a1
        trail.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
        trail.Lifetime = 0.5
        Debris:AddItem(a0, 1); Debris:AddItem(a1, 1); Debris:AddItem(trail, 1)
    end
end

-- [B] EMPEROR'S ROUTE (Regate, velocidad, aura oscura/celeste)
local function emperorsRoute()
    local char = p.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if hum and root and not routeActive then
        routeActive = true
        local originalSpeed = hum.WalkSpeed
        hum.WalkSpeed = isAwakened and 35 or 28 -- Sube más si está despierto
        
        -- Aura de regate
        local pe = Instance.new("ParticleEmitter", root)
        pe.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        })
        pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 2), NumberSequenceKeypoint.new(1, 0)})
        pe.Rate = 50
        pe.Speed = NumberRange.new(2, 5)
        pe.Lifetime = NumberRange.new(0.5, 1)
        
        task.wait(3) -- Dura 3 segundos
        
        hum.WalkSpeed = originalSpeed
        pe.Rate = 0
        Debris:AddItem(pe, 1)
        routeActive = false
    end
end

-- [C] AWAKENING (Power Up visual y de stats)
local function awakening()
    if isAwakened then return end
    isAwakened = true
    
    local char = p.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if root then
        -- Explosión de Aura al activar
        local explosion = Instance.new("Part", workspace)
        explosion.Shape = Enum.PartType.Ball
        explosion.Size = Vector3.new(1,1,1)
        explosion.Color = Color3.fromRGB(50, 0, 255)
        explosion.Material = Enum.Material.Neon
        explosion.Anchored = true
        explosion.CanCollide = false
        explosion.CFrame = root.CFrame
        
        local tween = TweenService:Create(explosion, TweenInfo.new(0.5), {Size = Vector3.new(20,20,20), Transparency = 1})
        tween:Play()
        Debris:AddItem(explosion, 0.6)
        
        -- Aura permanente en el personaje
        local aura = Instance.new("Highlight", char)
        aura.Name = "KaiserAura"
        aura.FillColor = Color3.fromRGB(20, 0, 80)
        aura.OutlineColor = Color3.fromRGB(0, 255, 255)
        
        btnAwaken.Text = "AWAKENED"
        btnAwaken.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        
        task.wait(15) -- Dura 15 segundos el estado
        
        isAwakened = false
        btnAwaken.Text = "Awakening"
        btnAwaken.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
        if char:FindFirstChild("KaiserAura") then char.KaiserAura:Destroy() end
    end
end

-- [D] MAGNUS SHOT / ULTIMATE (Tiro con curva violenta o masivo)
local function magnusShot()
    local char = p.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getBall(15) -- Rango un poco más grande
    
    if ball and root then
        -- Simular la cinemática anclando un segundo
        root.Anchored = true
        
        -- Efecto de succión/fuerza masiva
        local ring = Instance.new("Part", workspace)
        ring.Size = Vector3.new(10, 0.5, 10)
        ring.CFrame = root.CFrame * CFrame.new(0, -2, 0)
        ring.Anchored = true; ring.CanCollide = false
        ring.Material = Enum.Material.Neon
        ring.Color = Color3.fromRGB(255, 0, 50)
        Debris:AddItem(ring, 0.5)
        
        task.wait(0.5)
        root.Anchored = false
        
        -- El tiro (Efecto Magnus: Sale hacia arriba y luego baja con fuerza, o curva)
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
        -- Apunta a donde miras, pero le agrega mucha fuerza hacia adelante y un toque de altura
        bv.Velocity = (workspace.CurrentCamera.CFrame.LookVector * 280) + Vector3.new(0, 40, 0)
        bv.Parent = ball
        Debris:AddItem(bv, 0.15)
        
        -- Explosión de partículas rojas/moradas en la pelota
        local pe = Instance.new("ParticleEmitter", ball)
        pe.Color = ColorSequence.new(Color3.fromRGB(255, 0, 100))
        pe.Size = NumberSequence.new(2)
        pe.Rate = 200
        pe.Speed = NumberRange.new(10)
        Debris:AddItem(pe, 0.6)
    end
end

-- ==========================================
-- 4. CONEXIONES DE BOTONES
-- ==========================================
btnImpact.MouseButton1Click:Connect(kaiserImpact)
btnRoute.MouseButton1Click:Connect(emperorsRoute)
btnAwaken.MouseButton1Click:Connect(awakening)
btnMagnus.MouseButton1Click:Connect(magnusShot)
