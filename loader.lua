-- Загрузчик в стиле Fluent (без отображения ссылки)
local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()

-- ===== НАСТРОЙКИ (ЗАМЕНИТЬ) =====
local work_service = "sladko_work"          -- Название сервиса в Junkie
local work_identifier = "554171"              -- Identifier сервиса
local MAIN_SCRIPT_URL = "https://api.jnkie.com/api/v1/luascripts/15175/download"
local WORK_LINK = "https://work.ink/2kaf/sladko-loader-checkpoint-1"  -- Твоя ссылка
-- =================================

-- Создание главного окна
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FluentKeySystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 240)
frame.Position = UDim2.new(0.5, -175, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)  -- Тёмный фон как в Fluent
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Скруглённые углы
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Key System"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = frame

-- Кнопка получения ключа (стиль Fluent)
local getKeyButton = Instance.new("TextButton")
getKeyButton.Size = UDim2.new(1, -20, 0, 45)
getKeyButton.Position = UDim2.new(0, 10, 0, 55)
getKeyButton.BackgroundColor3 = Color3.fromRGB(55, 105, 255)  -- Синий акцент
getKeyButton.Text = "Get Key"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.TextSize = 18
getKeyButton.Parent = frame

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 8)
getKeyCorner.Parent = getKeyButton

-- Поле ввода ключа
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -90, 0, 45)
keyBox.Position = UDim2.new(0, 10, 0, 115)
keyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
keyBox.PlaceholderText = "Enter your key"
keyBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 16
keyBox.ClearTextOnFocus = false
keyBox.Parent = frame

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 8)
keyBoxCorner.Parent = keyBox

-- Кнопка проверки (OK)
local okButton = Instance.new("TextButton")
okButton.Size = UDim2.new(0, 70, 0, 45)
okButton.Position = UDim2.new(1, -80, 0, 115)
okButton.BackgroundColor3 = Color3.fromRGB(45, 185, 90)  -- Зелёный
okButton.Text = "OK"
okButton.TextColor3 = Color3.fromRGB(255, 255, 255)
okButton.Font = Enum.Font.GothamBold
okButton.TextSize = 18
okButton.Parent = frame

local okCorner = Instance.new("UICorner")
okCorner.CornerRadius = UDim.new(0, 8)
okCorner.Parent = okButton

-- Статусная строка (для уведомлений)
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 40)
statusLabel.Position = UDim2.new(0, 10, 0, 175)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Click 'Get Key' to receive a key"
statusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextWrapped = true
statusLabel.Parent = frame

-- Переменные
local attempts = 0
local maxAttempts = 5
local validating = false

-- Функция обновления статуса
local function setStatus(text, isError, temporary)
    statusLabel.Text = text
    statusLabel.TextColor3 = isError and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(160, 160, 160)
    if temporary then
        task.wait(2)
        statusLabel.Text = "Click 'Get Key' to receive a key"
        statusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
    end
end

-- Кнопка получения ключа (копирует ссылку)
getKeyButton.MouseButton1Click:Connect(function()
    setclipboard(WORK_LINK)
    setStatus("✅ Link copied! Open it in your browser to get the key.", false, true)
end)

-- Кнопка проверки ключа
okButton.MouseButton1Click:Connect(function()
    if validating then return end
    local key = keyBox.Text
    if #key == 0 then
        setStatus("❌ Please enter a key!", true, true)
        return
    end

    attempts = attempts + 1
    if attempts > maxAttempts then
        setStatus("❌ Too many failed attempts. Restart.", true)
        return
    end

    validating = true
    setStatus("⏳ Checking key...", false)

    local checker = Junkie
    checker.service = work_service
    checker.identifier = work_identifier
    checker.provider = "Work.ink"

    local result = checker.check_key(key)
    validating = false

    if result and result.valid then
        setStatus("✅ Key accepted! Loading script...", false)
        getgenv().SCRIPT_KEY = key
        local success, err = pcall(function()
            loadstring(game:HttpGet(MAIN_SCRIPT_URL))()
        end)
        if success then
            screenGui:Destroy()
        else
            setStatus("❌ Failed to load script: " .. tostring(err), true)
        end
    else
        local errorMsg = result and result.error or "Unknown error"
        setStatus("❌ Error: " .. errorMsg, true, true)
        if errorMsg == "HWID_BANNED" then
            task.wait(2)
            game.Players.LocalPlayer:Kick("HWID banned")
        end
    end
end)
