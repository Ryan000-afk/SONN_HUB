-- ==============================================================================
-- Game : Fish an Anime RNG 🎲 (PlaceId: 74729868188364)
-- Script: SONN-HUB (WindUI Edition - Ultimate Pro)
-- ==============================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Remotes Referensi
local FishingRequestStart = Remotes:WaitForChild("FishingRequestStart")
local FishingClick = Remotes:WaitForChild("FishingClick")
local BackpackEquipBest = Remotes:WaitForChild("BackpackEquipBest")
local BackpackSellRarityRequest = Remotes:WaitForChild("BackpackSellRarityRequest")
local ClaimDailyReward = Remotes:WaitForChild("ClaimDailyReward")
local ClaimPlaytimeReward = Remotes:WaitForChild("ClaimPlaytimeReward")
local FishingAfkResumeClaim = Remotes:WaitForChild("FishingAfkResumeClaim")
local RebirthGetState = Remotes:WaitForChild("RebirthGetState")
local RebirthPurchase = Remotes:WaitForChild("RebirthPurchase")

-- Remotes Quest & Toko NPC
local QuestClaimAll = Remotes:WaitForChild("QuestClaimAll")
local IndexClaimAllRewards = Remotes:WaitForChild("IndexClaimAllRewards")
local IndexClaimReward = Remotes:WaitForChild("IndexClaimReward")
local IndexGetData = Remotes:WaitForChild("IndexGetData")
local BoostsStoreGetState = Remotes:WaitForChild("BoostsStoreGetState")
local BoostsStorePurchase = Remotes:WaitForChild("BoostsStorePurchase")
local SecretStoreGetState = Remotes:WaitForChild("SecretStoreGetState")
local SecretStorePurchase = Remotes:WaitForChild("SecretStorePurchase")
local SecretStore2GetState = Remotes:WaitForChild("SecretStore2GetState")
local SecretStore2Purchase = Remotes:WaitForChild("SecretStore2Purchase")

-- Remotes Event & Mutasi
local GetTypeEventState = Remotes:WaitForChild("GetTypeEventState")
local TypeEventState = Remotes:WaitForChild("TypeEventState")

-- Membersihkan UI lama jika ada
pcall(function()
    local oldTarget = CoreGui:FindFirstChild("RobloxGui") or CoreGui
    for _, c in ipairs(oldTarget:GetChildren()) do
        if c.Name:find("WindUI") then
            c:Destroy()
        end
    end
end)

-- Hapus tag ESP lama jika ada
if _G.__FishAnimeRNG_Cleanup then
    pcall(_G.__FishAnimeRNG_Cleanup)
end

-- ==============================================================================
-- DEFINISI & PEMETAAN TOKO
-- ==============================================================================
local BoostOffersMap = {
    ["Cash Potion Lvl. 1"] = { key = "Offer1", currency = "Cash" },
    ["Cash Potion Lvl. 2"] = { key = "Offer2", currency = "Cash" },
    ["Cash Potion Lvl. 3"] = { key = "Offer3", currency = "Cash" },
    ["Gems Potion Lvl. 1"] = { key = "Offer4", currency = "Cash" },
    ["Gems Potion Lvl. 2"] = { key = "Offer5", currency = "Cash" },
    ["Gems Potion Lvl. 3"] = { key = "Offer6", currency = "Cash" },
    ["Mutation Potion"]     = { key = "Offer7", currency = "Cash" },
    ["Fast Catch Potion"]   = { key = "Offer8", currency = "Cash" },
    ["Luck Potion Lvl. 1"] = { key = "Offer9", currency = "Cash" },
}

local SeleneOffersMap = {
    ["Honey Potion (Cash)"]            = { key = "Offer6", currency = "Cash" },
    ["Sinister Potion (Cash)"]         = { key = "Offer7", currency = "Cash" },
    ["Meteorite Potion (Cash)"]        = { key = "Offer5", currency = "Cash" },
    ["Luck Potion Lvl. 2 (Cash)"]      = { key = "Offer4", currency = "Cash" },
    ["Food Potion Lvl. 1 (Cash)"]      = { key = "OfferFood", currency = "Cash" },
    ["Luck Potion Lvl. 3 (Gems)"]      = { key = "Offer2", currency = "Gems" },
    ["Heaven's Collide Potion (Gems)"] = { key = "Offer3", currency = "Gems" },
}

local AngeliaOffersMap = {
    ["Fast Catch Lvl. 2 (Cash)"]     = { key = "Offer6", currency = "Cash" },
    ["Crate (Cash)"]                 = { key = "Offer9", currency = "Cash" },
    ["EXE Potion (Gems)"]            = { key = "Offer8", currency = "Gems" },
    ["Luck Potion Lvl. 3 (Gems)"]    = { key = "Offer7", currency = "Gems" },
    ["Party Potion (Gems)"]          = { key = "Offer5", currency = "Gems" },
    ["Dreamer Potion (Gems)"]        = { key = "Offer4", currency = "Gems" },
    ["Cybernetic Glitch (Gems)"]     = { key = "Offer3", currency = "Gems" },
    ["Forgotten Potion (Gems)"]      = { key = "Offer1", currency = "Gems" },
    ["Backpack Storage +500 (Gems)"] = { key = "Offer2", currency = "Gems" },
}

-- ==============================================================================
-- STATE & SETTINGS
-- ==============================================================================
local Settings = {
    SelectedPond = "Main Pond (Pusat)",
    AutoFish = false,
    AutoCast = false,
    FishDelay = 0.05,
    AutoEquipBest = false,
    AutoClaim = false,
    AutoClaimQuests = false,
    AutoClaimIndex = false,
    AutoSpin = false,
    AutoRebirth = false,
    AutoSellRarity = false,
    SelectedRarities = {"Common", "Uncommon", "Rare"},
    
    AutoBuyBoosts = false,
    SelectedBoosts = {"Luck Potion Lvl. 1", "Fast Catch Potion", "Cash Potion Lvl. 1"},
    
    AutoBuySelene = false,
    SelectedSelene = {"Honey Potion (Cash)", "Meteorite Potion (Cash)", "Luck Potion Lvl. 3 (Gems)"},
    
    AutoBuyAngelia = false,
    SelectedAngelia = {"Fast Catch Lvl. 2 (Cash)", "Luck Potion Lvl. 3 (Gems)", "EXE Potion (Gems)"},

    NotifyEvent = true,
    NotifySelene = true,
    NotifyAngelia = true,

    AntiAFK = true,

    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    Noclip = false,
    PondESP = false,
    PlayerESP = false,
    Fullbright = false,
    FPSBoost = false,
    
    WebhookURL = "",
    WebhookEnabled = false,
    WebhookRarities = {
        "Exclusive", "Transcendent", "Omniscient", "God", "Ancient",
        "Celestial", "Supreme", "Divine", "Ascended", "Rainbow",
        "Secret", "Cosmic", "Mythical", "Legendary", "Epic", "Rare"
    },
    WebhookNotifyMutation = true,
    WebhookNotifyEvent = true,
    WebhookNotifySelene = true,
    WebhookNotifyAngelia = true,
    
    AutoSave = true,
}

local DefaultSettings = {
    SelectedPond = "Main Pond (Pusat)",
    AutoFish = false,
    AutoCast = false,
    FishDelay = 0.05,
    AutoEquipBest = false,
    AutoClaim = false,
    AutoClaimQuests = false,
    AutoClaimIndex = false,
    AutoSpin = false,
    AutoRebirth = false,
    AutoSellRarity = false,
    SelectedRarities = {"Common", "Uncommon", "Rare"},
    
    AutoBuyBoosts = false,
    SelectedBoosts = {"Luck Potion Lvl. 1", "Fast Catch Potion", "Cash Potion Lvl. 1"},
    
    AutoBuySelene = false,
    SelectedSelene = {"Honey Potion (Cash)", "Meteorite Potion (Cash)", "Luck Potion Lvl. 3 (Gems)"},
    
    AutoBuyAngelia = false,
    SelectedAngelia = {"Fast Catch Lvl. 2 (Cash)", "Luck Potion Lvl. 3 (Gems)", "EXE Potion (Gems)"},

    NotifyEvent = true,
    NotifySelene = true,
    NotifyAngelia = true,

    AntiAFK = true,

    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    Noclip = false,
    PondESP = false,
    PlayerESP = false,
    Fullbright = false,
    FPSBoost = false,
    
    WebhookURL = "",
    WebhookEnabled = false,
    WebhookRarities = {
        "Exclusive", "Transcendent", "Omniscient", "God", "Ancient",
        "Celestial", "Supreme", "Divine", "Ascended", "Rainbow",
        "Secret", "Cosmic", "Mythical", "Legendary", "Epic", "Rare"
    },
    WebhookNotifyMutation = true,
    WebhookNotifyEvent = true,
    WebhookNotifySelene = true,
    WebhookNotifyAngelia = true,
    
    AutoSave = true,
}

-- ==============================================================================
-- CONFIG & PERSISTENCE MANAGEMENT
-- ==============================================================================
local CONFIG_FOLDER = "SONNHUB_Config"
local CONFIG_FILE = CONFIG_FOLDER .. "/settings.json"

local ConfigKeys = {
    "SelectedPond",
    "AutoFish",
    "AutoCast",
    "FishDelay",
    "AutoEquipBest",
    "AutoClaim",
    "AutoClaimQuests",
    "AutoClaimIndex",
    "AutoSpin",
    "AutoRebirth",
    "AutoSellRarity",
    "SelectedRarities",
    "AutoBuyBoosts",
    "SelectedBoosts",
    "AutoBuySelene",
    "SelectedSelene",
    "AutoBuyAngelia",
    "SelectedAngelia",
    "NotifyEvent",
    "NotifySelene",
    "NotifyAngelia",
    "AntiAFK",
    "WalkSpeed",
    "JumpPower",
    "InfiniteJump",
    "Noclip",
    "PondESP",
    "Fullbright",
    "FPSBoost",
    "WebhookURL",
    "WebhookEnabled",
    "WebhookRarities",
    "WebhookNotifyMutation",
    "WebhookNotifyEvent",
    "WebhookNotifySelene",
    "WebhookNotifyAngelia",
    "AutoSave",
}

local UIReferences = {}
local isRestoringSettings = false
local saveDebounce = false

local function SaveSettings(notify)
    if typeof(writefile) ~= "function" then return false end
    if typeof(isfolder) == "function" and typeof(makefolder) == "function" then
        if not isfolder(CONFIG_FOLDER) then
            pcall(makefolder, CONFIG_FOLDER)
        end
    end

    local data = {}
    for _, key in ipairs(ConfigKeys) do
        data[key] = Settings[key]
    end

    local ok, encoded = pcall(function()
        return HttpService:JSONEncode(data)
    end)

    if ok and encoded then
        local success = pcall(writefile, CONFIG_FILE, encoded)
        if success and notify and WindUI then
            WindUI:Notify({
                Title = "Pengaturan Disimpan",
                Content = "Konfigurasi SONN-HUB berhasil disimpan!",
                Duration = 2.5,
                Icon = "save"
            })
        end
        return success
    end
    return false
end

local function RequestAutoSave()
    if isRestoringSettings or not Settings.AutoSave then return end
    if saveDebounce then return end
    saveDebounce = true
    task.delay(0.5, function()
        saveDebounce = false
        SaveSettings(false)
    end)
end

local function LoadSettings(notify)
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then return false end
    if not isfile(CONFIG_FILE) then return false end

    local ok, content = pcall(readfile, CONFIG_FILE)
    if not ok or not content or content == "" then return false end

    local decodeOk, loadedData = pcall(function()
        return HttpService:JSONDecode(content)
    end)

    if not decodeOk or type(loadedData) ~= "table" then return false end

    isRestoringSettings = true
    for _, key in ipairs(ConfigKeys) do
        if loadedData[key] ~= nil then
            Settings[key] = loadedData[key]
            local ui = UIReferences[key]
            if ui and ui.Element then
                pcall(function()
                    if ui.Type == "Toggle" and ui.Element.Set then
                        ui.Element:Set(loadedData[key])
                    elseif ui.Type == "Slider" and ui.Element.Set then
                        ui.Element:Set(loadedData[key])
                    elseif ui.Type == "Dropdown" and ui.Element.Select then
                        ui.Element:Select(loadedData[key])
                    elseif ui.Type == "Input" and ui.Element.Set then
                        ui.Element:Set(loadedData[key])
                    end
                end)
            end
        end
    end
    isRestoringSettings = false

    if notify and WindUI then
        WindUI:Notify({
            Title = "Pengaturan Dimuat",
            Content = "Konfigurasi SONN-HUB berhasil diterapkan!",
            Duration = 2.5,
            Icon = "download"
        })
    end
    return true
end

