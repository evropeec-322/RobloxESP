-- // ESP Settings
getgenv().ESPEnabled = true -- Можно переключать кнопкой
getgenv().ESPColor = Color3.fromRGB(255, 0, 0) -- Красный цвет ESP
getgenv().ESPThickness = 2 -- Толщина линий

-- // UI Toggle
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F then -- Нажатие F включает/выключает ESP
        getgenv().ESPEnabled = not getgenv().ESPEnabled
        if not getgenv().ESPEnabled then
            for _, v in pairs(game.CoreGui:GetChildren()) do
                if v.Name == "ESPBox" then
                    v:Destroy()
                end
            end
        end
    end
end)

-- // ESP Function
function CreateESP(player)
    if player == game.Players.LocalPlayer then return end -- Не показываем ESP на себе
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = getgenv().ESPColor
    box.Thickness = getgenv().ESPThickness
    box.Filled = false

    local function Update()
        game:GetService("RunService").RenderStepped:Connect(function()
            if getgenv().ESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    box.Size = Vector2.new(50, 100)
                    box.Position = Vector2.new(pos.X - 25, pos.Y - 50)
                    box.Visible = true
                else
                    box.Visible = false
                end
            else
                box.Visible = false
            end
        end)
    end
    Update()
end

-- // Apply ESP to all players
for _, player in pairs(game.Players:GetPlayers()) do
    CreateESP(player)
end

-- // Update ESP when players join
game.Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

print("ESP Script Loaded! Press 'F' to toggle ESP on/off.")
