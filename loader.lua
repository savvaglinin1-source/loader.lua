-- Загрузчик с выбором провайдера (Work.ink / Linkvertise)
local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()

-- ===== НАСТРОЙКИ (ЗАМЕНИТЬ) =====
-- Данные для Work.ink (из Junkie: сервис sladko_work)
local work_service = "sladko_work"      -- Вставь сюда Service Name для Work.ink
local work_identifier = "554171"          -- Вставь сюда Identifier для Work.ink

-- Данные для Linkvertise (из Junkie: сервис sladko_link)
local link_service = "sladko_link"       -- Вставь сюда Service Name для Linkvertise
local link_identifier = "3750438"           -- Вставь сюда Identifier для Linkvertise

-- Ссылка на твой основной скрипт (sladko v1) из Junkie (Lua Scripts)
local MAIN_SCRIPT_URL = "https://api.jnkie.com/api/v1/luascripts/15175/download"  

-- Создание UI (меню)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 320)
frame.Position = UDim2.new(0.5, -200, 0.5, -160)
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

-- Блок для Work.ink
local workLabel = Instance.new("TextLabel")
workLabel.Size = UDim2.new(1, -20, 0, 40)
workLabel.Position = UDim2.new(0, 10, 0, 45)
workLabel.BackgroundColor3 = Color3.fromRGB(45,45,50)
workLabel.Text = "Загрузка Work.ink..."
workLabel.TextColor3 = Color3.fromRGB(200,200,200)
workLabel.Font = Enum.Font.Gotham
workLabel.TextSize = 14
workLabel.TextWrapped = true
workLabel.Parent = frame

local workCorner = Instance.new("UICorner")
workCorner.CornerRadius = UDim.new(0, 6)
workCorner.Parent = workLabel

local workCopy = Instance.new("TextButton")
workCopy.Size = UDim2.new(0, 60, 0, 25)
workCopy.Position = UDim2.new(1, -70, 0, 52)
workCopy.BackgroundColor3 = Color3.fromRGB(80,150,255)
workCopy.Text = "Копировать"
workCopy.TextColor3 = Color3.fromRGB(255,255,255)
workCopy.Font = Enum.Font.Gotham
workCopy.TextSize = 12
workCopy.Visible = false
workCopy.Parent = frame

local workCopyCorner = Instance.new("UICorner")
workCopyCorner.CornerRadius = UDim.new(0, 4)
workCopyCorner.Parent = workCopy

-- Блок для Linkvertise
local linkLabel = Instance.new("TextLabel")
linkLabel.Size = UDim2.new(1, -20, 0, 40)
linkLabel.Position = UDim2.new(0, 10, 0, 95)
linkLabel.BackgroundColor3 = Color3.fromRGB(45,45,50)
linkLabel.Text = "Загрузка Linkvertise..."
linkLabel.TextColor3 = Color3.fromRGB(200,200,200)
linkLabel.Font = Enum.Font.Gotham
linkLabel.TextSize = 14
linkLabel.TextWrapped = true
linkLabel.Parent = frame

local linkCorner = Instance.new("UICorner")
linkCorner.CornerRadius = UDim.new(0, 6)
linkCorner.Parent = linkLabel

local linkCopy = Instance.new("TextButton")
linkCopy.Size = UDim2.new(0, 60, 0, 25)
linkCopy.Position = UDim2.new(1, -70, 0, 102)
linkCopy.BackgroundColor3 = Color3.fromRGB(80,150,255)
linkCopy.Text = "Копировать"
linkCopy.TextColor3 = Color3.fromRGB(255,255,255)
linkCopy.Font = Enum.Font.Gotham
linkCopy.TextSize = 12
linkCopy.Visible = false
linkCopy.Parent = frame

local linkCopyCorner = Instance.new("UICorner")
linkCopyCorner.CornerRadius = UDim.new(0, 4)
linkCopyCorner.Parent = linkCopy

-- Поле ввода ключа
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -80, 0, 35)
keyBox.Position = UDim2.new(0, 10, 0, 150)
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
checkButton.Position = UDim2.new(1, -70, 0, 150)
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
statusLabel.Position = UDim2.new(0, 10, 0, 195)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ожидание..."
statusLabel.TextColor3 = Color3.fromRGB(180,180,180)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextWrapped = true
statusLabel.Parent = frame

-- Логика
local workLink = nil
local linkLink = nil
local attempts = 0
local maxAttempts = 5
local validating = false

local function setStatus(text, isError)
    statusLabel.Text = text
    statusLabel.TextColor3 = isError and Color3.fromRGB(255,100,100) or Color3.fromRGB(180,180,180)
end

-- Получаем ссылки для обоих провайдеров
local function fetchLinks()
    setStatus("Получаю ссылки...")

    -- Work.ink
    local w = Junkie
    w.service = work_service
    w.identifier = work_identifier
    w.provider = "Work.ink"  -- или как у тебя назван провайдер в Junkie
    local work_link, work_err = w.get_key_link()
    if work_link then
        workLink = work_link
        workLabel.Text = "Work.ink: " .. work_link
        workCopy.Visible = true
    else
        workLabel.Text = "Work.ink ошибка"
        if work_err then print("Work.ink error:", work_err) end
    end

    -- Linkvertise
    local l = Junkie
    l.service = link_service
    l.identifier = link_identifier
    l.provider = "Linkvertise"
    local link_link, link_err = l.get_key_link()
    if link_link then
        linkLink = link_link
        linkLabel.Text = "Linkvertise: " .. link_link
        linkCopy.Visible = true
    else
        linkLabel.Text = "Linkvertise ошибка"
        if link_err then print("Linkvertise error:", link_err) end
    end

    if workLink or linkLink then
        setStatus("Скопируй любую ссылку и получи ключ.")
    else
        setStatus("Не удалось получить ссылки. Проверь настройки.", true)
    end
end

-- Копирование ссылок
workCopy.MouseButton1Click:Connect(function()
    if workLink then
        setclipboard(workLink)
        setStatus("Ссылка Work.ink скопирована!")
    end
end)

linkCopy.MouseButton1Click:Connect(function()
    if linkLink then
        setclipboard(linkLink)
        setStatus("Ссылка Linkvertise скопирована!")
    end
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

    -- Проверяем ключ через Work.ink (или можно через Linkvertise – выбери один)
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

fetchLinks()