local function ResetSettingsToDefault()
    isRestoringSettings = true
    for _, key in ipairs(ConfigKeys) do
        local defaultVal = DefaultSettings[key]
        if defaultVal ~= nil then
            Settings[key] = defaultVal
            local ui = UIReferences[key]
            if ui and ui.Element then
                pcall(function()
                    if ui.Type == "Toggle" and ui.Element.Set then
                        ui.Element:Set(defaultVal)
                    elseif ui.Type == "Slider" and ui.Element.Set then
                        ui.Element:Set(defaultVal)
                    elseif ui.Type == "Dropdown" and ui.Element.Select then
                        ui.Element:Select(defaultVal)
                    elseif ui.Type == "Input" and ui.Element.Set then
                        ui.Element:Set(defaultVal)
                    end
                end)
            end
        end
    end
    isRestoringSettings = false
    SaveSettings(false)
end

local ESPContainers = {
    Ponds = {},
    Players = {},
}

-- Cleanup function global
_G.__FishAnimeRNG_Cleanup = function()
    Settings.AutoFish = false
    Settings.AutoCast = false
    Settings.AutoEquipBest = false
    Settings.AutoClaim = false
    Settings.AutoClaimQuests = false
    Settings.AutoClaimIndex = false
    Settings.AutoRebirth = false
    Settings.AutoSellRarity = false
    Settings.AutoBuyBoosts = false
    Settings.AutoBuySelene = false
    Settings.AutoBuyAngelia = false
    Settings.AntiAFK = false
    Settings.InfiniteJump = false
    Settings.Noclip = false
    Settings.PondESP = false
    Settings.PlayerESP = false
    Settings.Fullbright = false
    Settings.FPSBoost = false
    Settings.AutoSpin = false
    Settings.WebhookEnabled = false
    pcall(function() applyFPSBoost(false) end)

    for _, gui in pairs(ESPContainers.Ponds) do
        if gui and gui.Parent then gui:Destroy() end
    end
    for _, gui in pairs(ESPContainers.Players) do
        if gui and gui.Parent then gui:Destroy() end
    end
    ESPContainers.Ponds = {}
    ESPContainers.Players = {}
end

-- ==============================================================================
-- HELPER FUNCTIONS
-- ==============================================================================
local function formatTime(sec)
    sec = math.max(0, math.floor(sec or 0))
    local m = math.floor(sec / 60)
    local s = sec % 60
    return string.format("%02d:%02d", m, s)
end

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function teleportTo(cframeOrPos)
    local root = getRoot()
    if root then
        if typeof(cframeOrPos) == "Vector3" then
            root.CFrame = CFrame.new(cframeOrPos + Vector3.new(0, 3, 0))
        elseif typeof(cframeOrPos) == "CFrame" then
            root.CFrame = cframeOrPos + Vector3.new(0, 3, 0)
        end
    end
end

-- Koordinat presisi & aman daratan pond serta titik lempar kail
local PondSpots = {
    ["Main Pond (Pusat)"] = {
        Stand = Vector3.new(5639.8, 58.5, 1188.2),
        Target = Vector3.new(5618.1, 54.5, 1188.2),
        PartName = "PONDAREA1",
        CheckPos = Vector3.new(5617.58, 54.24, 1290.90)
    },
    ["Pond 2 / Lava Pond (Lava)"] = {
        Stand = Vector3.new(5313.5, 51.5, 1249.6),
        Target = Vector3.new(5295.0, 44.1, 1249.6),
        PartName = "PONDAREA2",
        CheckPos = Vector3.new(5273.30, 44.13, 1255.87)
    },
    ["Mountain Pond (Tinggi)"] = {
        Stand = Vector3.new(5250.0, 217.0, 1412.0),
        Target = Vector3.new(5263.4, 215.4, 1412.4),
        PartName = "PONDAREA1",
        CheckPos = Vector3.new(5263.38, 215.36, 1412.41)
    },
    ["Hill Pond (Bukit)"] = {
        Stand = Vector3.new(6100.0, 137.5, 1260.0),
        Target = Vector3.new(6093.0, 131.5, 1260.0),
        PartName = "PONDAREA1",
        CheckPos = Vector3.new(6077.05, 131.43, 1259.98)
    }
}

local function getPondPartForSpot(spot)
    if not spot then return nil end
    local pondFolder = Workspace:FindFirstChild("Scripted") and Workspace.Scripted:FindFirstChild("PondAreas")
    if not pondFolder then return nil end

    local bestPart, minDist = nil, math.huge
    for _, p in ipairs(pondFolder:GetChildren()) do
        if p:IsA("BasePart") and (not spot.PartName or p.Name == spot.PartName) then
            local dist = (p.Position - spot.CheckPos).Magnitude
            if dist < minDist then
                minDist = dist
                bestPart = p
            end
        end
    end
    return bestPart
end

local function equipBestRod()
    local char = getCharacter()
    local hum = getHumanoid()
    if not char or not hum then return nil end

    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool and currentTool:GetAttribute("IsFishingRod") then
        return currentTool
    end

    local bestRod, maxStrength = nil, -1
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, t in ipairs(backpack:GetChildren()) do
            if t:IsA("Tool") and t:GetAttribute("IsFishingRod") then
                local str = tonumber(t:GetAttribute("RodStrength")) or 0
                if str > maxStrength then
                    maxStrength = str
                    bestRod = t
                end
            end
        end
    end

    if bestRod then
        pcall(function()
            hum:EquipTool(bestRod)
        end)
        task.wait(0.25)
        return bestRod
    end
    return currentTool
end

local function getNearestPondData()
    local root = getRoot()
    if not root then return nil, nil end

    -- 1. Jika pemain sedang berada dekat spot pond tertentu (<= 45 studs)
    local bestSpot, minSpotDist = nil, math.huge
    for name, spot in pairs(PondSpots) do
        local dist = (root.Position - spot.Stand).Magnitude
        if dist < minSpotDist then
            minSpotDist = dist
            bestSpot = spot
        end
    end

    if bestSpot and minSpotDist <= 45 then
        local pPart = getPondPartForSpot(bestSpot)
        if pPart then
            return pPart, bestSpot.Target
        end
    end

    -- 2. Jika SelectedPond dipilih di menu
    local chosenSpot = PondSpots[Settings.SelectedPond]
    if chosenSpot then
        local pPart = getPondPartForSpot(chosenSpot)
        if pPart then
            return pPart, chosenSpot.Target
        end
    end

    -- 3. Fallback ke kolam terdekat di workspace
    local pondFolder = Workspace:FindFirstChild("Scripted") and Workspace.Scripted:FindFirstChild("PondAreas")
    if pondFolder then
        local nearestPart, minPartDist = nil, math.huge
        for _, pond in ipairs(pondFolder:GetChildren()) do
            if pond:IsA("BasePart") then
                local p = pond.CFrame:PointToObjectSpace(root.Position)
                local halfSize = pond.Size * 0.5
                local clampedX = math.clamp(p.X, -halfSize.X, halfSize.X)
                local clampedZ = math.clamp(p.Z, -halfSize.Z, halfSize.Z)
                local closestPoint = pond.CFrame:PointToWorldSpace(Vector3.new(clampedX, 0, clampedZ))
                local d = (root.Position - closestPoint).Magnitude
                if d < minPartDist then
                    minPartDist = d
                    nearestPart = pond
                end
            end
        end
        if nearestPart and minPartDist <= 35 then
            local dir = (nearestPart.Position - root.Position).Unit
            local castTarget = root.Position + dir * math.min(15, minPartDist + 5)
            return nearestPart, Vector3.new(castTarget.X, nearestPart.Position.Y, castTarget.Z)
        end
    end

    return nil, nil
end

-- Pengaturan Asli untuk Pemulihan FPS Boost
local originalLightingSettings = {
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
}
local originalTerrainSettings = {
    WaterWaveSize = Workspace.Terrain.WaterWaveSize,
    WaterWaveSpeed = Workspace.Terrain.WaterWaveSpeed,
    WaterReflectance = Workspace.Terrain.WaterReflectance,
}
local fpsBoostConnection = nil

local function applyFPSBoost(enable)
    if enable then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then
                    v.Enabled = false
                end
            end
        end)
        pcall(function()
            local t = Workspace.Terrain
            t.WaterWaveSize = 0
            t.WaterWaveSpeed = 0
            t.WaterReflectance = 0
        end)
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            elseif v:IsA("BasePart") then
                v.CastShadow = false
            end
        end
        if not fpsBoostConnection then
            fpsBoostConnection = Workspace.DescendantAdded:Connect(function(v)
                if Settings.FPSBoost then
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                        v.Enabled = false
                    elseif v:IsA("BasePart") then
                        v.CastShadow = false
                    end
                end
            end)
        end
    else
        if fpsBoostConnection then
            fpsBoostConnection:Disconnect()
            fpsBoostConnection = nil
        end
        pcall(function()
            Lighting.GlobalShadows = originalLightingSettings.GlobalShadows
            Lighting.FogEnd = originalLightingSettings.FogEnd
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then
                    v.Enabled = true
                end
            end
            local t = Workspace.Terrain
            t.WaterWaveSize = originalTerrainSettings.WaterWaveSize
            t.WaterWaveSpeed = originalTerrainSettings.WaterWaveSpeed
            t.WaterReflectance = originalTerrainSettings.WaterReflectance
        end)
    end
end

local function cleanMemoryAndParticles()
    local count = 0
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = false
            count = count + 1
        end
    end
    pcall(function()
        collectgarbage("collect")
    end)
    return count
end

local function getMyPlot()
    local plotsFolder = Workspace:FindFirstChild("PlayerPlots")
    if not plotsFolder then return nil end
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        if plot:GetAttribute("OwnerName") == LocalPlayer.Name or plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            return plot
        end
    end
    return nil
end

local function claimAllIndexRewards()
    local ok, res = pcall(function()
        return IndexClaimAllRewards:InvokeServer()
    end)
    pcall(function()
        local mg = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("MainGui")
        local claimAllBtn = mg and mg:FindFirstChild("IndexComponents") and mg.IndexComponents.ButtonsBottomIndex:FindFirstChild("ClaimAll")
        if claimAllBtn then
            local conns = getconnections(claimAllBtn.MouseButton1Click)
            if #conns > 0 and conns[1].Function then
                local fn = debug.getupvalues(conns[1].Function)[1]
                if typeof(fn) == "function" then
                    fn()
                end
            end
        end
    end)
    return ok, res
end

local function performAntiAFKMovement()
    local root = getRoot()
    if not root then return false end
    local origCFrame = root.CFrame

    local function sendKey(code, dur)
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, code, false, game)
        end)
        task.wait(dur or 0.15)
        pcall(function()
            VirtualInputManager:SendKeyEvent(false, code, false, game)
        end)
        task.wait(0.05)
    end

    -- Gerakan W, S, A, D untuk merefresh aktivitas pemain
    sendKey(Enum.KeyCode.W, 0.15)
    sendKey(Enum.KeyCode.S, 0.15)
    sendKey(Enum.KeyCode.A, 0.15)
    sendKey(Enum.KeyCode.D, 0.15)

    -- Kembalikan posisi awal secara presisi agar tidak bergeser dari spot mancing
    task.wait(0.1)
    if root and root.Parent and origCFrame then
        root.CFrame = origCFrame
    end
    return true
end

local AllGameRarities = {
    "Exclusive",
    "Transcendent",
    "Omniscient",
    "God",
    "Ancient",
    "Celestial",
    "Supreme",
    "Divine",
    "Ascended",
    "Rainbow",
    "Secret",
    "Cosmic",
    "Mythical",
    "Legendary",
    "Epic",
    "Rare",
    "Uncommon",
    "Common"
}

-- ==============================================================================
-- DISCORD WEBHOOK HELPER & FORMATTER
-- ==============================================================================
local function sendDiscordPayload(payload)
    local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if typeof(httpRequest) ~= "function" then
        return false, "Executor tidak mendukung fungsi HTTP request"
    end

    local encoded = nil
    local encodeOk = pcall(function()
        encoded = HttpService:JSONEncode(payload)
    end)
    if not encodeOk or not encoded then
        return false, "JSON Encode gagal"
    end

    local ok, res = pcall(function()
        return httpRequest({
            Url = Settings.WebhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = encoded
        })
    end)

    if ok and res then
        local statusCode = tonumber(res.StatusCode or res.status_code) or 200
        if statusCode >= 200 and statusCode < 300 then
            return true
        else
            return false, "Status Code " .. tostring(statusCode)
        end
    end
    return false, tostring(res or "Request gagal")
end

