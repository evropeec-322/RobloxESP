local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ESP_Objects = {}

local function createESP(player)
    if player == Players.LocalPlayer then return end
    if ESP_Objects[player] then return end
    
    local character = player.Character
    if not character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.FillColor = Color3.new(1, 0, 0) -- Красный цвет
    highlight.OutlineColor = Color3.new(1, 1, 1) -- Белый контур
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    
    ESP_Objects[player] = highlight
end

local function removeESP(player)
    if ESP_Objects[player] then
        ESP_Objects[player]:Destroy()
        ESP_Objects[player] = nil
    end
end

local function onCharacterAdded(player, character)
    task.wait(0.5) -- Ждем, чтобы персонаж полностью загрузился
    createESP(player)
end

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            if player.Character and not ESP_Objects[player] then
                createESP(player)
            elseif not player.Character then
                removeESP(player)
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(player, character)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

RunService.RenderStepped:Connect(updateESP)
