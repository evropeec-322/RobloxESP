-- // ESP Settings
getgenv().ESPEnabled = true -- Можно включать/выключать кнопкой F
getgenv().ESPColor = Color3.fromRGB(255, 0, 0) -- Красный цвет линий
getgenv().ESPThickness = 2 -- Толщина линий
getgenv().ESPTransparency = 1 -- Прозрачность линий

-- // UI Toggle
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F then -- Нажатие F включает/выключает ESP
        getgenv().ESPEnabled = not getgenv().ESPEnabled
        if not getgenv().ESPEnabled then
            for _, v in pairs(game.CoreGui:GetChildren()) do
                if v.Name == "ESPLine" then
                    v:Destroy()
                end
            end
        end
    end
end)

-- // ESP Function
function CreateESP(player)
    if player == game.Players.LocalPlayer then return end -- Не показываем ESP на себе
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = getgenv().ESPColor
    line.Thickness = getgenv().ESPThickness
    line.Transparency = getgenv().ESPTransparency

    local function Update()
        game:GetService("RunService").RenderStepped:Connect(function()
            if getgenv().ESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                local startPos = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)

                if onScreen then
                    line.From = startPos
                    line.To = Vector2.new(rootPos.X, rootPos.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                line.Visible = false
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