local function getRarityColor(rarity, mutation)
    if mutation and mutation ~= "" and mutation ~= "nil" and mutation ~= "None" then
        local m = string.lower(mutation)
        if m == "demonic" or m == "dracula" or m == "blood" then
            return 0xDD2E44 -- Crimson Red
        elseif m == "nightmare" or m == "void" then
            return 0x2B2D42 -- Dark / Obsidian
        elseif m == "electric" or m == "frozen" or m == "slime" then
            return 0x00D4FF -- Electric Cyan / Ice
        elseif m == "party" or m == "lunar" then
            return 0xE040FB -- Neon Magenta
        elseif m == "angelic" or m == "gold" then
            return 0xFFD700 -- Golden Angelic
        elseif m == "sinister" or m == "toxic" or m == "zombie" then
            return 0x2ECC71 -- Toxic / Sinister Green
        elseif m == "mars" or m == "solar" or m == "lava" then
            return 0xE67E22 -- Solar / Lava Orange
        end
        return 0xFFA500 -- Amber Orange
    end

    local r = string.lower(rarity or "")
    if r == "exclusive" then
        return 0xFFD700 -- Radiant Gold
    elseif r == "transcendent" then
        return 0xFF00FF -- Astral Magenta
    elseif r == "omniscient" then
        return 0x9400D3 -- Dark Violet
    elseif r == "god" then
        return 0xF39C12 -- God Sun Gold
    elseif r == "ancient" then
        return 0xC0392B -- Ancient Crimson
    elseif r == "celestial" then
        return 0x48CAE4 -- Celestial Cyan
    elseif r == "supreme" then
        return 0xEE5253 -- Supreme Scarlet
    elseif r == "divine" then
        return 0x9B59B6 -- Divine Purple
    elseif r == "ascended" then
        return 0x00F5D4 -- Ascended Turquoise
    elseif r == "rainbow" then
        return 0xFF6B6B -- Rainbow Coral
    elseif r == "secret" then
        return 0xFF007F -- Secret Pink / Rose
    elseif r == "cosmic" then
        return 0x7B2CBF -- Cosmic Indigo
    elseif r == "mythical" then
        return 0xFF0055 -- Mythical Ruby
    elseif r == "legendary" then
        return 0xF1C40F -- Legendary Gold
    elseif r == "epic" then
        return 0x9B5DE5 -- Epic Purple
    elseif r == "rare" then
        return 0x00BBF9 -- Rare Blue
    elseif r == "uncommon" then
        return 0x2ECC71 -- Uncommon Green
    elseif r == "common" then
        return 0xBDC3C7 -- Common Silver Gray
    end
    return 0x5865F2 -- Discord Blurple
end

local function notifyDiscordCatch(charName, charRarity, mutationType, level, chanceText)
    if not Settings.WebhookEnabled or Settings.WebhookURL == "" then return end

    local isMutation = mutationType and mutationType ~= "" and mutationType ~= "nil" and mutationType ~= "None"
    local title = isMutation and ("✨ Karakter Bermutasi: " .. mutationType .. "!") or ("🎣 Karakter Langka: " .. charRarity .. "!")

    local embedColor = getRarityColor(charRarity, isMutation and mutationType)

    local fields = {
        { name = "👤 Pemain", value = "`" .. LocalPlayer.Name .. "`", inline = true },
        { name = "🌟 Rarity", value = "**" .. charRarity .. "**", inline = true },
        { name = "🎭 Karakter", value = "**" .. charName .. "**", inline = true },
    }

    if isMutation then
        table.insert(fields, { name = "🧬 Mutasi", value = "🔥 **" .. mutationType .. "**", inline = true })
    end
    if level and level > 0 then
        table.insert(fields, { name = "📊 Level", value = "Lvl. " .. tostring(level), inline = true })
    end
    if chanceText and chanceText ~= "" then
        table.insert(fields, { name = "🎲 Peluang (Chance)", value = tostring(chanceText), inline = true })
    end

    local payload = {
        username = "SONN-HUB Notifier",
        avatar_url = "https://cdn-icons-png.flaticon.com/512/2972/2972449.png",
        embeds = {
            {
                title = title,
                description = "Karakter berhasil didapatkan dari kolam pemancingan!",
                color = embedColor,
                fields = fields,
                footer = { text = "SONN-HUB • Fish an Anime RNG" },
                timestamp = DateTime.now():ToIsoDate()
            }
        }
    }

    sendDiscordPayload(payload)
end

local function notifyDiscordEvent(eventTitle, eventDesc, durationSec)
    if not Settings.WebhookEnabled or not Settings.WebhookNotifyEvent or Settings.WebhookURL == "" then return end

    local durText = formatTime(durationSec)
    local cleanDesc = tostring(eventDesc or ""):gsub("<[^>]+>", "")

    local payload = {
        username = "SONN-HUB Notifier",
        avatar_url = "https://cdn-icons-png.flaticon.com/512/2972/2972449.png",
        embeds = {
            {
                title = "📢 " .. tostring(eventTitle),
                description = cleanDesc ~= "" and cleanDesc or "Event dunia baru telah aktif di server!",
                color = 0xFEE75C,
                fields = {
                    { name = "⏳ Durasi Event", value = "`" .. durText .. "`", inline = true },
                    { name = "🌐 Server", value = "Aktif sekarang", inline = true },
                },
                footer = { text = "SONN-HUB • Fish an Anime RNG" },
                timestamp = DateTime.now():ToIsoDate()
            }
        }
    }

    sendDiscordPayload(payload)
end

local function notifyDiscordSelene(durationSec, offersText)
    if not Settings.WebhookEnabled or not Settings.WebhookNotifySelene or Settings.WebhookURL == "" then return end

    local durText = formatTime(durationSec)
    local fields = {
        { name = "👤 Pemain", value = "`" .. LocalPlayer.Name .. "`", inline = true },
        { name = "⏳ Durasi Berjualan", value = "`" .. durText .. "`", inline = true },
        { name = "📍 Lokasi Stand", value = "Area Spawn / Pusat Pulau", inline = true },
    }

    if offersText and offersText ~= "" then
        table.insert(fields, { name = "🧪 Tawaran Ramuan", value = offersText, inline = false })
    end

    local payload = {
        username = "SONN-HUB Notifier",
        avatar_url = "https://cdn-icons-png.flaticon.com/512/2972/2972449.png",
        embeds = {
            {
                title = "🌙 NPC Selena Telah Tiba di Pulau!",
                description = "NPC Penjual Rahasia Selena telah membuka tokonya di pulau! Segera kunjungi untuk membeli potion langka sebelum tokonya tutup.",
                color = 0x9B59B6,
                fields = fields,
                footer = { text = "SONN-HUB • Toko Rahasia Selena" },
                timestamp = DateTime.now():ToIsoDate()
            }
        }
    }

    sendDiscordPayload(payload)
end

local function notifyDiscordAngelia(durationSec, offersText)
    if not Settings.WebhookEnabled or not Settings.WebhookNotifyAngelia or Settings.WebhookURL == "" then return end

    local durText = formatTime(durationSec)
    local fields = {
        { name = "👤 Pemain", value = "`" .. LocalPlayer.Name .. "`", inline = true },
        { name = "⏳ Durasi Berjualan", value = "`" .. durText .. "`", inline = true },
        { name = "📍 Lokasi", value = "Spot Acak di Peta (Gunakan Tombol TP)", inline = true },
    }

    if offersText and offersText ~= "" then
        table.insert(fields, { name = "🧪 Tawaran Eksklusif", value = offersText, inline = false })
    end

    local payload = {
        username = "SONN-HUB Notifier",
        avatar_url = "https://cdn-icons-png.flaticon.com/512/2972/2972449.png",
        embeds = {
            {
                title = "⚡ NPC Angelia Jatuh Dari Langit!",
                description = "NPC Langka Angelia telah mendarat di pulau membawa penawaran potion eksklusif tingkat tinggi!",
                color = 0x00D4FF,
                fields = fields,
                footer = { text = "SONN-HUB • Toko Misterius Angelia" },
                timestamp = DateTime.now():ToIsoDate()
            }
        }
    }

    sendDiscordPayload(payload)
end

local function sendDiscordTestNpcMessage()
    if Settings.WebhookURL == "" then
        if WindUI then
            WindUI:Notify({
                Title = "Webhook Kosong",
                Content = "Silakan masukkan URL Webhook Discord terlebih dahulu!",
                Duration = 3,
                Icon = "alert-triangle"
            })
        end
        return false
    end

    task.spawn(function()
        notifyDiscordSelene(300, "• Honey Potion (Cash)\n• Meteorite Potion (Cash)\n• Luck Potion Lvl. 3 (Gems)")
        task.wait(1)
        notifyDiscordAngelia(300, "• EXE Potion (Gems)\n• Fast Catch Lvl. 2 (Cash)\n• Luck Potion Lvl. 3 (Gems)")
    end)

    if WindUI then
        WindUI:Notify({
            Title = "Tes Webhook NPC Terkirim",
            Content = "Contoh notifikasi Selena & Angelia telah dikirim ke Discord!",
            Duration = 3.5,
            Icon = "check"
        })
    end
    return true
end

local function sendDiscordTestMessage()
    if Settings.WebhookURL == "" then
        if WindUI then
            WindUI:Notify({
                Title = "Webhook Kosong",
                Content = "Silakan masukkan URL Webhook Discord terlebih dahulu!",
                Duration = 3,
                Icon = "alert-triangle"
            })
        end
        return false
    end

    local payload = {
        username = "SONN-HUB Notifier",
        avatar_url = "https://cdn-icons-png.flaticon.com/512/2972/2972449.png",
        embeds = {
            {
                title = "✅ Uji Coba Webhook Berhasil!",
                description = "Koneksi antara **SONN-HUB** dan channel Discord Anda telah terhubung dengan sempurna.",
                color = 0x57F287,
                fields = {
                    { name = "👤 Akun Roblox", value = "`" .. LocalPlayer.Name .. "` (" .. tostring(LocalPlayer.UserId) .. ")", inline = true },
                    { name = "🎮 Game", value = "Fish an Anime RNG", inline = true },
                    { name = "⚡ Status Notifier", value = Settings.WebhookEnabled and "🟢 Aktif" or "🔴 Nonaktif", inline = true },
                },
                footer = { text = "SONN-HUB • Webhook Test" },
                timestamp = DateTime.now():ToIsoDate()
            }
        }
    }

    local success, err = sendDiscordPayload(payload)
    if success then
        if WindUI then
            WindUI:Notify({
                Title = "Pesan Terkirim",
                Content = "Pesan tes berhasil dikirim ke Discord Anda!",
                Duration = 3.5,
                Icon = "check"
            })
        end
        return true
    else
        if WindUI then
            WindUI:Notify({
                Title = "Gagal Mengirim",
                Content = "Error: " .. tostring(err or "Periksa URL webhook Anda"),
                Duration = 4,
                Icon = "x-circle"
            })
        end
        return false
    end
end

-- Deduplikasi tangkapan agar tidak terkirim ganda dari multiple events
local recentlyNotifiedCatches = {}

local function handleCatchRewardItem(item)
    if not Settings.WebhookEnabled or Settings.WebhookURL == "" then return end
    if type(item) ~= "table" then return end

    local charName = tostring(item.name or item.n or "Unknown")
    local charRarity = item.rarity or item.ra
    local mutationType = tostring(item.typeName or item.ty or "")
    local level = tonumber(item.level or item.bl) or 1

    -- Resolve rarity dari Constants jika nil atau kosong
    if not charRarity or charRarity == "" then
        pcall(function()
            local const = require(game.ReplicatedStorage:FindFirstChild("Constants"))
            if const and const.GetCharacterRarity then
                charRarity = const.GetCharacterRarity(charName)
            elseif const and const.Characters and const.Characters[charName] then
                charRarity = const.Characters[charName].Rarity
            end
        end)
    end
    charRarity = tostring(charRarity or "Common")

    -- Format chance jika ada
    local chanceText = nil
    if item.chancePercent and tonumber(item.chancePercent) then
        local cp = tonumber(item.chancePercent)
        if cp > 0 then
            local denom = math.floor(100 / cp + 0.5)
            chanceText = string.format("1 in %s (%.4f%%)", tostring(denom), cp)
        end
    elseif item.chanceExact and tonumber(item.chanceExact) then
        local ce = tonumber(item.chanceExact)
        if ce > 0 then
            local denom = math.floor(1 / ce + 0.5)
            chanceText = string.format("1 in %s", tostring(denom))
        end
    end

    -- Key deduplikasi (nama + rarity + mutasi dalam jendela ~3 detik)
    local dedupKey = string.format("%s_%s_%s_%d", charName, charRarity, mutationType, math.floor(os.clock() / 3))
    if recentlyNotifiedCatches[dedupKey] then return end
    recentlyNotifiedCatches[dedupKey] = true
    task.delay(4, function()
        recentlyNotifiedCatches[dedupKey] = nil
    end)

    -- Filter Rarity check
    local rarityMatch = false
    if type(Settings.WebhookRarities) == "table" then
        for _, r in ipairs(Settings.WebhookRarities) do
            if string.lower(r) == string.lower(charRarity) then
                rarityMatch = true
                break
            end
        end
    end

    local mutationMatch = false
    if Settings.WebhookNotifyMutation and mutationType ~= "" and mutationType ~= "nil" and mutationType ~= "None" then
        mutationMatch = true
    end

    if rarityMatch or mutationMatch then
        task.spawn(function()
            notifyDiscordCatch(charName, charRarity, mutationType, level, chanceText)
        end)
    end
end

-- 1. Listener Utama FishingState (Event resmi hasil tangkapan pancingan di game)
pcall(function()
    local fishingStateRemote = Remotes:FindFirstChild("FishingState")
    if fishingStateRemote then
        fishingStateRemote.OnClientEvent:Connect(function(data)
            if type(data) ~= "table" then return end
            if data.kind == "Completed" and type(data.rewards) == "table" then
                for _, reward in ipairs(data.rewards) do
                    if type(reward) == "table" then
                        handleCatchRewardItem(reward)
                    end
                end
            end
        end)
    end
end)

