-- ==========================================
-- KAISER RIVALS V4: REFINED CONTROL
-- ==========================================
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local p = Players.LocalPlayer
local char = p.Character or p.CharacterAdded:Wait()

-- ==========================================
-- 1. GUI COMPACTA (FIXED)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "KaiserV4"
Main.Size = UDim2.new(0, 130, 0, 180)
Main.Position = UDim2.new(0.85, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
Main.BackgroundTransparency = 0.2
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", Main)
stroke.Color = Color3.fromRGB(0, 200, 255)
stroke.Thickness = 2

local function createBtn(name, pos, color)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0.2, 0)
    btn.Position = UDim2.new(0.05, 0, pos, 0)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBlack
    btn.TextScaled = true
    Instance.new("UICorner", btn)
    return btn
end

local btnImpact = createBtn("IMPACT", 0.08, Color3.fromRGB(0, 80, 255))
local btnRoute = createBtn("ROUTE", 0.31, Color3.fromRGB(0, 160, 160))
local btnMagnus = createBtn("MAGNUS", 0.54, Color3.fromRGB(180, 0, 50))
local btnAwaken = createBtn("AWAKEN", 0.77, Color3.fromRGB(100, 0, 200))

-- ==========================================
-- 2. DETECTOR DE BALÓN MEJORADO
-- ==========================================
local function getBall()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local targetBall = nil
    local dist = 30 -- Rango un poco más amplio
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("football")) then
            if not obj:IsDescendantOf(char) then
                local mag = (root.Position - obj.Position).Magnitude
                if mag < dist then
                    targetBall = obj
                    dist = mag
                end
            end
        end
    end
    return targetBall
end

-- ==========================================
-- 3. HABILIDADES REFINADAS
-- ==========================================

-- [A] KAISER IMPACT (Fuerza Controlada)
local function kaiserImpact()
    local ball = getBall()
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if ball and root then
        ball.CFrame = root.CFrame * CFrame.new(0, -1, -3)
        ball.Velocity = Vector3.new(0,0,0)
        
        task.wait(0.05)
        
        local bv = Instance.new("BodyVelocity", ball)
        bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
        -- POTENCIA REDUCIDA: de 420 a 150 para que no se buguee
        bv.Velocity = (workspace.CurrentCamera.CFrame.LookVector * 150) + Vector3.new(0, 2, 0)
        Debris:AddItem(bv, 0.1)
        
        local att0 = Instance.new("Attachment", ball)
        local att1 = Instance.new("Attachment", root)
        local beam = Instance.new("Beam", ball)
        beam.Attachment0 = att0; beam.Attachment1 = att1
        beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
        beam.Width0 = 1; beam.Width1 = 1
        Debris:AddItem(beam, 0.2); Debris:AddItem(att0, 0.2); Debris:AddItem(att1, 0.2)
    end
end

-- [B] EMPEROR'S ROUTE (Fijo y con Balón)
local isDribbling = false
local function emperorsRoute()
    local ball = getBall()
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if ball and root and not isDribbling then
        isDribbling = true
        
        -- Detenemos la pelota temporalmente para evitar que la física la mueva sola
        if ball:FindFirstChild("BodyVelocity") then ball.BodyVelocity:Destroy() end
        ball.Velocity = Vector3.new(0,0,0)

        local offsets = {
            Vector3.new(-8, 0, -4),  -- Más corto
            Vector3.new(15, 0, -4),  -- Más corto
            Vector3.new(-8, 0, -10)  -- Más corto
        }
        
        for _, offset in ipairs(offsets) do
            local targetPos = root.CFrame * offset
            -- Tween suave para el jugador en lugar de CFrame brusco
            local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos.Position, targetPos.Position + root.CFrame.LookVector)})
            tween:Play()
            
            -- Mantener la pelota frente al jugador constantemente durante el tween
            local conn
            conn = RunService.RenderStepped:Connect(function()
                if ball and root then
                    ball.CFrame = root.CFrame * CFrame.new(0, -1, -3)
                    ball.Velocity = Vector3.new(0,0,0)
                end
            end)
            
            -- Efecto de rastro
            local p = Instance.new("Part", workspace)
            p.Size = Vector3.new(4,6,1); p.Anchored = true; p.CanCollide = false
            p.CFrame = root.CFrame; p.Color = Color3.fromRGB(0, 255, 255); p.Material = Enum.Material.Neon
            TweenService:Create(p, TweenInfo.new(0.3), {Transparency = 1}):Play()
            Debris:AddItem(p, 0.3)
            
            task.wait(0.15)
            conn:Disconnect() -- Desconectar el loop al terminar el paso
        end
        isDribbling = false
    end
end

-- [C] MAGNUS SHOT (Tiro Recto Rápido, sin picada)
local function magnusShot()
    local ball = getBall()
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if ball and root then
        ball.CFrame = root.CFrame * CFrame.new(0, -1, -3)
        ball.Velocity = Vector3.new(0,0,0)
        
        local h = Instance.new("Highlight", char)
        h.FillColor = Color3.fromRGB(255, 0, 0)
        Debris:AddItem(h, 0.5)
        
        task.wait(0.1)
        
        local bv = Instance.new("BodyVelocity", ball)
        bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
        -- POTENCIA REDUCIDA: tiro recto rápido y bajo
        bv.Velocity = (workspace.CurrentCamera.CFrame.LookVector * 180) + Vector3.new(0, 1, 0)
        Debris:AddItem(bv, 0.15)
        
        local trail = Instance.new("Trail", ball)
        local a0 = Instance.new("Attachment", ball); a0.Position = Vector3.new(0,0.5,0)
        local a1 = Instance.new("Attachment", ball); a1.Position = Vector3.new(0,-0.5,0)
        trail.Attachment0 = a0; trail.Attachment1 = a1
        trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 50))
        Debris:AddItem(trail, 1); Debris:AddItem(a0, 1); Debris:AddItem(a1, 1)
    end
end

-- ==========================================
-- CONEXIONES
-- ==========================================
btnImpact.MouseButton1Click:Connect(kaiserImpact)
btnRoute.MouseButton1Click:Connect(emperorsRoute)
btnMagnus.MouseButton1Click:Connect(magnusShot)
btnAwaken.MouseButton1Click:Connect(function()
    char.Humanoid.WalkSpeed = 28
    local h = Instance.new("Highlight", char)
    h.FillColor = Color3.fromRGB(150, 0, 255)
    task.wait(15)
    char.Humanoid.WalkSpeed = 16
    h:Destroy()
end)
