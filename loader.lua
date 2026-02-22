-- Загрузчик с жёстко прописанной ссылкой Work.ink
local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()

-- ===== НАСТРОЙКИ (ЗАМЕНИТЬ) =====
-- Данные для проверки ключа (из Junkie)
local work_service = "sladko_work"      -- Твоё название сервиса
local work_identifier = "15175"          -- Твой идентификатор (число)

-- Ссылка на основной скрипт в Junkie
local MAIN_SCRIPT_URL = "https://api.jnkie.com/api/v1/luascripts/15175/download"

-- Жёстко заданная ссылка на получение ключа (твоя)
local WORK_LINK = "https://work.ink/2kaf/sladko-loader-checkpoint-1"
-- =================================

-- Создание UI (меню)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 280)
frame.Position = UDim2.new(0.5, -200, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Key System"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

-- Блок со ссылкой
local linkLabel = Instance.new("TextLabel")
linkLabel.Size = UDim2.new(1, -90, 0, 40)
linkLabel.Position = UDim2.new(0, 10, 0, 45)
linkLabel.BackgroundColor3 = Color3.fromRGB(45,45,50)
linkLabel.Text = "Ссылка: " .. WORK_LINK
linkLabel.TextColor3 = Color3.fromRGB(200,200,200)
linkLabel.Font = Enum.Font.Gotham
linkLabel.TextSize = 14
linkLabel.TextWrapped = true
linkLabel.Parent = frame

local linkCorner = Instance.new("UICorner")
linkCorner.CornerRadius = UDim.new(0, 6)
linkCorner.Parent = linkLabel

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 70, 0, 40)
copyButton.Position = UDim2.new(1, -80, 0, 45)
copyButton.BackgroundColor3 = Color3.fromRGB(80,150,255)
copyButton.Text = "Копировать"
copyButton.TextColor3 = Color3.fromRGB(255,255,255)
copyButton.Font = Enum.Font.Gotham
copyButton.TextSize = 14
copyButton.Parent = frame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyButton

-- Поле ввода ключа
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -80, 0, 35)
keyBox.Position = UDim2.new(0, 10, 0, 100)
keyBox.BackgroundColor3 = Color3.fromRGB(45,45,50)
keyBox.PlaceholderText = "Введи ключ"
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 16
keyBox.ClearTextOnFocus = false
keyBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = keyBox

-- Кнопка проверки
local checkButton = Instance.new("TextButton")
checkButton.Size = UDim2.new(0, 60, 0, 35)
checkButton.Position = UDim2.new(1, -70, 0, 100)
checkButton.BackgroundColor3 = Color3.fromRGB(0,200,100)
checkButton.Text = "OK"
checkButton.TextColor3 = Color3.fromRGB(255,255,255)
checkButton.Font = Enum.Font.GothamBold
checkButton.TextSize = 16
checkButton.Parent = frame

local checkCorner = Instance.new("UICorner")
checkCorner.CornerRadius = UDim.new(0, 6)
checkCorner.Parent = checkButton

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 60)
statusLabel.Position = UDim2.new(0, 10, 0, 150)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Скопируй ссылку и получи ключ."
statusLabel.TextColor3 = Color3.fromRGB(180,180,180)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextWrapped = true
statusLabel.Parent = frame

-- Логика
local attempts = 0
local maxAttempts = 5
local validating = false

local function setStatus(text, isError)
    statusLabel.Text = text
    statusLabel.TextColor3 = isError and Color3.fromRGB(255,100,100) or Color3.fromRGB(180,180,180)
end

-- Копирование ссылки
copyButton.MouseButton1Click:Connect(function()
    setclipboard(WORK_LINK)
    setStatus("Ссылка скопирована!")
end)

-- Проверка ключа
checkButton.MouseButton1Click:Connect(function()
    if validating then return end
    local key = keyBox.Text
    if #key == 0 then
        setStatus("Введи ключ!", true)
        return
    end
    attempts = attempts + 1
    if attempts > maxAttempts then
        setStatus("Превышено число попыток.", true)
        return
    end

    -- Проверяем ключ через Junkie
    local checker = Junkie
    checker.service = work_service
    checker.identifier = work_identifier
    checker.provider = "Work.ink"

    validating = true
    setStatus("Проверяю ключ...")
    local result = checker.check_key(key)
    validating = false

    if result and result.valid then
        setStatus("Ключ принят! Загружаю скрипт...")
        getgenv().SCRIPT_KEY = key
        local success, err = pcall(function()
            loadstring(game:HttpGet(MAIN_SCRIPT_URL))()
        end)
        if success then
            screenGui:Destroy()
        else
            setStatus("Ошибка загрузки скрипта: " .. tostring(err), true)
        end
    else
        local errorMsg = result and result.error or "Неизвестная ошибка"
        setStatus("Ошибка: " .. errorMsg, true)
        if errorMsg == "HWID_BANNED" then
            wait(2)
            game.Players.LocalPlayer:Kick("HWID banned")
        end
    end
end)