-- 2. Listener Cadangan ShowCatchReward
pcall(function()
    local showCatchRemote = Remotes:FindFirstChild("ShowCatchReward")
    if showCatchRemote then
        showCatchRemote.OnClientEvent:Connect(function(data)
            if type(data) ~= "table" then return end
            if data.name or data.rarity then
                handleCatchRewardItem(data)
            else
                for _, it in ipairs(data) do
                    if type(it) == "table" and (it.name or it.rarity) then
                        handleCatchRewardItem(it)
                    end
                end
            end
        end)
    end
end)

-- 3. Listener FishingGlobalCatch (Tangkapan langka diri sendiri)
pcall(function()
    local globalCatch = Remotes:FindFirstChild("FishingGlobalCatch")
    if globalCatch then
        globalCatch.OnClientEvent:Connect(function(data)
            if type(data) == "table" and tonumber(data.sourceUserId) == LocalPlayer.UserId then
                handleCatchRewardItem(data)
            end
        end)
    end
end)

-- 4. Listener GodCatchSequence (God Pull)
pcall(function()
    local godCatch = Remotes:FindFirstChild("GodCatchSequence")
    if godCatch then
        godCatch.OnClientEvent:Connect(function(data)
            if type(data) == "table" then
                handleCatchRewardItem(data)
            end
        end)
    end
end)

-- 5. Listener BackpackCharSummaryDelta (Karakter baru yang masuk inventaris)
pcall(function()
    local bpSummary = Remotes:FindFirstChild("BackpackCharSummaryDelta")
    if bpSummary then
        bpSummary.OnClientEvent:Connect(function(delta)
            if type(delta) ~= "table" then return end
            for k, v in pairs(delta) do
                if type(v) == "table" and v.n and v.ra then
                    handleCatchRewardItem({
                        name = v.n,
                        rarity = v.ra,
                        typeName = v.ty or "",
                        level = v.bl or 1
                    })
                end
            end
        end)
    end
end)

-- ==============================================================================
-- LOOPS & AUTOMATION
-- ==============================================================================

-- 1. Auto Fish & Auto Cast Loop (Presisi Cepat & Otomatis)
task.spawn(function()
    while true do
        if Settings.AutoFish then
            local mainGui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("MainGui")
            local fishAction = mainGui and mainGui:FindFirstChild("FishAction")
            local isUiOpen = fishAction and fishAction:GetAttribute("FishingUiOpen") == true

            if isUiOpen then
                -- Menarik kail / minigame reel dengan kecepatan tinggi
                pcall(function()
                    FishingClick:FireServer()
                end)
                task.wait(Settings.FishDelay)
            else
                -- Sedang tidak menarik ikan
                if Settings.AutoCast then
                    -- Pastikan rod terpasang otomatis
                    equipBestRod()

                    local fishBtn = fishAction and fishAction:FindFirstChild("Fish")
                    local pondPart, targetPos = getNearestPondData()

                    local castSuccess = false
                    -- 1. Lempar via FishingRequestStart langsung ke target air yang valid
                    if pondPart and targetPos then
                        local ok = pcall(function()
                            FishingRequestStart:FireServer(pondPart, targetPos)
                        end)
                        if ok then
                            castSuccess = true
                        end
                    end

                    -- 2. Fallback tombol resmi fishBtn.Activated
                    if not castSuccess and fishBtn and fishBtn.Visible and typeof(firesignal) == "function" then
                        pcall(function()
                            firesignal(fishBtn.Activated)
                        end)
                    end

                    task.wait(0.5)
                else
                    task.wait(0.2)
                end
            end
        else
            task.wait(0.5)
        end
    end
end)

-- 2. Auto Sell by Rarity Loop
task.spawn(function()
    while true do
        if Settings.AutoSellRarity and #Settings.SelectedRarities > 0 then
            for _, rarity in ipairs(Settings.SelectedRarities) do
                if not Settings.AutoSellRarity then break end
                pcall(function()
                    BackpackSellRarityRequest:InvokeServer(rarity)
                end)
                task.wait(0.8)
            end
            task.wait(4)
        else
            task.wait(2)
        end
    end
end)

-- 3. Auto Equip Best Loop
task.spawn(function()
    while true do
        if Settings.AutoEquipBest then
            pcall(function()
                BackpackEquipBest:FireServer()
            end)
            task.wait(10)
        else
            task.wait(3)
        end
    end
end)

-- 4. Auto Claim Rewards & Quests Loop
task.spawn(function()
    while true do
        if Settings.AutoClaim then
            pcall(function() ClaimDailyReward:InvokeServer() end)
            pcall(function() FishingAfkResumeClaim:InvokeServer() end)
            for i = 1, 12 do
                pcall(function() ClaimPlaytimeReward:InvokeServer(i) end)
                task.wait(0.15)
            end
            task.wait(30)
        else
            task.wait(5)
        end
    end
end)

-- 4b. Auto Claim Quests Loop
task.spawn(function()
    while true do
        if Settings.AutoClaimQuests then
            pcall(function()
                QuestClaimAll:InvokeServer()
            end)
            task.wait(8)
        else
            task.wait(3)
        end
    end
end)

-- 4c. Auto Claim Index Rewards Loop
task.spawn(function()
    while true do
        if Settings.AutoClaimIndex then
            pcall(claimAllIndexRewards)
            task.wait(10)
        else
            task.wait(3)
        end
    end
end)

-- Auto Spin Wheel Loop
task.spawn(function()
    while true do
        if Settings.AutoSpin then
            local stats = LocalPlayer:FindFirstChild("PlayerStats")
            local spinVal = stats and stats:FindFirstChild("Spin") and stats.Spin.Value or 0
            if spinVal > 0 then
                pcall(function()
                    Remotes.Spin:FireServer()
                end)
                task.wait(5.5)
            else
                task.wait(3)
            end
        else
            task.wait(2)
        end
    end
end)

-- 5. Auto Rebirth Loop (Fixed)
task.spawn(function()
    while true do
        if Settings.AutoRebirth then
            pcall(function()
                local state = RebirthGetState:InvokeServer(true)
                if state and type(state) == "table" and state.nextCost then
                    local currentCash = LocalPlayer:GetAttribute("CashNumber") or 0
                    if currentCash >= state.nextCost then
                        RebirthPurchase:InvokeServer("Cash")
                    end
                end
            end)
            task.wait(3)
        else
            task.wait(2)
        end
    end
end)

-- 6. Auto Buy Boosts & Potions (Sell NPC / Boosts Store)
task.spawn(function()
    while true do
        if Settings.AutoBuyBoosts and #Settings.SelectedBoosts > 0 then
            pcall(function()
                local state = BoostsStoreGetState:InvokeServer()
                if state and type(state) == "table" and type(state.stock) == "table" then
                    for _, name in ipairs(Settings.SelectedBoosts) do
                        if not Settings.AutoBuyBoosts then break end
                        local offer = BoostOffersMap[name]
                        if offer and (state.stock[offer.key] or 0) > 0 then
                            BoostsStorePurchase:InvokeServer(offer.key, offer.currency)
                            task.wait(0.3)
                        end
                    end
                end
            end)
            task.wait(10)
        else
            task.wait(4)
        end
    end
end)

-- 7. Auto Buy NPC Selene Store
task.spawn(function()
    while true do
        if Settings.AutoBuySelene and #Settings.SelectedSelene > 0 then
            pcall(function()
                local state = SecretStoreGetState:InvokeServer()
                if state and type(state) == "table" and state.despawnAt and state.despawnAt > 0 then
                    for _, name in ipairs(Settings.SelectedSelene) do
                        if not Settings.AutoBuySelene then break end
                        local offer = SeleneOffersMap[name]
                        if offer then
                            SecretStorePurchase:InvokeServer(offer.key, offer.currency)
                            task.wait(0.3)
                        end
                    end
                end
            end)
            task.wait(12)
        else
            task.wait(5)
        end
    end
end)

-- 8. Auto Buy NPC Angelia Store
task.spawn(function()
    while true do
        if Settings.AutoBuyAngelia and #Settings.SelectedAngelia > 0 then
            pcall(function()
                local state = SecretStore2GetState:InvokeServer()
                if state and type(state) == "table" and state.despawnAt and state.despawnAt > 0 then
                    for _, name in ipairs(Settings.SelectedAngelia) do
                        if not Settings.AutoBuyAngelia then break end
                        local offer = AngeliaOffersMap[name]
                        if offer then
                            SecretStore2Purchase:InvokeServer(offer.key, offer.currency)
                            task.wait(0.3)
                        end
                    end
                end
            end)
            task.wait(12)
        else
            task.wait(5)
        end
    end
end)

-- 9. Movement & Noclip Loop
RunService.Stepped:Connect(function()
    if Settings.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- 10. Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local hum = getHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 11. Anti-AFK Handler (Gerak W, S, A, D Tiap 5 Menit)
local VirtualUser = game:GetService("VirtualUser")
local AFK_INTERVAL = 300 -- 5 menit (300 detik)
local lastAFKMove = os.time()

LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        pcall(performAntiAFKMovement)
        lastAFKMove = os.time()
    end
end)

task.spawn(function()
    while true do
        if Settings.AntiAFK then
            local now = os.time()
            if now - lastAFKMove >= AFK_INTERVAL then
                lastAFKMove = now
                pcall(performAntiAFKMovement)
                print("[SONN-HUB] Anti-AFK: Karakter digerakkan (W, S, A, D) agar tidak terbaca idle!")
            end
            task.wait(1)
        else
            task.wait(2)
        end
    end
end)

-- ==============================================================================
-- ESP HELPERS
-- ==============================================================================
local function updatePondESP()
    for _, gui in pairs(ESPContainers.Ponds) do
        if gui and gui.Parent then gui:Destroy() end
    end
    ESPContainers.Ponds = {}

    if not Settings.PondESP then return end

    local pondFolder = Workspace:FindFirstChild("Scripted") and Workspace.Scripted:FindFirstChild("PondAreas")
    if not pondFolder then return end

    for _, pond in ipairs(pondFolder:GetChildren()) do
        if pond:IsA("BasePart") then
            local bb = Instance.new("BillboardGui")
            bb.Name = "PondESP"
            bb.Adornee = pond
            bb.Size = UDim2.fromOffset(130, 45)
            bb.AlwaysOnTop = true
            bb.StudsOffset = Vector3.new(0, 3, 0)

            local label = Instance.new("TextLabel", bb)
            label.Size = UDim2.fromScale(1, 1)
            label.BackgroundTransparency = 0.4
            label.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
            label.TextColor3 = Color3.fromRGB(80, 220, 255)
            label.TextStrokeTransparency = 0.5
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.Text = string.format("🐟 %s", pond.Name)

            local corner = Instance.new("UICorner", label)
            corner.CornerRadius = UDim.new(0, 6)

            bb.Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui
            table.insert(ESPContainers.Ponds, bb)
        end
    end
end

-- ==============================================================================
-- LOAD WINDUI
-- ==============================================================================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "SONN-HUB",
    Author = "Fish an Anime RNG",
    Icon = "fish",
    Folder = "SONNHUB_Config",
    Size = UDim2.fromOffset(630, 480),
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.RightControl,
})

-- ==============================================================================
-- TABS & ELEMENTS
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- TAB 1: AUTO FARM
-- ------------------------------------------------------------------------------
local TabFarm = Window:Tab({ Title = "Auto Farm", Icon = "sparkles" })

TabFarm:Section({ Title = "Pemancingan Otomatis (Auto Fish)" })

UIReferences["SelectedPond"] = {
    Type = "Dropdown",
    Element = TabFarm:Dropdown({
        Title = "Pilih Pond Mancing",
        Desc = "Pilih kolam pemancingan tujuan",
        Values = {
            "Main Pond (Pusat)",
            "Pond 2 / Lava Pond (Lava)",
            "Mountain Pond (Tinggi)",
            "Hill Pond (Bukit)"
        },
        Value = Settings.SelectedPond,
        Callback = function(v)
            Settings.SelectedPond = v
            RequestAutoSave()
        end
    })
}

TabFarm:Button({
    Title = "Teleport ke Pond & Mulai Mancing Otomatis",
    Desc = "Teleport ke daratan aman pond dan langsung jalankan Auto Fish & Cast",
    Callback = function()
        local spot = PondSpots[Settings.SelectedPond] or PondSpots["Main Pond (Pusat)"]
        if spot then
            teleportTo(spot.Stand)
            task.wait(0.5)
            equipBestRod()
            Settings.AutoFish = true
            Settings.AutoCast = true
            if UIReferences["AutoFish"] and UIReferences["AutoFish"].Element then
                pcall(function() UIReferences["AutoFish"].Element:Set(true) end)
            end
            if UIReferences["AutoCast"] and UIReferences["AutoCast"].Element then
                pcall(function() UIReferences["AutoCast"].Element:Set(true) end)
            end
            RequestAutoSave()

            local pondPart = getPondPartForSpot(spot)
            if pondPart and spot.Target then
                pcall(function()
                    FishingRequestStart:FireServer(pondPart, spot.Target)
                end)
            end

            if WindUI then
                WindUI:Notify({
                    Title = "Auto Fishing Aktif",
                    Content = "Tiba di " .. Settings.SelectedPond .. " & Auto Fish dimulai!",
                    Duration = 3,
                    Icon = "sparkles"
                })
            end
        end
    end
})

