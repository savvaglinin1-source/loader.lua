-- Загрузчик в стиле Fluent с динамическими ссылками на Work.ink и Linkvertise
local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()

-- ===== НАСТРОЙКИ (ЗАМЕНИТЬ, ЕСЛИ НУЖНО) =====
local work_service = "sladko_work"          -- Название сервиса для Work.ink (из Junkie)
local work_identifier = "12620"              -- Identifier для Work.ink (твой)

local link_service = "sladko_link"           -- Название сервиса для Linkvertise
local link_identifier = "12621"               -- Identifier для Linkvertise (твой)

local MAIN_SCRIPT_URL = "https://api.jnkie.com/api/v1/luascripts/15175/download"  -- Ссылка на твой скрипт
-- ============================================

-- Загружаем Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Создаём окно
local Window = Fluent:CreateWindow({
    Title = "Key System",
    SubTitle = "sladko v1.0",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 300),
    Acrylic = false,
    Theme = "Dark"
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "key" })
}

-- Переменные для хранения ссылок
local workLink = nil
local linkLink = nil
local attempts = 0
local maxAttempts = 5
local validating = false

-- Функция получения ссылок для обоих сервисов
local function fetchLinks()
    -- Для Work.ink
    local w = Junkie
    w.service = work_service
    w.identifier = work_identifier
    w.provider = "Work.ink"  -- или "Mixed", если провайдер настроен иначе
    local wl, werr = w.get_key_link()
    if wl then
        workLink = wl
    else
        Fluent:Notify({
            Title = "Work.ink Error",
            Content = "Failed to get link: " .. tostring(werr),
            Duration = 5
        })
    end

    -- Для Linkvertise
    local l = Junkie
    l.service = link_service
    l.identifier = link_identifier
    l.provider = "Linkvertise"
    local ll, lerr = l.get_key_link()
    if ll then
        linkLink = ll
    else
        Fluent:Notify({
            Title = "Linkvertise Error",
            Content = "Failed to get link: " .. tostring(lerr),
            Duration = 5
        })
    end

    if workLink or linkLink then
        Fluent:Notify({
            Title = "Links Ready",
            Content = "You can now get your key from any provider.",
            Duration = 3
        })
    else
        Fluent:Notify({
            Title = "Critical Error",
            Content = "Could not get any links. Check Junkie settings.",
            Duration = 5
        })
    end
end

-- Описание
Tabs.Main:AddParagraph({
    Title = "Welcome",
    Content = "Choose a provider to get a key, then enter it below."
})

-- Кнопка для Work.ink
Tabs.Main:AddButton({
    Title = "Get Key (Work.ink)",
    Description = "Copy Work.ink link to clipboard",
    Callback = function()
        if workLink then
            setclipboard(workLink)
            Fluent:Notify({
                Title = "Work.ink Link Copied",
                Content = "Open it in your browser to get the key.",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Work.ink link not available. Try again later.",
                Duration = 3
            })
        end
    end
})

-- Кнопка для Linkvertise
Tabs.Main:AddButton({
    Title = "Get Key (Linkvertise)",
    Description = "Copy Linkvertise link to clipboard",
    Callback = function()
        if linkLink then
            setclipboard(linkLink)
            Fluent:Notify({
                Title = "Linkvertise Link Copied",
                Content = "Open it in your browser to get the key.",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Linkvertise link not available. Try again later.",
                Duration = 3
            })
        end
    end
})

-- Поле ввода ключа
local keyInput = Tabs.Main:AddInput("KeyInput", {
    Title = "Your Key",
    Default = "",
    Placeholder = "Enter key here...",
    Numeric = false,
    Finished = false,
    Callback = function() end
})

-- Кнопка проверки ключа
Tabs.Main:AddButton({
    Title = "OK",
    Description = "Validate your key",
    Callback = function()
        if validating then return end
        local key = keyInput.Value
        if #key == 0 then
            Fluent:Notify({ Title = "Error", Content = "Please enter a key!", Duration = 2 })
            return
        end

        attempts = attempts + 1
        if attempts > maxAttempts then
            Fluent:Notify({ Title = "Error", Content = "Too many failed attempts.", Duration = 3 })
            return
        end

        validating = true
        Fluent:Notify({ Title = "Checking", Content = "Validating key...", Duration = 1.5 })

        -- Используем сервис Work.ink для проверки (можно заменить на link_service)
        local checker = Junkie
        checker.service = work_service
        checker.identifier = work_identifier
        checker.provider = "Work.ink"

        local result = checker.check_key(key)
        validating = false

        if result and result.valid then
            Fluent:Notify({ Title = "Success", Content = "Key accepted! Loading script...", Duration = 2 })
            getgenv().SCRIPT_KEY = key
            local success, err = pcall(function()
                loadstring(game:HttpGet(MAIN_SCRIPT_URL))()
            end)
            if success then
                Window:Destroy()
            else
                Fluent:Notify({ Title = "Error", Content = "Failed to load script: " .. tostring(err), Duration = 4 })
            end
        else
            local errorMsg = result and result.error or "Unknown error"
            Fluent:Notify({ Title = "Invalid Key", Content = "Error: " .. errorMsg, Duration = 3 })
            if errorMsg == "HWID_BANNED" then
                task.wait(2)
                game.Players.LocalPlayer:Kick("HWID banned")
            end
        end
    end
})

-- Добавляем менеджеры (опционально)
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("sladko_keys")
SaveManager:SetFolder("sladko_keys")
SaveManager:BuildConfigSection(Tabs.Main)
InterfaceManager:BuildInterfaceSection(Tabs.Main)

-- Запускаем получение ссылок при старте
fetchLinks()
Window:SelectTab(1)
