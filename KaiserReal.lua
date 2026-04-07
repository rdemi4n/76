-- ==========================================
-- KAISER RIVALS V2: COMPACT & MOVABLE
-- ==========================================
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local p = Players.LocalPlayer
local char = p.Character or p.CharacterAdded:Wait()

-- ==========================================
-- 1. GUI COMPACTA Y MOVIBLE
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "KaiserCompact"
Main.Size = UDim2.new(0, 120, 0, 160) -- Mucho más chiquito
Main.Position = UDim2.new(0.85, 0, 0.5, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Main.BackgroundTransparency = 0.3
Main.Active = true
Main.Draggable = true -- Propiedad simple para que puedas moverlo

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local function createBtn(name, pos, color)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0.2, 0)
    btn.Position = UDim2.new(0.05, 0, pos, 0)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    Instance.new("UICorner", btn)
    return btn
end

local btnImpact = createBtn("IMPACT", 0.1, Color3.fromRGB(0, 100, 255))
local btnRoute = createBtn("ROUTE", 0.32, Color3.fromRGB(0, 180, 180))
local btnAwaken = createBtn("AWAKEN", 0.54, Color3.fromRGB(120, 0, 255))
local btnMagnus = createBtn("MAGNUS", 0.76, Color3.fromRGB(200, 0, 50))

-- ==========================================
-- 2. LÓGICA DE BÚSQUEDA DE PELOTA
-- ==========================================
local function getBall()
    local root = char:FindFirstChild("HumanoidRootPart")
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("ball") and not obj:IsDescendantOf(char) then
            if (root.Position - obj.Position).Magnitude < 12 then
                return obj
            end
        end
    end
    return nil
end

-- ==========================================
-- 3. EMPEROR'S ROUTE (Drible de 3 tiempos)
-- ==========================================
local isDribbling = false
local function emperorsRoute()
    local root = char:FindFirstChild("HumanoidRootPart")
    local ball = getBall()
    
    if root and ball and not isDribbling then
        isDribbling = true
        
        -- Aura de inicio
        local highlight = Instance.new("Highlight", char)
        highlight.FillColor = Color3.fromRGB(0, 255, 255)
        Debris:AddItem(highlight, 1)

        -- Secuencia de 3 tiempos (Izquierda -> Derecha -> Frente)
        local dashVectors = {
            root.CFrame.RightVector * -8 + root.CFrame.LookVector * 6, -- Dash 1: Diagonal Izquierda
            root.CFrame.RightVector * 16,                             -- Dash 2: Recorte Derecha
            root.CFrame.LookVector * 10                               -- Dash 3: Explosión al frente
        }

        for i, vector in ipairs(dashVectors) do
            -- Efecto de "Ghost" / Sombra
            local ghost = Instance.new("Part", workspace)
            ghost.Size = char["Left Leg"].Size -- Solo una parte para el efecto
            ghost.CFrame = root.CFrame
            ghost.Anchored = true; ghost.CanCollide = false
            ghost.Color = Color3.fromRGB(0, 255, 255); ghost.Material = Enum.Material.Neon
            TweenService:Create(ghost, TweenInfo.new(0.3), {Transparency = 1, Size = Vector3.new(0,0,0)}):Play()
            Debris:AddItem(ghost, 0.3)

            -- Movimiento del Jugador y la Pelota
            root.CFrame = root.CFrame + vector
            ball.CFrame = root.CFrame * CFrame.new(0, -1, -3) -- La pelota se mantiene pegada
            ball.Velocity = Vector3.new(0,0,0) -- Evita que la pelota salga volando por física
            
            task.wait(0.12) -- El "tempo" entre cada paso del drible
        end
        
        isDribbling = false
    end
end

-- ==========================================
-- 4. OTRAS HABILIDADES (Ajustadas)
-- ==========================================

local function kaiserImpact()
    local ball = getBall()
    local root = char:FindFirstChild("HumanoidRootPart")
    if ball and root then
        local bv = Instance.new("BodyVelocity", ball)
        bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
        bv.Velocity = (workspace.CurrentCamera.CFrame.LookVector * 380) + Vector3.new(0, 10, 0)
        Debris:AddItem(bv, 0.1)
        
        -- Efecto rayo azul
        local p = Instance.new("ParticleEmitter", ball)
        p.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
        p.Size = NumberSequence.new(1.5)
        Debris:AddItem(p, 0.5)
    end
end

local function awakening()
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = 26
        local h = Instance.new("Highlight", char)
        h.FillColor = Color3.fromRGB(100, 0, 255)
        task.wait(10)
        hum.WalkSpeed = 16
        h:Destroy()
    end
end

-- ==========================================
-- CONEXIONES
-- ==========================================
btnRoute.MouseButton1Click:Connect(emperorsRoute)
btnImpact.MouseButton1Click:Connect(kaiserImpact)
btnAwaken.MouseButton1Click:Connect(awakening)
btnMagnus.MouseButton1Click:Connect(function()
    print("Magnus Shot activado")
    -- (Aquí puedes poner la lógica del Magnus que te pasé antes)
end)