UIReferences["AutoFish"] = {
    Type = "Toggle",
    Element = TabFarm:Toggle({
        Title = "Auto Fish (Fast Reel)",
        Desc = "Menarik kail dan mengklik ikan otomatis dengan kecepatan tinggi",
        Value = Settings.AutoFish,
        Callback = function(v)
            Settings.AutoFish = v
            RequestAutoSave()
        end
    })
}

UIReferences["AutoCast"] = {
    Type = "Toggle",
    Element = TabFarm:Toggle({
        Title = "Auto Cast (Lempar Kail)",
        Desc = "Otomatis melempar kail ke kolam terdekat saat tidak memancing",
        Value = Settings.AutoCast,
        Callback = function(v)
            Settings.AutoCast = v
            RequestAutoSave()
        end
    })
}

UIReferences["FishDelay"] = {
    Type = "Slider",
    Element = TabFarm:Slider({
        Title = "Kecepatan Click Delay",
        Desc = "Waktu jeda antar klik saat ikan tertangkap (detik)",
        Value = { Min = 0.01, Max = 0.3, Default = Settings.FishDelay },
        Step = 0.01,
        Callback = function(v)
            Settings.FishDelay = v
            RequestAutoSave()
        end
    })
}

UIReferences["AutoEquipBest"] = {
    Type = "Toggle",
    Element = TabFarm:Toggle({
        Title = "Auto Equip Best Character",
        Desc = "Otomatis memasang karakter dengan multiplier tertinggi ke plot",
        Value = Settings.AutoEquipBest,
        Callback = function(v)
            Settings.AutoEquipBest = v
            RequestAutoSave()
        end
    })
}

TabFarm:Section({ Title = "Auto Sell Karakter" })

UIReferences["AutoSellRarity"] = {
    Type = "Toggle",
    Element = TabFarm:Toggle({
        Title = "Auto Sell Berdasarkan Rarity",
        Desc = "Menjual otomatis rarity yang dipilih agar tas tidak penuh",
        Value = Settings.AutoSellRarity,
        Callback = function(v)
            Settings.AutoSellRarity = v
            RequestAutoSave()
        end
    })
}

UIReferences["SelectedRarities"] = {
    Type = "Dropdown",
    Element = TabFarm:Dropdown({
        Title = "Pilih Rarity yang Dijual",
        Desc = "Pilih kelangkaan karakter yang ingin dijual secara otomatis",
        Multi = true,
        Values = {"Common", "Uncommon", "Rare", "Epic", "Legendary"},
        Value = Settings.SelectedRarities,
        Callback = function(selected)
            Settings.SelectedRarities = selected
            RequestAutoSave()
        end
    })
}

TabFarm:Button({
    Title = "Jual Rarity Terpilih Sekarang",
    Desc = "Menjual seluruh karakter sesuai rarity yang dicentang saat ini",
    Callback = function()
        for _, r in ipairs(Settings.SelectedRarities) do
            pcall(function()
                BackpackSellRarityRequest:InvokeServer(r)
            end)
            task.wait(0.3)
        end
        WindUI:Notify({
            Title = "Penjualan Sukses",
            Content = "Rarity terpilih telah diproses untuk dijual!",
            Duration = 3,
            Icon = "check"
        })
    end
})

-- ------------------------------------------------------------------------------
-- TAB 2: REWARDS & UPGRADES
-- ------------------------------------------------------------------------------
local TabRewards = Window:Tab({ Title = "Rewards & Quests", Icon = "gift" })

TabRewards:Section({ Title = "Quest & Hadiah Otomatis" })

UIReferences["AutoClaimQuests"] = {
    Type = "Toggle",
    Element = TabRewards:Toggle({
        Title = "Auto Claim Quests",
        Desc = "Otomatis mengklaim seluruh quest yang telah selesai",
        Value = Settings.AutoClaimQuests,
        Callback = function(v)
            Settings.AutoClaimQuests = v
            RequestAutoSave()
        end
    })
}

TabRewards:Button({
    Title = "Klaim Semua Quest Sekarang",
    Desc = "Mengambil seluruh hadiah dari quest yang selesai",
    Callback = function()
        local ok, res = pcall(function()
            return QuestClaimAll:InvokeServer()
        end)
        if ok and res and res.ok then
            WindUI:Notify({
                Title = "Quest Diklaim",
                Content = "Semua hadiah quest yang selesai telah diklaim!",
                Duration = 3,
                Icon = "award"
            })
        else
            WindUI:Notify({
                Title = "Quest",
                Content = "Tidak ada quest yang siap diklaim saat ini.",
                Duration = 3,
                Icon = "info"
            })
        end
    end
})

UIReferences["AutoClaim"] = {
    Type = "Toggle",
    Element = TabRewards:Toggle({
        Title = "Auto Claim Rewards",
        Desc = "Otomatis mengklaim Hadiah Harian, Playtime, dan AFK Reward",
        Value = Settings.AutoClaim,
        Callback = function(v)
            Settings.AutoClaim = v
            RequestAutoSave()
        end
    })
}

TabRewards:Button({
    Title = "Klaim Semua Hadiah Sekarang",
    Desc = "Mengambil Daily Rewards dan Playtime Rewards yang sudah siap",
    Callback = function()
        pcall(function() ClaimDailyReward:InvokeServer() end)
        pcall(function() FishingAfkResumeClaim:InvokeServer() end)
        for i = 1, 12 do
            pcall(function() ClaimPlaytimeReward:InvokeServer(i) end)
        end
        WindUI:Notify({
            Title = "Hadiah Diklaim",
            Content = "Semua reward yang tersedia telah diklaim!",
            Duration = 3,
            Icon = "award"
        })
    end
})

TabRewards:Section({ Title = "Index & Koleksi Hadiah" })

UIReferences["AutoClaimIndex"] = {
    Type = "Toggle",
    Element = TabRewards:Toggle({
        Title = "Auto Claim Index Rewards",
        Desc = "Otomatis mengklaim hadiah Gems saat karakter atau tipe baru terbuka di Index",
        Value = Settings.AutoClaimIndex,
        Callback = function(v)
            Settings.AutoClaimIndex = v
            RequestAutoSave()
        end
    })
}

TabRewards:Button({
    Title = "Klaim Semua Index Reward Sekarang",
    Desc = "Mengambil seluruh hadiah Gems dari Index karakter & tipe",
    Callback = function()
        local ok, res = claimAllIndexRewards()
        if ok and type(res) == "table" and res.ok then
            local count = type(res.rewards) == "table" and #res.rewards or 0
            if count > 0 then
                WindUI:Notify({
                    Title = "Index Reward Diklaim",
                    Content = string.format("Berhasil mengklaim %d hadiah Index!", count),
                    Duration = 3,
                    Icon = "sparkles"
                })
            else
                WindUI:Notify({
                    Title = "Index Reward",
                    Content = "Semua reward Index sudah terambil!",
                    Duration = 3,
                    Icon = "info"
                })
            end
        else
            WindUI:Notify({
                Title = "Index Reward",
                Content = "Semua reward Index sudah terambil!",
                Duration = 3,
                Icon = "info"
            })
        end
    end
})

TabRewards:Section({ Title = "Roda Berhadiah (Spin Wheel)" })

UIReferences["SpinStatus"] = TabRewards:Paragraph({
    Title = "Informasi Spin Wheel",
    Desc = "Memuat data spin..."
})

UIReferences["AutoSpin"] = {
    Type = "Toggle",
    Element = TabRewards:Toggle({
        Title = "Auto Spin Wheel",
        Desc = "Otomatis memutar roda berhadiah saat ada tiket spin atau saat free spin tiba",
        Value = Settings.AutoSpin,
        Callback = function(v)
            Settings.AutoSpin = v
            RequestAutoSave()
        end
    })
}

TabRewards:Button({
    Title = "Putar Spin Sekarang (Manual)",
    Desc = "Memutar roda berhadiah secara langsung 1 kali",
    Callback = function()
        local stats = LocalPlayer:FindFirstChild("PlayerStats")
        local spinVal = stats and stats:FindFirstChild("Spin") and stats.Spin.Value or 0
        if spinVal > 0 then
            pcall(function() Remotes.Spin:FireServer() end)
            if WindUI then
                WindUI:Notify({
                    Title = "Spin Wheel",
                    Content = "Memutar roda berhadiah! Sisa tiket: " .. tostring(spinVal - 1),
                    Duration = 3,
                    Icon = "loader"
                })
            end
        else
            if WindUI then
                WindUI:Notify({
                    Title = "Spin Habis",
                    Content = "Tidak ada tiket spin yang tersisa saat ini.",
                    Duration = 3,
                    Icon = "alert-circle"
                })
            end
        end
    end
})

TabRewards:Section({ Title = "Rebirth Otomatis" })

UIReferences["AutoRebirth"] = {
    Type = "Toggle",
    Element = TabRewards:Toggle({
        Title = "Auto Rebirth",
        Desc = "Otomatis melakukan Rebirth ketika syarat uang telah terpenuhi",
        Value = Settings.AutoRebirth,
        Callback = function(v)
            Settings.AutoRebirth = v
            RequestAutoSave()
        end
    })
}

TabRewards:Button({
    Title = "Rebirth Sekarang",
    Desc = "Mencoba melakukan 1x Rebirth",
    Callback = function()
        local state = nil
        pcall(function()
            state = RebirthGetState:InvokeServer(true)
        end)
        local currentCash = LocalPlayer:GetAttribute("CashNumber") or 0
        local nextCost = state and state.nextCost or 0
        
        if nextCost > 0 and currentCash >= nextCost then
            local ok, res = pcall(function()
                return RebirthPurchase:InvokeServer("Cash")
            end)
            if ok and res == true then
                WindUI:Notify({
                    Title = "Rebirth Berhasil",
                    Content = "Selamat! Anda berhasil melakukan Rebirth.",
                    Duration = 3,
                    Icon = "check"
                })
            else
                WindUI:Notify({
                    Title = "Rebirth Gagal",
                    Content = "Tidak dapat melakukan Rebirth saat ini.",
                    Duration = 3,
                    Icon = "alert-circle"
                })
            end
        else
            local costText = state and state.nextCostText or "uang belum cukup"
            WindUI:Notify({
                Title = "Uang Belum Cukup",
                Content = string.format("Dibutuhkan: $%s", tostring(costText)),
                Duration = 3,
                Icon = "info"
            })
        end
    end
})

-- ------------------------------------------------------------------------------
-- TAB 3: AUTO BUY NPC & SHOPS
-- ------------------------------------------------------------------------------
local TabShops = Window:Tab({ Title = "Auto Buy Shops", Icon = "shopping-cart" })

TabShops:Section({ Title = "Sell NPC / Boosts & Potion Store" })

UIReferences["AutoBuyBoosts"] = {
    Type = "Toggle",
    Element = TabShops:Toggle({
        Title = "Auto Buy Boosts / Potions",
        Desc = "Otomatis membeli potion dari Sell NPC menggunakan Cash saat restock",
        Value = Settings.AutoBuyBoosts,
        Callback = function(v)
            Settings.AutoBuyBoosts = v
            RequestAutoSave()
        end
    })
}

UIReferences["SelectedBoosts"] = {
    Type = "Dropdown",
    Element = TabShops:Dropdown({
        Title = "Pilih Potion yang Ingin Dibeli",
        Desc = "Pilih ramuan yang ingin otomatis dibeli setiap restock",
        Multi = true,
        Values = {
            "Cash Potion Lvl. 1",
            "Cash Potion Lvl. 2",
            "Cash Potion Lvl. 3",
            "Gems Potion Lvl. 1",
            "Gems Potion Lvl. 2",
            "Gems Potion Lvl. 3",
            "Mutation Potion",
            "Fast Catch Potion",
            "Luck Potion Lvl. 1"
        },
        Value = Settings.SelectedBoosts,
        Callback = function(selected)
            Settings.SelectedBoosts = selected
            RequestAutoSave()
        end
    })
}

TabShops:Button({
    Title = "Beli Potion Terpilih Sekarang",
    Desc = "Membeli seluruh potion terpilih yang saat ini sedang in-stock",
    Callback = function()
        local state = nil
        pcall(function() state = BoostsStoreGetState:InvokeServer() end)
        local count = 0
        if state and type(state) == "table" and type(state.stock) == "table" then
            for _, name in ipairs(Settings.SelectedBoosts) do
                local offer = BoostOffersMap[name]
                if offer and (state.stock[offer.key] or 0) > 0 then
                    local ok, res = pcall(function() return BoostsStorePurchase:InvokeServer(offer.key, offer.currency) end)
                    if ok and res == true then count = count + 1 end
                    task.wait(0.25)
                end
            end
        end
        WindUI:Notify({
            Title = "Pembelian Potion",
            Content = string.format("Berhasil membeli %d item dari toko boost!", count),
            Duration = 3,
            Icon = "package"
        })
    end
})

TabShops:Section({ Title = "NPC Selene (Secret Merchant)" })

