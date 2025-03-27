local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local ESPEnabled = false

-- Функция для создания ESP
local function CreateESP(player)
    if player ~= LocalPlayer and player.Character then
        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Красный цвет
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Белая обводка
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0

        -- Удаление ESP при выходе игрока
        player.CharacterRemoving:Connect(function()
            highlight:Destroy()
        end)
    end
end

-- Обновление ESP при заходе новых игроков
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then
            CreateESP(player)
        end
    end)
end)

-- Включение/выключение ESP
local function ToggleESP()
    ESPEnabled = not ESPEnabled
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if ESPEnabled then
                CreateESP(player)
            else
                if player.Character:FindFirstChild("Highlight") then
                    player.Character.Highlight:Destroy()
                end
            end
        end
    end
end

-- Создание UI кнопки для включения/выключения ESP
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Button = Instance.new("TextButton", ScreenGui)

Button.Size = UDim2.new(0, 100, 0, 50)
Button.Position = UDim2.new(0.8, 0, 0.1, 0)
Button.Text = "Toggle ESP"
Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.MouseButton1Click:Connect(ToggleESP)

-- Назначение горячей клавиши (F) для включения/выключения ESP
UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.F and not processed then
        ToggleESP()
    end
end)

             
