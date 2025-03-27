-- Настройки ESP
getgenv().espEnabled = true
getgenv().lineEnabled = true
getgenv().lineColor = Color3.fromRGB(255, 0, 0)  -- Красная линия

-- Функция рисования линии к игроку
function drawLineToPlayer(player)
    local camera = game.Workspace.CurrentCamera
    local playerChar = player.Character
    if playerChar and playerChar:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = playerChar.HumanoidRootPart
        -- Переводим мировые координаты в экранные
        local screenPosition, onScreen = camera:WorldToScreenPoint(humanoidRootPart.Position)

        if onScreen then
            -- Рисуем линию, если игрок на экране
            local line = Instance.new("Line")
            line.Color = getgenv().lineColor
            line.Thickness = 2
            line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)  -- Центр экрана
            line.To = Vector2.new(screenPosition.X, screenPosition.Y)  -- Позиция игрока на экране
            line.Parent = game.CoreGui
        end
    end
end

-- Функция для включения/выключения ESP
function toggleESP()
    getgenv().espEnabled = not getgenv().espEnabled
    if getgenv().espEnabled then
        print("ESP включен")
    else
        print("ESP выключен")
    end
end

-- Функция для включения/выключения линий
function toggleLines()
    getgenv().lineEnabled = not getgenv().lineEnabled
    if getgenv().lineEnabled then
        print("Линии включены")
    else
        print("Линии выключены")
    end
end

-- Создание UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vcsk/UI-Library/main/Source/MyUILib(Unamed).lua"))();
local Window = Library:Create("ESP Menu")

local HomeTab = Window:Tab("Settings")
HomeTab:Section("ESP Controls")
HomeTab:Toggle("Enable ESP", function(state)
    getgenv().espEnabled = state
end)

HomeTab:Toggle("Enable Lines", function(state)
    getgenv().lineEnabled = state
end)

HomeTab:Keybind("Toggle ESP", Enum.KeyCode.F, function()
    toggleESP()
end)

HomeTab:Keybind("Toggle Lines", Enum.KeyCode.G, function()
    toggleLines()
end)

-- Создаем ESP для всех игроков
game:GetService("Players").PlayerAdded:Connect(function(player)
    -- Игнорируем локального игрока
    if player ~= game.Players.LocalPlayer then
        -- Периодически проверяем игроков, если ESP включен
        game:GetService("RunService").RenderStepped:Connect(function()
            if getgenv().espEnabled then
                if getgenv().lineEnabled then
                    drawLineToPlayer(player)
                end
            end
        end)
    end
end)