UIReferences["AutoBuySelene"] = {
    Type = "Toggle",
    Element = TabShops:Toggle({
        Title = "Auto Buy NPC Selene",
        Desc = "Otomatis memborong item pilihan saat NPC Selene tiba di pulau",
        Value = Settings.AutoBuySelene,
        Callback = function(v)
            Settings.AutoBuySelene = v
            RequestAutoSave()
        end
    })
}

UIReferences["SelectedSelene"] = {
    Type = "Dropdown",
    Element = TabShops:Dropdown({
        Title = "Pilih Item Toko Selene",
        Desc = "Pilih item yang ingin dibeli saat Selene sedang berjualan",
        Multi = true,
        Values = {
            "Honey Potion (Cash)",
            "Sinister Potion (Cash)",
            "Meteorite Potion (Cash)",
            "Luck Potion Lvl. 2 (Cash)",
            "Food Potion Lvl. 1 (Cash)",
            "Luck Potion Lvl. 3 (Gems)",
            "Heaven's Collide Potion (Gems)"
        },
        Value = Settings.SelectedSelene,
        Callback = function(selected)
            Settings.SelectedSelene = selected
            RequestAutoSave()
        end
    })
}

TabShops:Button({
    Title = "Beli Item Selene Sekarang",
    Desc = "Membeli item terpilih jika Selene saat ini sedang berada di map",
    Callback = function()
        local count = 0
        local state = nil
        pcall(function() state = SecretStoreGetState:InvokeServer() end)
        if state and state.despawnAt and state.despawnAt > 0 then
            for _, name in ipairs(Settings.SelectedSelene) do
                local offer = SeleneOffersMap[name]
                if offer then
                    local ok, res = pcall(function() return SecretStorePurchase:InvokeServer(offer.key, offer.currency) end)
                    if ok and res == true then count = count + 1 end
                    task.wait(0.25)
                end
            end
            WindUI:Notify({
                Title = "Toko Selene",
                Content = string.format("Berhasil membeli %d item dari Selene!", count),
                Duration = 3,
                Icon = "shopping-bag"
            })
        else
            WindUI:Notify({
                Title = "Selene Belum Hadir",
                Content = "NPC Selene saat ini sedang tidak berada di pulau.",
                Duration = 3,
                Icon = "clock"
            })
        end
    end
})

TabShops:Section({ Title = "NPC Angelia (Secret Merchant 2)" })

UIReferences["AutoBuyAngelia"] = {
    Type = "Toggle",
    Element = TabShops:Toggle({
        Title = "Auto Buy NPC Angelia",
        Desc = "Otomatis memborong item pilihan saat NPC Angelia tiba di pulau",
        Value = Settings.AutoBuyAngelia,
        Callback = function(v)
            Settings.AutoBuyAngelia = v
            RequestAutoSave()
        end
    })
}

UIReferences["SelectedAngelia"] = {
    Type = "Dropdown",
    Element = TabShops:Dropdown({
        Title = "Pilih Item Toko Angelia",
        Desc = "Pilih item yang ingin dibeli saat Angelia sedang berjualan",
        Multi = true,
        Values = {
            "Fast Catch Lvl. 2 (Cash)",
            "Crate (Cash)",
            "EXE Potion (Gems)",
            "Luck Potion Lvl. 3 (Gems)",
            "Party Potion (Gems)",
            "Dreamer Potion (Gems)",
            "Cybernetic Glitch (Gems)",
            "Forgotten Potion (Gems)",
            "Backpack Storage +500 (Gems)"
        },
        Value = Settings.SelectedAngelia,
        Callback = function(selected)
            Settings.SelectedAngelia = selected
            RequestAutoSave()
        end
    })
}

TabShops:Button({
    Title = "Beli Item Angelia Sekarang",
    Desc = "Membeli item terpilih jika Angelia saat ini sedang berada di map",
    Callback = function()
        local count = 0
        local state = nil
        pcall(function() state = SecretStore2GetState:InvokeServer() end)
        if state and state.despawnAt and state.despawnAt > 0 then
            for _, name in ipairs(Settings.SelectedAngelia) do
                local offer = AngeliaOffersMap[name]
                if offer then
                    local ok, res = pcall(function() return SecretStore2Purchase:InvokeServer(offer.key, offer.currency) end)
                    if ok and res == true then count = count + 1 end
                    task.wait(0.25)
                end
            end
            WindUI:Notify({
                Title = "Toko Angelia",
                Content = string.format("Berhasil membeli %d item dari Angelia!", count),
                Duration = 3,
                Icon = "shopping-bag"
            })
        else
            WindUI:Notify({
                Title = "Angelia Belum Hadir",
                Content = "NPC Angelia saat ini sedang tidak berada di pulau.",
                Duration = 3,
                Icon = "clock"
            })
        end
    end
})

-- ------------------------------------------------------------------------------
-- TAB 4: EVENT & TIMER TRACKER (NEW!)
-- ------------------------------------------------------------------------------
local TabTracker = Window:Tab({ Title = "Event Tracker", Icon = "clock" })

TabTracker:Section({ Title = "Event Mutasi & Cuaca (World Events)" })

local EventParagraph = TabTracker:Paragraph({
    Title = "Event Mutasi: Memuat...",
    Desc = "Memeriksa status event di server..."
})

UIReferences["NotifyEvent"] = {
    Type = "Toggle",
    Element = TabTracker:Toggle({
        Title = "Notifikasi Event Baru",
        Desc = "Munculkan notifikasi pop-up ketika ada event mutasi baru dimulai",
        Value = Settings.NotifyEvent,
        Callback = function(v)
            Settings.NotifyEvent = v
            RequestAutoSave()
        end
    })
}

TabTracker:Button({
    Title = "Periksa Status Event Sekarang",
    Desc = "Mengambil data real-time status event mutasi dari server",
    Callback = function()
        local te = nil
        pcall(function() te = GetTypeEventState:InvokeServer() end)
        if te and te.active then
            WindUI:Notify({
                Title = "Event Aktif: " .. tostring(te.eventTitle or te.eventName or ""),
                Content = string.format("Sisa Waktu: %s\n%s", formatTime(te.remaining), tostring(te.eventDesc or "")),
                Duration = 6,
                Icon = "sparkles"
            })
        else
            WindUI:Notify({
                Title = "Tidak Ada Event Aktif",
                Content = "Server melakukan roll event setiap 5 menit.",
                Duration = 4,
                Icon = "info"
            })
        end
    end
})

TabTracker:Section({ Title = "Pedagang Rahasia (Secret Merchants)" })

local SeleneParagraph = TabTracker:Paragraph({
    Title = "NPC Selene: Memuat...",
    Desc = "Menghitung waktu kedatangan Selene..."
})

UIReferences["NotifySelene"] = {
    Type = "Toggle",
    Element = TabTracker:Toggle({
        Title = "Notifikasi Kedatangan Selene",
        Desc = "Memberikan notifikasi saat NPC Selene tiba di pulau",
        Value = Settings.NotifySelene,
        Callback = function(v)
            Settings.NotifySelene = v
            RequestAutoSave()
        end
    })
}

TabTracker:Button({
    Title = "Teleport ke Stand Selene",
    Desc = "Langsung menuju lokasi tempat berdirinya NPC Selene",
    Callback = function()
        teleportTo(Vector3.new(5686.79, 59.05, 1276.45))
        WindUI:Notify({
            Title = "Teleport",
            Content = "Tiba di lokasi stand Selene!",
            Duration = 2,
            Icon = "map-pin"
        })
    end
})

local AngeliaParagraph = TabTracker:Paragraph({
    Title = "NPC Angelia: Memuat...",
    Desc = "Mengecek status Angelia..."
})

UIReferences["NotifyAngelia"] = {
    Type = "Toggle",
    Element = TabTracker:Toggle({
        Title = "Notifikasi Kedatangan Angelia",
        Desc = "Memberikan notifikasi saat Angelia jatuh dari langit",
        Value = Settings.NotifyAngelia,
        Callback = function(v)
            Settings.NotifyAngelia = v
            RequestAutoSave()
        end
    })
}

TabTracker:Button({
    Title = "Teleport ke Angelia (Jika Hadir)",
    Desc = "Teleport ke posisi Angelia jika ia sedang ada di peta",
    Callback = function()
        local angModel = Workspace:FindFirstChild("Angelia", true)
        if angModel and angModel:IsA("Model") and angModel.PrimaryPart then
            teleportTo(angModel.PrimaryPart.Position)
            WindUI:Notify({
                Title = "Teleport",
                Content = "Berhasil teleport ke posisi Angelia!",
                Duration = 2,
                Icon = "zap"
            })
        else
            WindUI:Notify({
                Title = "Angelia Belum Hadir",
                Content = "NPC Angelia saat ini tidak ditemukan di peta.",
                Duration = 3,
                Icon = "alert-circle"
            })
        end
    end
})

TabTracker:Section({ Title = "Restock Toko Boosts / Potions" })

local RestockParagraph = TabTracker:Paragraph({
    Title = "Toko Potion (Sell NPC): Memuat...",
    Desc = "Menghitung waktu restock berikutnya..."
})

-- ------------------------------------------------------------------------------
-- LIVE TRACKER LOOP
-- ------------------------------------------------------------------------------
local TrackerData = {
    TypeEvent = nil,
    LastTypeActive = false,
    LastTypeEventName = "",
    SeleneState = nil,
    LastSeleneActive = false,
    AngeliaState = nil,
    LastAngeliaActive = false,
    BoostState = nil,
}

local function handleSeleneArrival(durSec, offers)
    local now = os.clock()
    if (now - (TrackerData.LastSeleneNotifiedAt or 0)) < 120 then return end
    TrackerData.LastSeleneNotifiedAt = now

    if Settings.NotifySelene then
        WindUI:Notify({
            Title = "Selena Tiba!",
            Content = string.format("NPC Selena telah tiba di pulau!\nSisa waktu: %s", formatTime(durSec)),
            Duration = 8,
            Icon = "moon"
        })
    end

    if Settings.WebhookEnabled and Settings.WebhookNotifySelene and Settings.WebhookURL ~= "" then
        task.spawn(function()
            notifyDiscordSelene(durSec, nil)
        end)
    end
end

local function handleAngeliaArrival(durSec, offers)
    local now = os.clock()
    if (now - (TrackerData.LastAngeliaNotifiedAt or 0)) < 120 then return end
    TrackerData.LastAngeliaNotifiedAt = now

    if Settings.NotifyAngelia then
        WindUI:Notify({
            Title = "Angelia Jatuh dari Langit!",
            Content = string.format("NPC Angelia telah hadir di peta!\nSisa waktu: %s", formatTime(durSec)),
            Duration = 8,
            Icon = "zap"
        })
    end

    if Settings.WebhookEnabled and Settings.WebhookNotifyAngelia and Settings.WebhookURL ~= "" then
        task.spawn(function()
            notifyDiscordAngelia(durSec, nil)
        end)
    end
end

local function handleEventNotification(eventName, eventTitle, eventDesc, durationSec)
    if not eventName or eventName == "" then return end

    if Settings.NotifyEvent then
        WindUI:Notify({
            Title = "Event Mutasi Dimulai!",
            Content = string.format("Event %s telah aktif!\nSisa: %s", tostring(eventTitle or eventName), formatTime(durationSec)),
            Duration = 7,
            Icon = "sparkles"
        })
    end

    if Settings.WebhookEnabled and Settings.WebhookNotifyEvent and Settings.WebhookURL ~= "" then
        task.spawn(function()
            notifyDiscordEvent("Event Mutasi Dimulai: " .. tostring(eventTitle or eventName), tostring(eventDesc or ""), durationSec)
        end)
    end
end

-- Listener Instan untuk Type Events dari Server
TypeEventState.OnClientEvent:Connect(function(data)
    if data and type(data) == "table" then
        local kind = tostring(data.kind or "")
        if kind == "Started" or kind == "PreStart" then
            local evName = tostring(data.eventName or "")
            local evTitle = tostring(data.eventTitle or evName)
            local evDesc = tostring(data.eventDesc or data.startDesc or "")
            local dur = tonumber(data.remaining or data.duration) or 0

            TrackerData.TypeEvent = {
                active = true,
                eventName = evName,
                eventTitle = evTitle,
                eventDesc = evDesc,
                remaining = dur
            }
            if evName ~= "" and evName ~= TrackerData.LastTypeEventName then
                TrackerData.LastTypeEventName = evName
                handleEventNotification(evName, evTitle, evDesc, dur)
            end
        elseif kind == "Bootstrap" then
            local state = data.state
            if type(state) == "table" and state.active and state.eventName then
                TrackerData.TypeEvent = state
                local evName = tostring(state.eventName or "")
                if evName ~= "" and evName ~= TrackerData.LastTypeEventName then
                    TrackerData.LastTypeEventName = evName
                    handleEventNotification(evName, state.eventTitle, state.desc or state.eventDesc, state.remaining or state.duration or 0)
                end
            else
                TrackerData.TypeEvent = nil
                TrackerData.LastTypeEventName = ""
            end
        elseif kind == "Ended" then
            TrackerData.TypeEvent = nil
            TrackerData.LastTypeEventName = ""
        end
    end
end)

