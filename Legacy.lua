-- G13 BLUE LOCK LEGACY: V3 ULTRA-FORCE
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Btn = Instance.new("TextButton", ScreenGui)

Btn.Size = UDim2.new(0, 80, 0, 80)
Btn.Position = UDim2.new(0, 10, 0.4, 0)
Btn.Text = "LEGACY V3"
Btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
Btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

local Active = false

Btn.MouseButton1Click:Connect(function()
    Active = not Active
    Btn.Text = Active and "ACTIVE" or "LEGACY V3"
    Btn.BackgroundColor3 = Active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 0, 0)
end)

-- LOOP DE ALTA VELOCIDAD (Para que no gaste batería en el G13)
game:GetService("RunService").RenderStepped:Connect(function()
    if Active then
        local p = game.Players.LocalPlayer
        local char = p.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")

        if char and root and hum then
            -- 1. VELOCIDAD DE MOVIMIENTO (CFrame Bypass)
            -- Si estás caminando, te empuja un poquito más
            if hum.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * 0.35) 
            end

            -- 2. ESTAMINA (Buscando en todas las carpetas posibles)
            -- Lo hacemos en cada frame (super rápido)
            for _, v in pairs(char:GetDescendants()) do
                if v.Name:lower():find("stamina") and v:IsA("NumberValue") or v:IsA("IntValue") then
                    v.Value = 100
                end
            end
            
            -- También buscamos en los datos del jugador
            local stats = p:FindFirstChild("leaderstats") or p:FindFirstChild("Data")
            if stats and stats:FindFirstChild("Stamina") then
                stats.Stamina.Value = 100
            end
        end
    end
end)
