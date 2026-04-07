-- G13 BLUE LOCK LEGACY: V4 AJUSTE VELOCIDAD
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Btn = Instance.new("TextButton", ScreenGui)

Btn.Size = UDim2.new(0, 80, 0, 80)
Btn.Position = UDim2.new(0, 10, 0.4, 0)
Btn.Text = "LEGACY V4"
Btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
Btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

local Active = false

Btn.MouseButton1Click:Connect(function()
    Active = not Active
    Btn.Text = Active and "ACTIVE" or "LEGACY V4"
    Btn.BackgroundColor3 = Active and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 0, 0)
end)

-- LOOP DE RENDER (Suave para el G13)
game:GetService("RunService").RenderStepped:Connect(function()
    if Active then
        local p = game.Players.LocalPlayer
        local char = p.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")

        if char and root and hum then
            -- 1. VELOCIDAD AJUSTADA (De 0.35 bajó a 0.12 para no ser Flash)
            if hum.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * 0.12) 
            end

            -- 2. ESTAMINA (Búsqueda agresiva en cada frame)
            for _, v in pairs(char:GetDescendants()) do
                if (v.Name:lower():find("stamina") or v.Name:lower():find("energy")) and (v:IsA("NumberValue") or v:IsA("IntValue")) then
                    v.Value = 100
                end
            end
            
            -- Extra check en la carpeta de datos
            local data = p:FindFirstChild("Data") or p:FindFirstChild("leaderstats")
            if data and data:FindFirstChild("Stamina") then
                data.Stamina.Value = 100
            end
        end
    end
end)