-- Listener Instan untuk Kedatangan Selena & Angelia
pcall(function()
    local store1 = Remotes:FindFirstChild("SecretStoreUpdated")
    if store1 then
        store1.OnClientEvent:Connect(function(state)
            if state and type(state) == "table" and state.despawnAt and state.despawnAt > 0 then
                local remStay = math.max(0, state.despawnAt - (state.serverTime or os.time()))
                if remStay > 0 then
                    TrackerData.LastSeleneActive = true
                    handleSeleneArrival(remStay, state.offers)
                end
            end
        end)
    end
end)

pcall(function()
    local store2 = Remotes:FindFirstChild("SecretStore2Updated")
    if store2 then
        store2.OnClientEvent:Connect(function(state)
            if state and type(state) == "table" and state.despawnAt and state.despawnAt > 0 then
                local remStay = math.max(0, state.despawnAt - (state.serverTime or os.time()))
                if remStay > 0 then
                    TrackerData.LastAngeliaActive = true
                    handleAngeliaArrival(remStay, state.offers)
                end
            end
        end)
    end
end)

pcall(function()
    local chatMsg = Remotes:FindFirstChild("ChatServerMessage")
    if chatMsg then
        chatMsg.OnClientEvent:Connect(function(data)
            if data and type(data) == "table" and data.text then
                local txt = tostring(data.text)
                if txt:find("Selene has Arrived") then
                    TrackerData.LastSeleneActive = true
                    handleSeleneArrival(300, nil)
                elseif txt:find("Angelia has fallen") then
                    TrackerData.LastAngeliaActive = true
                    handleAngeliaArrival(300, nil)
                end
            end
        end)
    end
end)


-- Poller Background berkala untuk menyinkronkan data server
task.spawn(function()
    while true do
        pcall(function()
            local teState = GetTypeEventState:InvokeServer()
            if teState and type(teState) == "table" then
                if teState.active and teState.eventName then
                    TrackerData.TypeEvent = teState
                    local evName = tostring(teState.eventName or "")
                    if evName ~= "" and evName ~= TrackerData.LastTypeEventName then
                        TrackerData.LastTypeEventName = evName
                        handleEventNotification(evName, teState.eventTitle, teState.desc or teState.eventDesc, teState.remaining or teState.duration or 0)
                    end
                elseif not teState.active then
                    TrackerData.TypeEvent = nil
                    TrackerData.LastTypeEventName = ""
                end
            end

            local s1 = SecretStoreGetState:InvokeServer()
            TrackerData.SeleneState = s1
            if s1 and s1.despawnAt and s1.despawnAt > 0 then
                local remStay = math.max(0, s1.despawnAt - (s1.serverTime or os.time()))
                if remStay > 0 and not TrackerData.LastSeleneActive then
                    TrackerData.LastSeleneActive = true
                    handleSeleneArrival(remStay, s1.offers)
                end
            else
                TrackerData.LastSeleneActive = false
            end

            local s2 = SecretStore2GetState:InvokeServer()
            TrackerData.AngeliaState = s2
            if s2 and s2.despawnAt and s2.despawnAt > 0 then
                local remStay = math.max(0, s2.despawnAt - (s2.serverTime or os.time()))
                if remStay > 0 and not TrackerData.LastAngeliaActive then
                    TrackerData.LastAngeliaActive = true
                    handleAngeliaArrival(remStay, s2.offers)
                end
            else
                TrackerData.LastAngeliaActive = false
            end

            TrackerData.BoostState = BoostsStoreGetState:InvokeServer()
        end)
        task.wait(3.5)
    end
end)

-- Updater Realtime Teks Tiap Detik
task.spawn(function()
    while true do
        pcall(function()
            local serverTimeNow = Workspace:GetServerTimeNow()

            -- 1. Update Type Event
            local te = TrackerData.TypeEvent
            if te and te.active then
                local title = tostring(te.eventTitle or te.eventName or "Event Mutasi Aktif")
                local rem = te.remaining or 0
                local desc = tostring(te.eventDesc or "Meningkatkan persentase mutasi karakter!")
                EventParagraph:SetTitle("🔥 " .. title .. " [SEDANG BERLANGSUNG]")
                EventParagraph:SetDesc(string.format("Sisa Waktu: %s\nKeterangan: %s", formatTime(rem), desc))
            else
                EventParagraph:SetTitle("❄️ Tidak Ada Event Aktif")
                EventParagraph:SetDesc("Server melakukan roll acak event baru setiap 5 menit.")
            end

            -- 2. Update Selene
            local seleneRemaining = math.max(0, (math.floor((math.floor(serverTimeNow / 1800) + 1) * 1800 - serverTimeNow)))
            local s1 = TrackerData.SeleneState
            local seleneActive = s1 and s1.despawnAt and s1.despawnAt > 0
            if seleneActive then
                local remStay = math.max(0, s1.despawnAt - (s1.serverTime or os.time()))
                SeleneParagraph:SetTitle("✨ NPC Selene [SEDANG HADIR!]")
                SeleneParagraph:SetDesc(string.format("Selene sedang berjualan di pulaumu!\nBerakhir dalam: %s\nLokasi: Dekat Spawn / Toko", formatTime(remStay)))
                if not TrackerData.LastSeleneActive and Settings.NotifySelene then
                    TrackerData.LastSeleneActive = true
                    WindUI:Notify({
                        Title = "Selene Tiba!",
                        Content = "NPC Selene telah tiba di pulau! Toko rahasianya telah dibuka.",
                        Duration = 8,
                        Icon = "moon"
                    })
                end
            else
                TrackerData.LastSeleneActive = false
                SeleneParagraph:SetTitle("🌙 NPC Selene (Jadwal Tiap 30 Menit)")
                SeleneParagraph:SetDesc(string.format("Akan tiba dalam: %s\n(Tiba tepat setiap menit :00 dan :30)", formatTime(seleneRemaining)))
            end

            -- 3. Update Angelia
            local s2 = TrackerData.AngeliaState
            local angeliaActive = s2 and s2.despawnAt and s2.despawnAt > 0
            if angeliaActive then
                local remStay = math.max(0, s2.despawnAt - (s2.serverTime or os.time()))
                AngeliaParagraph:SetTitle("⚡ NPC Angelia [SEDANG HADIR!]")
                AngeliaParagraph:SetDesc(string.format("Angelia telah turun dari langit!\nBerakhir dalam: %s", formatTime(remStay)))
                if not TrackerData.LastAngeliaActive and Settings.NotifyAngelia then
                    TrackerData.LastAngeliaActive = true
                    WindUI:Notify({
                        Title = "Angelia Jatuh dari Langit!",
                        Content = "NPC Angelia telah hadir di peta! Segera kunjungi tokonya.",
                        Duration = 8,
                        Icon = "zap"
                    })
                end
            else
                TrackerData.LastAngeliaActive = false
                AngeliaParagraph:SetTitle("☁️ NPC Angelia (Kemunculan Misterius)")
                AngeliaParagraph:SetDesc("Status: Belum Hadir\n(Sistem server melakukan roll acak tiap 20 detik)")
            end

            -- 4. Update Boosts Restock
            local bs = TrackerData.BoostState
            if bs and bs.restockEndTime and bs.serverTime then
                local remRestock = math.max(0, bs.restockEndTime - bs.serverTime)
                RestockParagraph:SetTitle("🧪 Toko Potion (Sell NPC)")
                RestockParagraph:SetDesc(string.format("Restock berikutnya dalam: %s", formatTime(remRestock)))
            else
                RestockParagraph:SetTitle("🧪 Toko Potion (Sell NPC)")
                RestockParagraph:SetDesc("Status: Aktif")
            end
        end)
        task.wait(1)
    end
end)

-- ------------------------------------------------------------------------------
-- TAB 5: TELEPORTASI
-- ------------------------------------------------------------------------------
local TabTeleport = Window:Tab({ Title = "Teleport", Icon = "map-pin" })

TabTeleport:Section({ Title = "Spot Kolam Mancing (Ponds)" })

TabTeleport:Button({
    Title = "Teleport: Main Pond 1 (Pusat)",
    Desc = "Dermaga resmi kolam utama (Aman di darat)",
    Callback = function()
        teleportTo(Vector3.new(5639.8, 58.5, 1188.2))
    end
})

TabTeleport:Button({
    Title = "Teleport: Pond 2 / Lava Pond (Lava)",
    Desc = "Daratan tepi kolam lava (Aman dari void/lava)",
    Callback = function()
        teleportTo(Vector3.new(5313.5, 51.5, 1249.6))
    end
})

TabTeleport:Button({
    Title = "Teleport: Pond Dataran Tinggi (Mountain)",
    Desc = "Tepi rerumputan kolam dataran tinggi (Aman di darat)",
    Callback = function()
        teleportTo(Vector3.new(5250.0, 217.0, 1412.0))
    end
})

TabTeleport:Button({
    Title = "Teleport: Pond Bukit (Hill)",
    Desc = "Tepi bukit batu kolam bukit (Aman di darat)",
    Callback = function()
        teleportTo(Vector3.new(6100.0, 137.5, 1260.0))
    end
})

TabTeleport:Section({ Title = "Base / Plot Pribadi" })

TabTeleport:Button({
    Title = "Teleport ke Base Saya",
    Desc = "Kembali ke plot milik Anda sendiri",
    Callback = function()
        local plot = getMyPlot()
        if plot and plot:FindFirstChild("Home") then
            teleportTo(plot.Home.Position)
            WindUI:Notify({
                Title = "Teleport",
                Content = "Berhasil teleport ke Base: " .. plot.Name,
                Duration = 2,
                Icon = "home"
            })
        else
            WindUI:Notify({
                Title = "Gagal",
                Content = "Plot pribadi tidak ditemukan!",
                Duration = 3,
                Icon = "alert-circle"
            })
        end
    end
})

TabTeleport:Section({ Title = "Toko & Fasilitas Pulau" })

TabTeleport:Button({
    Title = "Teleport: Toko Pancingan (Fishing Rods)",
    Callback = function()
        teleportTo(Vector3.new(5643.10, 52, 1265.96))
    end
})

TabTeleport:Button({
    Title = "Teleport: Stand NPC Selene",
    Callback = function()
        teleportTo(Vector3.new(5686.79, 59.05, 1276.45))
    end
})

TabTeleport:Button({
    Title = "Teleport: Roda Keberuntungan (Spin Wheel)",
    Callback = function()
        teleportTo(Vector3.new(5570.68, 65, 1182.40))
    end
})

TabTeleport:Button({
    Title = "Teleport: Toko Gem (Gem Store)",
    Callback = function()
        teleportTo(Vector3.new(5642.76, 52, 1315.36))
    end
})

TabTeleport:Button({
    Title = "Teleport: Toko Upgrades",
    Callback = function()
        teleportTo(Vector3.new(5591.79, 52, 1315.64))
    end
})

TabTeleport:Button({
    Title = "Teleport: Area Jual (Sell NPC)",
    Callback = function()
        teleportTo(Vector3.new(5596.31, 63, 1270.55))
    end
})

TabTeleport:Button({
    Title = "Teleport: Clan Hub",
    Callback = function()
        teleportTo(Vector3.new(5579.12, 53, 1495.56))
    end
})

TabTeleport:Button({
    Title = "Teleport: Trade Hub",
    Callback = function()
        teleportTo(Vector3.new(5655.83, 53, 1091.40))
    end
})

-- ------------------------------------------------------------------------------
-- TAB 6: VISUALS & ESP
-- ------------------------------------------------------------------------------
local TabVisuals = Window:Tab({ Title = "Visuals & ESP", Icon = "eye" })

TabVisuals:Section({ Title = "Kinerja & Pengoptimalan FPS" })

UIReferences["FPSBoost"] = {
    Type = "Toggle",
    Element = TabVisuals:Toggle({
        Title = "FPS Boost (Potato Mode / Smooth Graphic)",
        Desc = "Menonaktifkan partikel, bayangan, dan post-effects untuk kestabilan FPS dan anti lag",
        Value = Settings.FPSBoost,
        Callback = function(v)
            Settings.FPSBoost = v
            applyFPSBoost(v)
            RequestAutoSave()
        end
    })
}

TabVisuals:Button({
    Title = "Bersihkan Memori & Partikel (Instant Boost)",
    Desc = "Membersihkan cache partikel dan menjalankan pembersihan garbage collection RAM",
    Callback = function()
        local count = cleanMemoryAndParticles()
        if WindUI then
            WindUI:Notify({
                Title = "FPS Boost Berhasil",
                Content = "Menonaktifkan " .. tostring(count) .. " partikel & membersihkan memori!",
                Duration = 3,
                Icon = "zap"
            })
        end
    end
})

TabVisuals:Section({ Title = "Tampilan Visual & ESP" })

UIReferences["PondESP"] = {
    Type = "Toggle",
    Element = TabVisuals:Toggle({
        Title = "Pond ESP (Tampilkan Kolam)",
        Desc = "Memberikan penanda visual pada seluruh area kolam pemancingan di map",
        Value = Settings.PondESP,
        Callback = function(v)
            Settings.PondESP = v
            updatePondESP()
            RequestAutoSave()
        end
    })
}

UIReferences["Fullbright"] = {
    Type = "Toggle",
    Element = TabVisuals:Toggle({
        Title = "Fullbright (Terang Maksimal)",
        Desc = "Menghilangkan kegelapan malam hari agar eksplorasi lebih nyaman",
        Value = Settings.Fullbright,
        Callback = function(v)
            Settings.Fullbright = v
            if v then
                Lighting.ClockTime = 14
                Lighting.Brightness = 2
                Lighting.FogEnd = 1e5
            else
                Lighting.ClockTime = 12
                Lighting.Brightness = 1
            end
            RequestAutoSave()
        end
    })
}

-- ------------------------------------------------------------------------------
-- TAB: DISCORD WEBHOOK
-- ------------------------------------------------------------------------------
local TabWebhook = Window:Tab({ Title = "Discord Webhook", Icon = "bell" })

TabWebhook:Section({ Title = "Konfigurasi Webhook" })

UIReferences["WebhookURL"] = {
    Type = "Input",
    Element = TabWebhook:Input({
        Title = "URL Webhook Discord",
        Desc = "Masukkan link webhook Discord dari server Anda",
        Value = Settings.WebhookURL,
        Placeholder = "https://discord.com/api/webhooks/...",
        Callback = function(v)
            Settings.WebhookURL = v
            RequestAutoSave()
        end
    })
}

UIReferences["WebhookEnabled"] = {
    Type = "Toggle",
    Element = TabWebhook:Toggle({
        Title = "Aktifkan Discord Webhook",
        Desc = "Kirim notifikasi otomatis hasil tangkapan dan event ke Discord",
        Value = Settings.WebhookEnabled,
        Callback = function(v)
            Settings.WebhookEnabled = v
            RequestAutoSave()
        end
    })
}

TabWebhook:Button({
    Title = "Kirim Pesan Tes Webhook",
    Desc = "Mengirimkan pesan uji coba untuk memastikan link webhook berfungsi",
    Callback = function()
        sendDiscordTestMessage()
    end
})

TabWebhook:Section({ Title = "Filter & Kategori Notifikasi" })

UIReferences["WebhookRarities"] = {
    Type = "Dropdown",
    Element = TabWebhook:Dropdown({
        Title = "Filter Rarity Tangkapan (18 Kelangkaan)",
        Desc = "Pilih seluruh tingkatan kelangkaan karakter yang ingin dikirimkan ke Discord",
        Values = AllGameRarities,
        Value = Settings.WebhookRarities,
        Multi = true,
        Callback = function(v)
            Settings.WebhookRarities = v
            RequestAutoSave()
        end
    })
}

TabWebhook:Button({
    Title = "Pilih Semua Kelangkaan (All 18 Rarities)",
    Desc = "Mencentang seluruh 18 tingkat kelangkaan karakter dari Common hingga Exclusive",
    Callback = function()
        Settings.WebhookRarities = table.clone(AllGameRarities)
        if UIReferences["WebhookRarities"] and UIReferences["WebhookRarities"].Element then
            UIReferences["WebhookRarities"].Element:Select(Settings.WebhookRarities)
        end
        RequestAutoSave()
        if WindUI then
            WindUI:Notify({
                Title = "Filter Webhook Diperbarui",
                Content = "Seluruh 18 kelangkaan berhasil dicentang!",
                Duration = 2.5,
                Icon = "check"
            })
        end
    end
})

TabWebhook:Button({
    Title = "Pilih Kelangkaan Langka Saja (Secret+)",
    Desc = "Mencentang hanya kelangkaan tinggi (Secret, Rainbow, Ascended hingga Exclusive)",
    Callback = function()
        Settings.WebhookRarities = {
            "Exclusive", "Transcendent", "Omniscient", "God", "Ancient",
            "Celestial", "Supreme", "Divine", "Ascended", "Rainbow", "Secret"
        }
        if UIReferences["WebhookRarities"] and UIReferences["WebhookRarities"].Element then
            UIReferences["WebhookRarities"].Element:Select(Settings.WebhookRarities)
        end
        RequestAutoSave()
        if WindUI then
            WindUI:Notify({
                Title = "Filter Webhook Diperbarui",
                Content = "Hanya kelangkaan Secret ke atas yang dicentang!",
                Duration = 2.5,
                Icon = "sparkles"
            })
        end
    end
})

UIReferences["WebhookNotifyMutation"] = {
    Type = "Toggle",
    Element = TabWebhook:Toggle({
        Title = "Notifikasi Semua Mutasi Karakter",
        Desc = "Selalu kirim notifikasi jika karakter mendapatkan mutasi (Dracula, Demonic, dll)",
        Value = Settings.WebhookNotifyMutation,
        Callback = function(v)
            Settings.WebhookNotifyMutation = v
            RequestAutoSave()
        end
    })
}

UIReferences["WebhookNotifyEvent"] = {
    Type = "Toggle",
    Element = TabWebhook:Toggle({
        Title = "Notifikasi Event Server",
        Desc = "Kirim pengumuman saat event mutasi atau cuaca baru dimulai di server",
        Value = Settings.WebhookNotifyEvent,
        Callback = function(v)
            Settings.WebhookNotifyEvent = v
            RequestAutoSave()
        end
    })
}

UIReferences["WebhookNotifySelene"] = {
    Type = "Toggle",
    Element = TabWebhook:Toggle({
        Title = "Notifikasi NPC Selena (Toko Rahasia)",
        Desc = "Kirim notifikasi ke Discord saat NPC Selena tiba di pulau membawa potion langka",
        Value = Settings.WebhookNotifySelene,
        Callback = function(v)
            Settings.WebhookNotifySelene = v
            RequestAutoSave()
        end
    })
}

UIReferences["WebhookNotifyAngelia"] = {
    Type = "Toggle",
    Element = TabWebhook:Toggle({
        Title = "Notifikasi NPC Angelia (Toko Langit)",
        Desc = "Kirim notifikasi ke Discord saat NPC Angelia jatuh dari langit membawa ramuan eksklusif",
        Value = Settings.WebhookNotifyAngelia,
        Callback = function(v)
            Settings.WebhookNotifyAngelia = v
            RequestAutoSave()
        end
    })
}

TabWebhook:Button({
    Title = "Tes Webhook NPC Selena & Angelia",
    Desc = "Kirim contoh notifikasi kedatangan NPC Selena dan Angelia ke Discord Anda",
    Callback = function()
        sendDiscordTestNpcMessage()
    end
})

-- ------------------------------------------------------------------------------
-- TAB 7: PLAYER & MOVEMENT
-- ------------------------------------------------------------------------------
local TabPlayer = Window:Tab({ Title = "Player & Misc", Icon = "user" })

TabPlayer:Section({ Title = "Karakter & Kecepatan" })

UIReferences["WalkSpeed"] = {
    Type = "Slider",
    Element = TabPlayer:Slider({
        Title = "Kecepatan Lari (WalkSpeed)",
        Value = { Min = 16, Max = 150, Default = Settings.WalkSpeed },
        Step = 1,
        Callback = function(v)
            Settings.WalkSpeed = v
            local hum = getHumanoid()
            if hum then hum.WalkSpeed = v end
            RequestAutoSave()
        end
    })
}

UIReferences["JumpPower"] = {
    Type = "Slider",
    Element = TabPlayer:Slider({
        Title = "Tinggi Lompatan (JumpPower)",
        Value = { Min = 50, Max = 250, Default = Settings.JumpPower },
        Step = 5,
        Callback = function(v)
            Settings.JumpPower = v
            local hum = getHumanoid()
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = v
            end
            RequestAutoSave()
        end
    })
}

UIReferences["InfiniteJump"] = {
    Type = "Toggle",
    Element = TabPlayer:Toggle({
        Title = "Infinite Jump",
        Desc = "Melompat di udara tanpa batas",
        Value = Settings.InfiniteJump,
        Callback = function(v)
            Settings.InfiniteJump = v
            RequestAutoSave()
        end
    })
}

UIReferences["Noclip"] = {
    Type = "Toggle",
    Element = TabPlayer:Toggle({
        Title = "Noclip (Tembus Objek)",
        Desc = "Karakter dapat berjalan menembus dinding dan rintangan",
        Value = Settings.Noclip,
        Callback = function(v)
            Settings.Noclip = v
            RequestAutoSave()
        end
    })
}

TabPlayer:Section({ Title = "Anti-AFK & Proteksi Disconnect" })

UIReferences["AntiAFK"] = {
    Type = "Toggle",
    Element = TabPlayer:Toggle({
        Title = "Anti-AFK (Gerak W,S,A,D Tiap 5 Menit)",
        Desc = "Menggerakkan karakter W, S, A, D setiap 5 menit agar tidak terbaca diam dan posisi kembali aman",
        Value = Settings.AntiAFK,
        Callback = function(v)
            Settings.AntiAFK = v
            if v then
                lastAFKMove = os.time()
                WindUI:Notify({
                    Title = "Anti-AFK Aktif",
                    Content = "Anti-AFK WASD aktif! Karakter akan digerakkan setiap 5 menit.",
                    Duration = 3,
                    Icon = "shield-check"
                })
            end
            RequestAutoSave()
        end
    })
}

TabPlayer:Button({
    Title = "Tes Gerakan Anti-AFK (WASD)",
    Desc = "Mencoba simulasi gerak W, S, A, D sekarang untuk memastikan karakter aktif bergerak",
    Callback = function()
        pcall(performAntiAFKMovement)
        WindUI:Notify({
            Title = "Tes Anti-AFK",
            Content = "Gerakan W, S, A, D berhasil disimulasikan!",
            Duration = 3,
            Icon = "check"
        })
    end
})

TabPlayer:Section({ Title = "Informasi & Kontrol GUI" })

TabPlayer:Button({
    Title = "Tutup / Sembunyikan GUI",
    Desc = "Tekan [Right Control] pada keyboard untuk membuka kembali",
    Callback = function()
        Window:Close()
    end
})

-- ------------------------------------------------------------------------------
-- TAB 8: SETTINGS & CONFIG
-- ------------------------------------------------------------------------------
local TabSettings = Window:Tab({ Title = "Config & Save", Icon = "settings" })

TabSettings:Section({ Title = "Penyimpanan Pengaturan (Persistent Config)" })

TabSettings:Paragraph({
    Title = "Status Konfigurasi",
    Desc = "Pengaturan disimpan permanen pada 'SONNHUB_Config/settings.json'. Seluruh konfigurasi fitur akan otomatis dimuat ulang saat script dijalankan kembali."
})

UIReferences["AutoSave"] = {
    Type = "Toggle",
    Element = TabSettings:Toggle({
        Title = "Auto Save Config",
        Desc = "Otomatis menyimpan ke file setiap kali Anda mengubah fitur atau opsi",
        Value = Settings.AutoSave,
        Callback = function(v)
            Settings.AutoSave = v
            RequestAutoSave()
        end
    })
}

TabSettings:Button({
    Title = "Simpan Pengaturan Sekarang (Save)",
    Desc = "Menyimpan seluruh konfigurasi aktif saat ini ke penyimpanan lokal",
    Callback = function()
        SaveSettings(true)
    end
})

TabSettings:Button({
    Title = "Muat Ulang Pengaturan (Load)",
    Desc = "Membaca kembali konfigurasi dari file penyimpanan",
    Callback = function()
        LoadSettings(true)
    end
})

TabSettings:Button({
    Title = "Reset Pengaturan ke Default",
    Desc = "Mengembalikan seluruh pilihan fitur ke kondisi awal (default)",
    Callback = function()
        ResetSettingsToDefault()
        WindUI:Notify({
            Title = "Reset Berhasil",
            Content = "Pengaturan telah dikembalikan ke kondisi default!",
            Duration = 3,
            Icon = "refresh-cw"
        })
    end
})

-- Live status updater untuk Spin Wheel
task.spawn(function()
    while true do
        pcall(function()
            if UIReferences["SpinStatus"] and UIReferences["SpinStatus"].SetDesc then
                local stats = LocalPlayer:FindFirstChild("PlayerStats")
                local spinVal = stats and stats:FindFirstChild("Spin") and stats.Spin.Value or 0
                local spinTime = stats and stats:FindFirstChild("SpinTime") and stats.SpinTime.Value or 0
                UIReferences["SpinStatus"]:SetDesc("Tiket Spin: " .. tostring(spinVal) .. " | Free Spin Berikutnya: " .. formatTime(spinTime))
            end
        end)
        task.wait(1)
    end
end)

-- Otomatis muat konfigurasi yang tersimpan sebelumnya jika ada
pcall(function()
    LoadSettings(false)
    if Settings.FPSBoost then
        applyFPSBoost(true)
    end
end)

-- Pilih tab pertama secara default
TabFarm:Select()

-- Notifikasi pembuka
WindUI:Notify({
    Title = "SONN-HUB",
    Content = "SONN-HUB Ultimate aktif! Tekan Right Ctrl untuk membuka/menutup menu.",
    Duration = 5,
    Icon = "check-circle"
})

print("[Fish an Anime RNG] SONN-HUB Loaded Successfully!")
