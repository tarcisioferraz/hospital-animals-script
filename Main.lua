-- ==========================================
-- TELA DE CARREGAMENTO (FLUTUANTE E ARRASTÁVEL)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local loadGui = Instance.new("ScreenGui")
loadGui.Name = "MiHubLoadingScreen"
loadGui.ResetOnSpawn = false
loadGui.Parent = CoreGui:FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")

local container = Instance.new("Frame")
container.Size = UDim2.new(0, 360, 0, 160)
container.Position = UDim2.new(0.5, -180, 0.5, -80)
container.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
container.BorderSizePixel = 0
container.Active = true
container.Parent = loadGui
Instance.new("UICorner", container).CornerRadius = UDim.new(0, 12)

local dragging, dragInput, dragStart, startPos
container.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = container.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
container.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local titleLoad = Instance.new("TextLabel")
titleLoad.Size = UDim2.new(1, 0, 0, 50)
titleLoad.Position = UDim2.new(0, 0, 0, 15)
titleLoad.BackgroundTransparency = 1
titleLoad.Text = "⚡ Mi Hub | Hospital Animals"
titleLoad.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLoad.Font = Enum.Font.GothamBold
titleLoad.TextSize = 18
titleLoad.Parent = container

local statusLoad = Instance.new("TextLabel")
statusLoad.Size = UDim2.new(1, 0, 0, 30)
statusLoad.Position = UDim2.new(0, 0, 0, 65)
statusLoad.BackgroundTransparency = 1
statusLoad.Text = "Iniciando script..."
statusLoad.TextColor3 = Color3.fromRGB(180, 180, 190)
statusLoad.Font = Enum.Font.Gotham
statusLoad.TextSize = 13
statusLoad.Parent = container

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 310, 0, 8)
barBg.Position = UDim2.new(0.5, -155, 0, 115)
barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
barBg.BorderSizePixel = 0
barBg.Parent = container
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
barFill.BorderSizePixel = 0
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

local function updateStatus(texto, progresso)
    statusLoad.Text = texto
    barFill.Size = UDim2.new(progresso, 0, 1, 0)
end

updateStatus("Verificando ambiente...", 0.1)

-- ==========================================
-- SISTEMA DE IDIOMAS E SELEÇÃO DE UI
-- ==========================================
local isfile = isfile or function() return false end
local readfile = readfile or function() return "" end
local writefile = writefile or function() end
local isfolder = isfolder or function() return false end
local makefolder = makefolder or function() end

local HttpService = game:GetService("HttpService")

local langMap = {
    ["English"] = "en", ["Português"] = "pt", ["Español"] = "es", ["Français"] = "fr",
    ["Deutsch"] = "de", ["Italiano"] = "it", ["Русский"] = "ru", ["中文"] = "zh",
    ["日本語"] = "ja", ["한국어"] = "ko", ["Türkçe"] = "tr", ["العربية"] = "ar",
    ["हिन्दी"] = "hi", ["Polski"] = "pl", ["Tiếng Việt"] = "vi"
}

local langNames = {
    "English", "Português", "Español", "Français", "Deutsch", "Italiano", "Русский", 
    "中文", "日本語", "한국어", "Türkçe", "العربية", "हिन्दी", "Polski", "Tiếng Việt"
}

local CurrentLang = "en"
local langFileName = "MiHub_Lang_HA.txt"
local prefUiFileName = "MiHub_UI_Pref_HA.txt"

if isfile(langFileName) then
    local saved = readfile(langFileName)
    for _, code in pairs(langMap) do
        if saved == code then CurrentLang = saved break end
    end
end

local preferredUI = "Rayfield"
if isfile(prefUiFileName) then
    local savedUi = readfile(prefUiFileName)
    local validUis = {Auto=true, Rayfield=true, WindUI=true, Orion=true, Fluent=true, Linoria=true, Vape=true, Nativa=true}
    if validUis[savedUi] then preferredUI = savedUi end
end

local Translations = {
    en = {
        Init = "[Mi Hub] Starting script...", OldDetect = "[Mi Hub] Old version detected. Closing previous interface...", WaitMap = "[Mi Hub] Waiting for map...", MapLoaded = "[Mi Hub] Map loaded!", CheckPlace = "[Mi Hub] Checking Place ID...", ExecDetect = "[Mi Hub] Executor detected: ",
        Main = "Main", ESP = "Visual ESP", Player = "Local Player", Prof = "Profiles", Custom = "Customize", Opt = "Settings",
        Insta = "Insta-Interact", InstaDesc = "Removes hold time for all prompts.", Coff = "Unlock 2nd Coffee Machine", CoffDesc = "Reveals the second machine.",
        Check = "Auto Check-In", CheckDesc = "Executes desk sequence.", Barney = "Auto Shutter Barney", BarneyDesc = "Clicks, waits 7.5s, clicks.",
        Monster = "Auto Shutter Monster Head", MonsterDesc = "Teleports and clicks NPC when close to the target position.",
        Sanity = "Infinite Sanity", SanityDesc = "Locks your sanity at 100 permanently.",
        AntiLag = "Anti-Lag (FPS Boost)", AntiLagDesc = "Disables textures, shadows and optimizes performance.",
        FullBright = "Full Bright", FullBrightDesc = "Removes darkness and shadows from the map.",
        NoFog = "No Fog", NoFogDesc = "Removes map fog completely.",
        Treat = "Auto Treatment (All Rooms)", TreatDesc = "Scans Room 1 to 5, collects items, and cures.", FixCam = "Auto Fix Cameras", FixCamDesc = "Teleports and automatically fixes broken cameras.",
        Mouse = "Unlock Mouse", MouseDesc = "Frees mouse.", Cam = "Unlock Third Person", CamDesc = "Allows camera zoom.",
        Noclip = "Noclip", NoclipDesc = "Walk through walls.", Fly = "Fly", FlyDesc = "Fly around the map.", FlySpd = "Fly Velocity", WS = "Walk Speed", JP = "Jump Power",
        SelP = "Select: Pacient", SelV = "Select: Visitor", SelA = "Select: Anomaly", MastESP = "▶ ENABLE ESP (Master)", MastDesc = "Turns on markers.",
        Theme = "Menu Theme", ThemeDesc = "Change colors.", Fill = "Fill Transparency", Out = "Outline Transparency",
        ProfName = "Profile Name", SaveProf = "💾 Save Profile", LoadProf = "📂 Load Profile", ProfMsg = "Type a name to save or load your config.",
        UiPref = "Interface Library", UiPrefDesc = "Choose your preferred menu UI (Auto-saved).",
        Togg = "Hide/Show Menu (Toggle)", ToggDesc = "Press to open/close.", Close = "❌ CLOSE SCRIPT & CLEAR", Restart = "🔄 Restart Script",
        NotifyToggle = "Press %s to open the menu again.",
        Exec = "💻 Executor", Http = "⚙️ HttpGet", Prmpt = "⚙️ Prompt", High = "⚙️ Highlight",
        Lang = "Language", LangDesc = "Change menu language (Auto-saved).", Ready = "Ready!", Loaded = "Mi Hub loaded.", NativeTitle = "  Mi Hub | Native Fallback", WarnLang = "Language saved!", WarnUI = "UI Preference saved!"
    },
    pt = {
        Init = "[Mi Hub] Iniciando script...", OldDetect = "[Mi Hub] Versão antiga detectada. Encerrando...", WaitMap = "[Mi Hub] Aguardando mapa...", MapLoaded = "[Mi Hub] Mapa carregado!", CheckPlace = "[Mi Hub] Verificando Place ID...", ExecDetect = "[Mi Hub] Executor detectado: ",
        Main = "Principal", ESP = "Visual ESP", Player = "Local Player", Prof = "Perfis", Custom = "Personalizar", Opt = "Opções",
        Insta = "Insta-Interact", InstaDesc = "Zera o tempo de todos os botões.", Coff = "Desbloquear 2ª Máquina de Café", CoffDesc = "Revela a máquina.",
        Check = "Auto Check-In", CheckDesc = "Executa sequência do balcão.", Barney = "Auto Shutter Barney", BarneyDesc = "Clica, espera 7.5s, clica.",
        Monster = "Auto Shutter Monster Head", MonsterDesc = "Teleporta e clica no NPC ao atingir a posição alvo.",
        Sanity = "Sanidade Infinita (100)", SanityDesc = "Mantém sua sanidade sempre em 100.",
        AntiLag = "Anti-Lag (Boost de FPS)", AntiLagDesc = "Desativa texturas, sombras e otimiza o jogo.",
        FullBright = "Full Bright (Iluminação Total)", FullBrightDesc = "Remove a escuridão e sombras do mapa.",
        NoFog = "Sem Névoa (No Fog)", NoFogDesc = "Remove completamente a névoa do mapa.",
        Treat = "Auto Tratamento (Salas 1-5)", TreatDesc = "Varre as salas, coleta itens e cura.", FixCam = "Auto Consertar Câmeras", FixCamDesc = "Procura pelo mapa e conserta câmeras quebradas.",
        Mouse = "Desbloquear Mouse", MouseDesc = "Solta o mouse.", Cam = "Desbloquear 3ª Pessoa", CamDesc = "Permite afastar a câmera.",
        Noclip = "Atravessar Paredes (Noclip)", NoclipDesc = "Ignore colisões.", Fly = "Voar (Fly)", FlyDesc = "Voe pelo mapa.", FlySpd = "Velocidade do Voo", WS = "Velocidade (WalkSpeed)", JP = "Pulo (JumpPower)",
        SelP = "Selecionar: Pacient", SelV = "Selecionar: Visitor", SelA = "Selecionar: Anomaly", MastESP = "▶ ATIVAR ESP (Master)", MastDesc = "Liga as marcações.",
        Theme = "Tema do Menu", ThemeDesc = "Altere as cores.", Fill = "Transparência Preenchimento", Out = "Transparência Borda",
        ProfName = "Nome do Perfil", SaveProf = "💾 Salvar Perfil", LoadProf = "📂 Carregar Perfil", ProfMsg = "Digite o nome para salvar ou carregar as configs.",
        UiPref = "Biblioteca de Interface", UiPrefDesc = "Escolha sua GUI preferida (Salvo automaticamente).",
        Togg = "Esconder/Mostrar Menu", ToggDesc = "Aperte para abrir/fechar.", Close = "❌ FECHAR SCRIPT E LIMPAR", Restart = "🔄 Reiniciar Script",
        NotifyToggle = "Pressione %s para abrir o menu novamente.",
        Exec = "💻 Executor", Http = "⚙️ HttpGet", Prmpt = "⚙️ Prompt", High = "⚙️ Highlight",
        Lang = "Idioma", LangDesc = "Muda o idioma (Salvo automaticamente).", Ready = "Pronto!", Loaded = "Mi Hub carregado.", NativeTitle = "  Mi Hub | Fallback Nativo", WarnLang = "Idioma salvo!", WarnUI = "Preferência de UI salva!"
    }
}
setmetatable(Translations, {__index = function(t,k) return t["en"] end})
local function T(key) return Translations[CurrentLang] and Translations[CurrentLang][key] or Translations["en"][key] or key end

updateStatus("Lendo configurações e perfis...", 0.3)

-- ==========================================
-- GERENCIADOR DE CONFIGURAÇÕES E PERFIS
-- ==========================================
local ConfigsFolder = "MiHub_Configs"
if makefolder and not isfolder(ConfigsFolder) then makefolder(ConfigsFolder) end

local CurrentSettings = {
    Insta = false, Coff = false, FixCam = false, Check = false, Barney = false, Monster = false, Sanity = false, AntiLag = false, FullBright = false, NoFog = false, Treat = false,
    Noclip = false, Fly = false, FlySpd = 50, WS = 16, JP = 50, Mouse = false, Cam = false,
    SelP = false, SelV = false, SelA = false, MastESP = false, Fill = 0.75, Out = 0
}

local function SaveConfig(profileName)
    if writefile and profileName ~= "" then
        local data = HttpService:JSONEncode(CurrentSettings)
        writefile(ConfigsFolder .. "/" .. profileName .. "_HA.json", data)
    end
end

-- ==========================================
-- VERIFICAÇÕES DO JOGO
-- ==========================================
local globalEnv = getgenv and getgenv() or _G
if globalEnv.CloseMiHubHospitalAnimals then pcall(function() globalEnv.CloseMiHubHospitalAnimals() end) end
if not game:IsLoaded() then game.Loaded:Wait() end

local PLACE_ID_PERMITIDO = 104522435597696
if game.PlaceId ~= PLACE_ID_PERMITIDO then
    local LocalPlayer = game:GetService("Players").LocalPlayer
    if LocalPlayer then LocalPlayer:Kick("❌ Script Bloqueado ❌\nWrong Game / Jogo Incorreto.") end
    return
end

local executorName = "Unknown"
local executorVersion = "N/A"
if identifyexecutor then
    local name, ver = identifyexecutor()
    executorName = name or "Unknown"
    executorVersion = ver or "N/A"
elseif getexecutorname then executorName = getexecutorname() end

local function checkComp(fn) return fn ~= nil and "OK" or "N/A" end
local compPrompt = checkComp(fireproximityprompt)
local compHttp = checkComp(game and game.HttpGet)
local compLoad = checkComp(loadstring)
local compHighlight = pcall(function() local h = Instance.new("Highlight") h:Destroy() end) and "OK" or "N/A"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- ==========================================
-- VARIÁVEIS GERAIS
-- ==========================================
local getAutoCheckIn, getAutoShutterBarney, getAutoMonster, getInfiniteSanity, getAntiLag, getFullBright, getNoFog, getAutoTreatment, getAutoFixCameras = false, false, false, false, false, false, false, false, false
local mouseConnection, cameraConnection
local currentToggleKey = Enum.KeyCode.RightShift

local posicoes = {
    Form           = CFrame.new(-104, 3, 0), Camera         = CFrame.new(-108, 3, 0),
    Computer       = CFrame.new(-100, 3, 0), PrinterPapel   = CFrame.new(-100, 3, 2), 
    NPC            = CFrame.new(-103, 3, -6), EsperaBase     = CFrame.new(-104, 3, 0),
    Shutter        = CFrame.new(-113, 3, -2)
}
local posicaoAlvoNPC = Vector3.new(-103.9, 2.3, -7.1)

-- ==========================================
-- SISTEMA LOCAL PLAYER & OTIMIZAÇÕES
-- ==========================================
local noclipEnabled, noclipConnection = false, nil
local flyEnabled, flyConnection = false, nil
local bodyVel, bodyGyro

local function toggleNoclip(Value)
    noclipEnabled = Value CurrentSettings.Noclip = Value
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    end
end

local function toggleFly(Value)
    flyEnabled = Value CurrentSettings.Fly = Value
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if flyEnabled and hrp then
        bodyVel = Instance.new("BodyVelocity") bodyVel.MaxForce = Vector3.new(100000, 100000, 100000) bodyVel.Velocity = Vector3.zero bodyVel.Parent = hrp
        bodyGyro = Instance.new("BodyGyro") bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000) bodyGyro.CFrame = hrp.CFrame bodyGyro.Parent = hrp
        if char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = true end
        flyConnection = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
            if bodyVel then bodyVel.Velocity = moveDir * CurrentSettings.FlySpd end
            if bodyGyro then bodyGyro.CFrame = cam.CFrame end
        end)
    else
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        if bodyVel then bodyVel:Destroy() bodyVel = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        if char and char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
    end
end

local function setWalkSpeed(Value) CurrentSettings.WS = Value local char = LocalPlayer.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = Value end end
local function setJumpPower(Value) CurrentSettings.JP = Value local char = LocalPlayer.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid.UseJumpPower = true char.Humanoid.JumpPower = Value end end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if CurrentSettings.Fly then toggleFly(false) toggleFly(true) end
    if CurrentSettings.WS ~= 16 then setWalkSpeed(CurrentSettings.WS) end
    if CurrentSettings.JP ~= 50 then setJumpPower(CurrentSettings.JP) end
end)

-- ==========================================
-- FUNÇÃO INFINITE SANITY
-- ==========================================
local sanityConnection, sanityAttributeConn
local function loopInfiniteSanity(Value)
    getInfiniteSanity = Value CurrentSettings.Sanity = Value
    local success, Library = pcall(function() return require(ReplicatedStorage:WaitForChild("Lib", 2)) end)
    local function keepSanityFull() if getInfiniteSanity then LocalPlayer:SetAttribute("Sanity", 100) end end
    if getInfiniteSanity then
        if success and Library and typeof(Library.Inject) == "function" then pcall(function() Library.Inject("PlayerLostSanity", keepSanityFull) end) end
        sanityAttributeConn = LocalPlayer:GetAttributeChangedSignal("Sanity"):Connect(keepSanityFull)
        sanityConnection = RunService.RenderStepped:Connect(keepSanityFull)
        keepSanityFull()
    else
        if sanityConnection then sanityConnection:Disconnect() sanityConnection = nil end
        if sanityAttributeConn then sanityAttributeConn:Disconnect() sanityAttributeConn = nil end
    end
end

-- ==========================================
-- ANTI-LAG COM RESTAURAÇÃO TOTAL AO DESATIVAR
-- ==========================================
local originalObjectsData = {}
local function toggleAntiLag(Value)
    getAntiLag = Value CurrentSettings.AntiLag = Value
    if getAntiLag then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    if not originalObjectsData[v] then
                        originalObjectsData[v] = { Material = v.Material, Reflectance = v.Reflectance }
                    end
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    if not originalObjectsData[v] then
                        originalObjectsData[v] = { Transparency = v.Transparency }
                    end
                    v.Transparency = 1
                end
            end
        end)
    else
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            Lighting.GlobalShadows = true
            for obj, data in pairs(originalObjectsData) do
                if obj and obj.Parent then
                    if obj:IsA("BasePart") then
                        obj.Material = data.Material or Enum.Material.Plastic
                        obj.Reflectance = data.Reflectance or 0
                    elseif obj:IsA("Decal") or obj:IsA("Texture") then
                        obj.Transparency = data.Transparency or 0
                    end
                end
            end
            table.clear(originalObjectsData)
        end)
    end
end

local originalLighting = { Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows }
local function toggleFullBright(Value)
    getFullBright = Value CurrentSettings.FullBright = Value
    if getFullBright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = originalLighting.Brightness
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.GlobalShadows = originalLighting.GlobalShadows
    end
end

local function toggleNoFog(Value)
    getNoFog = Value CurrentSettings.NoFog = Value
    if getNoFog then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = originalLighting.FogEnd
    end
end

-- ==========================================
-- OUTRAS FUNÇÕES DE AUTOMATIZAÇÃO
-- ==========================================
local function teleportarEClicarComVerificacao(pasta, cframeExato)
    if not pasta then return end
    for _, obj in pairs(pasta:GetChildren()) do
        if obj.Name == "PP" and obj:IsA("ProximityPrompt") then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local sucesso = false local tentativas = 0
                while not sucesso and tentativas < 3 do
                    character:PivotTo(cframeExato) task.wait(0.3)
                    if fireproximityprompt then local ok = pcall(function() fireproximityprompt(obj, obj.HoldDuration or 0) end) if ok then sucesso = true end end
                    tentativas = tentativas + 1 task.wait(0.2)
                end
            end
        end
    end
end

local function getSafeCFrame(obj)
    if not obj then return nil end
    if obj:IsA("Model") then return obj:GetPivot() elseif obj:IsA("BasePart") then return obj.CFrame else
        local part = obj:FindFirstChildWhichIsA("BasePart", true) if part then return part.CFrame end
    end return nil
end

local espMasterEnabled, espFillTransparency, espOutlineTransparency = false, 0.75, 0
local selectedESP = { Pacient = false, Visitor = false, Anomaly = false }
local espObjects = {}

local function updateESPVisuals() for _, data in pairs(espObjects) do if data.highlight then data.highlight.FillTransparency = espFillTransparency data.highlight.OutlineTransparency = espOutlineTransparency end end end
local function removeESP(npc) if espObjects[npc] then if espObjects[npc].highlight then espObjects[npc].highlight:Destroy() end if espObjects[npc].billboard then espObjects[npc].billboard:Destroy() end espObjects[npc] = nil end end
local function clearAllESP() for npc, _ in pairs(espObjects) do removeESP(npc) end end
local function updateESPTargets() for npc, data in pairs(espObjects) do if not selectedESP[data.type] then removeESP(npc) end end end
local function toggleMasterESP(Value) espMasterEnabled = Value CurrentSettings.MastESP = Value if not espMasterEnabled then clearAllESP() end end

local instaInteractEnabled, originalHoldDurations = false, {}
local function applyInstaInteract(prompt) if prompt:IsA("ProximityPrompt") then if originalHoldDurations[prompt] == nil then originalHoldDurations[prompt] = prompt.HoldDuration end prompt.HoldDuration = 0 end end
local function toggleInstaInteract(Value)
    instaInteractEnabled = Value CurrentSettings.Insta = Value
    if instaInteractEnabled then for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("ProximityPrompt") then applyInstaInteract(obj) end end
    else for prompt, duration in pairs(originalHoldDurations) do pcall(function() if prompt and prompt.Parent then prompt.HoldDuration = duration end end) end table.clear(originalHoldDurations) end
end
local instaInteractConnection = workspace.DescendantAdded:Connect(function(descendant) if instaInteractEnabled and descendant:IsA("ProximityPrompt") then task.defer(function() applyInstaInteract(descendant) end) end end)

local function toggleCoffeeMachine(Value)
    CurrentSettings.Coff = Value local repMisc = game:GetService("ReplicatedStorage"):FindFirstChild("Misc")
    if Value then if repMisc and repMisc:FindFirstChild("CoffeeMachine2") then repMisc.CoffeeMachine2.Parent = workspace end
    else local coffee = workspace:FindFirstChild("CoffeeMachine2") if coffee and repMisc then coffee.Parent = repMisc end end
end

local function loopAutoCheckIn(Value)
    getAutoCheckIn = Value CurrentSettings.Check = Value
    if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.Anchored = false end
    if getAutoCheckIn then
        task.spawn(function()
            while getAutoCheckIn do
                pcall(function()
                    local character = LocalPlayer.Character local npcs = workspace:FindFirstChild("NPCs") local npcNaFila = false
                    local movePoints = workspace:FindFirstChild("MovePoints") or workspace:FindFirstChild("MovePoints", true)
                    if movePoints and npcs then
                        local checkInPoint = movePoints:FindFirstChild("checkIn") or movePoints:FindFirstChild("CheckIn")
                        if checkInPoint then local pCoord = getSafeCFrame(checkInPoint) if pCoord then for _, npc in pairs(npcs:GetChildren()) do if npc.Name ~= "Barney" and npc.Name ~= "Doctor" then local hrp = npc:FindFirstChild("HumanoidRootPart") if hrp and (hrp.Position - pCoord.Position).Magnitude <= 4 then npcNaFila = true break end end end end end
                    end
                    if npcNaFila then
                        local checkIn = workspace.Misc:FindFirstChild("CheckIn")
                        if checkIn then
                            teleportarEClicarComVerificacao(checkIn:FindFirstChild("Form"), posicoes.Form) teleportarEClicarComVerificacao(checkIn:FindFirstChild("Camera"), posicoes.Camera)
                            teleportarEClicarComVerificacao(checkIn:FindFirstChild("Computer"), posicoes.Computer) teleportarEClicarComVerificacao(checkIn:FindFirstChild("Printer"), posicoes.PrinterPapel)
                            for _, child in pairs(checkIn:GetChildren()) do if child.Name == "PrintedBadge" then teleportarEClicarComVerificacao(child, posicoes.PrinterPapel) end end
                        end
                        if npcs then for _, npc in pairs(npcs:GetChildren()) do if npc.Name ~= "Barney" and npc.Name ~= "Doctor" then for _, obj in pairs(npc:GetDescendants()) do if obj.Name == "PP" and obj:IsA("ProximityPrompt") and character and character:FindFirstChild("HumanoidRootPart") then local sClick = false while not sClick do character:PivotTo(posicoes.NPC) task.wait(0.2) local ok = pcall(function() fireproximityprompt(obj, obj.HoldDuration or 0) end) if ok then sClick = true end task.wait(0.2) end end end end end end
                        if character and character:FindFirstChild("HumanoidRootPart") then character:PivotTo(posicoes.EsperaBase) end
                    end
                end) task.wait(0.5)
            end
        end)
    end
end

local function autoShutterBarney(Value)
    getAutoShutterBarney = Value CurrentSettings.Barney = Value
    if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.Anchored = false end
    if getAutoShutterBarney then
        task.spawn(function()
            while getAutoShutterBarney do
                pcall(function()
                    local character = LocalPlayer.Character local distBarney = math.huge local npcsFolder = workspace:FindFirstChild("NPCs")
                    if npcsFolder then for _, npc in pairs(npcsFolder:GetChildren()) do if npc.Name == "Barney" then local hrp = npc:FindFirstChild("HumanoidRootPart") if hrp then distBarney = (hrp.Position - posicaoAlvoNPC).Magnitude end end end end
                    if distBarney <= 4 then
                        local hrpPlayer = character and character:FindFirstChild("HumanoidRootPart") if hrpPlayer then hrpPlayer.Anchored = true end
                        local miscFolder = workspace:FindFirstChild("Misc")
                        if miscFolder and miscFolder:FindFirstChild("ShutterButton") then
                            local pp = miscFolder.ShutterButton:FindFirstChild("PP")
                            if pp and pp:IsA("ProximityPrompt") and character then
                                teleportarEClicarComVerificacao(miscFolder.ShutterButton, posicoes.Shutter) task.wait(7.5)
                                teleportarEClicarComVerificacao(miscFolder.ShutterButton, posicoes.Shutter)
                            end
                        end
                        if character and hrpPlayer then character:PivotTo(posicoes.EsperaBase) end
                    end
                end) task.wait(0.5)
            end
        end)
    end
end

local function loopAutoMonster(Value)
    getAutoMonster = Value CurrentSettings.Monster = Value
    if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.Anchored = false end
    if getAutoMonster then
        task.spawn(function()
            while getAutoMonster do
                pcall(function()
                    local character = LocalPlayer.Character if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                    local targetPos = Vector3.new(-92.5990677, 2.41605258, 3.09965658) local npcsFolder = workspace:FindFirstChild("NPCs")
                    if npcsFolder then
                        for _, npc in pairs(npcsFolder:GetChildren()) do
                            local hrp = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart")
                            if hrp and (hrp.Position - targetPos).Magnitude <= 0.5 then
                                character:PivotTo(hrp.CFrame + Vector3.new(0, 2, 0)) task.wait(0.3)
                                for _, prompt in pairs(npc:GetDescendants()) do if prompt.Name == "PP" and prompt:IsA("ProximityPrompt") then pcall(function() fireproximityprompt(prompt, prompt.HoldDuration or 0) end) end end
                                task.wait(1)
                            end
                        end
                    end
                end) task.wait(0.5)
            end
        end)
    end
end

local function loopAutoTreatment(Value)
    getAutoTreatment = Value CurrentSettings.Treat = Value
    if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.Anchored = false end
    if getAutoTreatment then
        task.spawn(function()
            while getAutoTreatment do
                pcall(function()
                    local character = LocalPlayer.Character if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                    local medicalRooms = workspace:FindFirstChild("Rooms") and workspace.Rooms:FindFirstChild("Medical")
                    if medicalRooms then
                        for i = 1, 5 do
                            local room = medicalRooms:FindFirstChild("Room" .. i)
                            if room and room:FindFirstChild("Minigame") then
                                local minigame = room.Minigame local bed = minigame:FindFirstChild("Bed") local bedInBed = bed and bed:FindFirstChild("InBed")
                                local analyzer = minigame:FindFirstChild("Analyzer") local monitor = minigame:FindFirstChild("Monitor") local tv = minigame:FindFirstChild("TV")
                                local bedPart = bed and (bed:FindFirstChildWhichIsA("BasePart", true)) local pacienteNessaSala = nil
                                if bedPart then
                                    local npcs = workspace:FindFirstChild("NPCs")
                                    if npcs then for _, npc in pairs(npcs:GetChildren()) do if npc.Name ~= "Barney" and npc.Name ~= "Doctor" then local hrp = npc:FindFirstChild("HumanoidRootPart") if hrp and (hrp.Position - bedPart.Position).Magnitude <= 3.5 then pacienteNessaSala = npc break end end end end
                                end
                                if pacienteNessaSala then
                                    local charHrpCoord = getSafeCFrame(pacienteNessaSala) if charHrpCoord then character:PivotTo(charHrpCoord) end task.wait(0.5)
                                    for _, prompt in pairs(pacienteNessaSala:GetDescendants()) do if prompt:IsA("ProximityPrompt") then pcall(function() fireproximityprompt(prompt, prompt.HoldDuration or 0) end) end end task.wait(1)
                                    if analyzer then local anCoord = getSafeCFrame(analyzer) if anCoord then character:PivotTo(anCoord) end task.wait(0.5) for _, prompt in pairs(analyzer:GetDescendants()) do if prompt:IsA("ProximityPrompt") then pcall(function() fireproximityprompt(prompt, prompt.HoldDuration or 0) end) end end task.wait(1) end
                                    if monitor then local coordMonitor = getSafeCFrame(monitor) if coordMonitor then character:PivotTo(coordMonitor) end task.wait(0.5) local mPP2 = monitor:FindFirstChild("PP2", true) if mPP2 and mPP2:IsA("ProximityPrompt") then pcall(function() fireproximityprompt(mPP2, mPP2.HoldDuration or 0) end) end task.wait(10) end
                                    local invFolder = tv and tv:FindFirstChild("Screen") and tv.Screen:FindFirstChild("UI") and tv.Screen.UI:FindFirstChild("Report") and tv.Screen.UI.Report:FindFirstChild("inv")
                                    if invFolder then
                                        local itemsParaEntregar = {}
                                        for _, child in ipairs(invFolder:GetChildren()) do
                                            if not child:IsA("UIGridLayout") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                                                local tName = child:FindFirstChild("name", true) or child:FindFirstChild("Name", true)
                                                if tName and tName:IsA("TextLabel") and tName.Text ~= "" then table.insert(itemsParaEntregar, tName.Text) else table.insert(itemsParaEntregar, child.Name) end
                                            end
                                        end
                                        if #itemsParaEntregar > 0 then
                                            for _, itemName in ipairs(itemsParaEntregar) do
                                                local itemEncontrado, promptEncontrado = nil, nil
                                                for _, obj in ipairs(workspace:GetChildren()) do
                                                    if obj.Name == "Model" then
                                                        local pastaItens = obj:FindFirstChild("Items") or obj:FindFirstChild("Itens")
                                                        if pastaItens and pastaItens:FindFirstChild(itemName) then
                                                            itemEncontrado = pastaItens:FindFirstChild(itemName) promptEncontrado = itemEncontrado:FindFirstChildWhichIsA("ProximityPrompt", true)
                                                            if promptEncontrado then break end
                                                        end
                                                    end
                                                end
                                                if itemEncontrado and promptEncontrado then local cAlvo = getSafeCFrame(itemEncontrado) if cAlvo then character:PivotTo(cAlvo) task.wait(0.5) pcall(function() fireproximityprompt(promptEncontrado, promptEncontrado.HoldDuration or 0) end) task.wait(1) end end
                                                if bedInBed then
                                                    local cBed = getSafeCFrame(bedInBed)
                                                    if cBed then
                                                        character:PivotTo(cBed) task.wait(0.5)
                                                        local bPP = bedInBed:FindFirstChild("PP") or bedInBed:FindFirstChildWhichIsA("ProximityPrompt", true)
                                                        local entregue = false local tLim = tick() + 10
                                                        while not entregue and tick() < tLim do
                                                            if bPP and bPP.Parent then if bPP.Enabled == false then entregue = true else pcall(function() fireproximityprompt(bPP, bPP.HoldDuration or 0) end) end else entregue = true end
                                                            task.wait(0.4)
                                                        end
                                                    end
                                                end
                                            end
                                            task.wait(3)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end) task.wait(1)
            end
        end)
    end
end

local function loopAutoFixCameras(Value)
    getAutoFixCameras = Value CurrentSettings.FixCam = Value
    if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.Anchored = false end
    if getAutoFixCameras then
        task.spawn(function()
            while getAutoFixCameras do
                pcall(function()
                    local character = LocalPlayer.Character if character and character:FindFirstChild("HumanoidRootPart") then
                        for _, objeto in ipairs(workspace:GetDescendants()) do
                            if not getAutoFixCameras then break end
                            if objeto:IsA("ProximityPrompt") then
                                local nome = string.lower(objeto.Name) local tAcao = string.lower(objeto.ActionText) local tObj = string.lower(objeto.ObjectText)
                                if string.find(nome, "fix cam") or string.find(tAcao, "fix cam") or string.find(tObj, "fix cam") then
                                    local cAlvo = getSafeCFrame(objeto.Parent) if cAlvo then character:PivotTo(cAlvo) task.wait(0.5) pcall(function() fireproximityprompt(objeto, objeto.HoldDuration or 0) end) task.wait(1.5) end
                                end
                            end
                        end
                    end
                end) task.wait(2)
            end
        end)
    end
end

local function toggleDesbloquearMouse(Value)
    CurrentSettings.Mouse = Value
    if Value then
        mouseConnection = RunService.RenderStepped:Connect(function()
            local sDireito = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
            if not sDireito then UserInputService.MouseBehavior = Enum.MouseBehavior.Default end
            UserInputService.MouseIconEnabled = true
        end)
    else if mouseConnection then mouseConnection:Disconnect() mouseConnection = nil end end
end

local function toggleDesbloquearCamera(Value)
    CurrentSettings.Cam = Value
    if Value then
        cameraConnection = RunService.RenderStepped:Connect(function()
            if LocalPlayer then LocalPlayer.CameraMode = Enum.CameraMode.Classic LocalPlayer.CameraMaxZoomDistance = 128 LocalPlayer.CameraMinZoomDistance = 0.5 end
        end)
    else
        if cameraConnection then cameraConnection:Disconnect() cameraConnection = nil end
        if LocalPlayer then LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson LocalPlayer.CameraMaxZoomDistance = 0.5 LocalPlayer.CameraMinZoomDistance = 0.5 end
    end
end

local function LoadConfigManager(profileName)
    if readfile and isfile(ConfigsFolder .. "/" .. profileName .. "_HA.json") then
        local data = readfile(ConfigsFolder .. "/" .. profileName .. "_HA.json")
        local s, decoded = pcall(function() return HttpService:JSONDecode(data) end)
        if s and decoded then
            for k, v in pairs(decoded) do CurrentSettings[k] = v end
            toggleInstaInteract(CurrentSettings.Insta) toggleCoffeeMachine(CurrentSettings.Coff) loopAutoFixCameras(CurrentSettings.FixCam)
            loopAutoCheckIn(CurrentSettings.Check) autoShutterBarney(CurrentSettings.Barney) loopAutoMonster(CurrentSettings.Monster)
            loopInfiniteSanity(CurrentSettings.Sanity) toggleAntiLag(CurrentSettings.AntiLag) toggleFullBright(CurrentSettings.FullBright) toggleNoFog(CurrentSettings.NoFog)
            loopAutoTreatment(CurrentSettings.Treat) toggleNoclip(CurrentSettings.Noclip)
            toggleFly(CurrentSettings.Fly) flySpeed = CurrentSettings.FlySpd setWalkSpeed(CurrentSettings.WS) setJumpPower(CurrentSettings.JP)
            toggleDesbloquearMouse(CurrentSettings.Mouse) toggleDesbloquearCamera(CurrentSettings.Cam)
            selectedESP.Pacient = CurrentSettings.SelP selectedESP.Visitor = CurrentSettings.SelV selectedESP.Anomaly = CurrentSettings.SelA
            toggleMasterESP(CurrentSettings.MastESP) espFillTransparency = CurrentSettings.Fill espOutlineTransparency = CurrentSettings.Out updateESPVisuals()
            return true
        end
    end
    return false
end

updateStatus("Carregando Interface Gráfica...", 0.7)

-- ==========================================
-- SELETOR DE BIBLIOTECAS (RAYFIELD CORRIGIDO)
-- ==========================================
local UiLibrary = nil
local Window = nil
local uiSelecionada = "Nenhuma"

local function loadRayfield()
    local s, res = pcall(function() return loadstring(game:HttpGet('https://sirius.menu/rayfield'))() end)
    if s and res then uiSelecionada = "Rayfield" UiLibrary = res end
end

local function loadWindUI()
    local s, res = pcall(function() return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))() end)
    if s and res then uiSelecionada = "WindUI" UiLibrary = res end
end

local function loadOrion()
    local s, res = pcall(function() return loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexsoftware/Orion/main/source'))() end)
    if s and res then uiSelecionada = "Orion" UiLibrary = res end
end

local function loadFluent()
    local s, res = pcall(function() return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/fluent.lua"))() end)
    if s and res then uiSelecionada = "Fluent" UiLibrary = res end
end

local function loadLinoria()
    local s, res = pcall(function() return loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))() end)
    if s and res then uiSelecionada = "Linoria" UiLibrary = res end
end

local function loadVape()
    local s, res = pcall(function() return loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua"))() end)
    if s and res then uiSelecionada = "Vape" UiLibrary = res end
end

if preferredUI == "Rayfield" then loadRayfield()
elseif preferredUI == "WindUI" then loadWindUI()
elseif preferredUI == "Orion" then loadOrion()
elseif preferredUI == "Fluent" then loadFluent()
elseif preferredUI == "Linoria" then loadLinoria()
elseif preferredUI == "Vape" then loadVape()
elseif preferredUI == "Nativa" then uiSelecionada = "Nativa"
else
    loadRayfield()
    if uiSelecionada == "Nenhuma" then loadWindUI() end
    if uiSelecionada == "Nenhuma" then loadOrion() end
    if uiSelecionada == "Nenhuma" then loadFluent() end
    if uiSelecionada == "Nenhuma" then loadLinoria() end
    if uiSelecionada == "Nenhuma" then loadVape() end
end

if uiSelecionada == "Nenhuma" then uiSelecionada = "Nativa" end

globalEnv.CloseMiHubHospitalAnimals = function()
    loopAutoCheckIn(false) autoShutterBarney(false) loopAutoMonster(false) loopInfiniteSanity(false) toggleAntiLag(false) toggleFullBright(false) toggleNoFog(false) loopAutoTreatment(false) loopAutoFixCameras(false) 
    toggleDesbloquearMouse(false) toggleDesbloquearCamera(false) toggleMasterESP(false) toggleInstaInteract(false) toggleCoffeeMachine(false)
    toggleNoclip(false) toggleFly(false) setWalkSpeed(16) setJumpPower(50)
    if uiSelecionada == "WindUI" then local g = CoreGui:FindFirstChild("WindUI") if g then g:Destroy() end
    elseif uiSelecionada == "Rayfield" then if UiLibrary and UiLibrary.Destroy then pcall(function() UiLibrary:Destroy() end) end
    elseif uiSelecionada == "Nativa" then local g = CoreGui:FindFirstChild("MiHubNative") if g then g:Destroy() end end
end

local function restartScript()
    if globalEnv.CloseMiHubHospitalAnimals then globalEnv.CloseMiHubHospitalAnimals() end
    task.wait(0.2)
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/..."))()
    end)
end

local function handleLangChange(newVal)
    local code = langMap[newVal]
    if code and code ~= CurrentLang then
        CurrentLang = code
        pcall(function() writefile(langFileName, code) end)
        if UiLibrary and UiLibrary.Notify then
            UiLibrary:Notify({ Title = "Mi Hub", Content = T("WarnLang"), Duration = 3 })
        end
    end
end

local function handleUIChange(newVal)
    if newVal and newVal ~= preferredUI then
        preferredUI = newVal
        pcall(function() writefile(prefUiFileName, newVal) end)
        if UiLibrary and UiLibrary.Notify then
            UiLibrary:Notify({ Title = "Mi Hub", Content = T("WarnUI"), Duration = 3 })
        end
    end
end

updateStatus("Finalizando carregamento...", 1.0)
task.wait(0.3)
loadGui:Destroy()

-- ==========================================
-- MONITOR DE FECHAMENTO DA GUI E NOTIFICAÇÃO
-- ==========================================
local guiIsOpen = true
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == currentToggleKey then
        guiIsOpen = not guiIsOpen
        if not guiIsOpen then
            local keyName = tostring(currentToggleKey):gsub("Enum.KeyCode.", "")
            local msgNotif = string.format(T("NotifyToggle"), keyName)
            if uiSelecionada == "Rayfield" and UiLibrary.Notify then
                UiLibrary:Notify({ Title = "Mi Hub", Content = msgNotif, Duration = 5 })
            elseif uiSelecionada == "WindUI" and UiLibrary.Notify then
                UiLibrary:Notify({ Title = "Mi Hub", Content = msgNotif, Duration = 5 })
            else
                print("[Mi Hub] " .. msgNotif)
            end
        end
    end
end)

-- ==========================================
-- CONSTRUÇÃO DAS ABAS 
-- ==========================================
local ProfileNameInput = "Default"
local uiOptions = {"Rayfield", "WindUI", "Orion", "Fluent", "Linoria", "Vape", "Nativa"}

if uiSelecionada == "Rayfield" then
    local currentLangName = "English" for name, code in pairs(langMap) do if code == CurrentLang then currentLangName = name break end end
    Window = UiLibrary:CreateWindow({ Name = "Mi hub | " .. executorName, LoadingTitle = "Carregando...", ConfigurationSaving = { Enabled = false }, KeySystem = false })
    
    local TabPrincipal = Window:CreateTab(T("Main"), 4483362458) 
    local TabPlayer = Window:CreateTab(T("Player"), 4483362458) 
    local TabESP = Window:CreateTab(T("ESP"), 4483362458) 
    local TabProf = Window:CreateTab(T("Prof"), 4483362458) 
    local TabGUI = Window:CreateTab(T("Custom"), 4483362458) 
    local TabConfigs = Window:CreateTab(T("Opt"), 4483362458) 

    TabPrincipal:CreateToggle({ Name = T("Insta"), CurrentValue = false, Callback = toggleInstaInteract })
    TabPrincipal:CreateToggle({ Name = T("Coff"), CurrentValue = false, Callback = toggleCoffeeMachine })
    TabPrincipal:CreateToggle({ Name = T("FixCam"), CurrentValue = false, Callback = loopAutoFixCameras })
    TabPrincipal:CreateToggle({ Name = T("Check"), CurrentValue = false, Callback = loopAutoCheckIn })
    TabPrincipal:CreateToggle({ Name = T("Barney"), CurrentValue = false, Callback = autoShutterBarney })
    TabPrincipal:CreateToggle({ Name = T("Monster"), CurrentValue = false, Callback = loopAutoMonster })
    TabPrincipal:CreateToggle({ Name = T("Sanity"), CurrentValue = false, Callback = loopInfiniteSanity })
    TabPrincipal:CreateToggle({ Name = T("AntiLag"), CurrentValue = false, Callback = toggleAntiLag })
    TabPrincipal:CreateToggle({ Name = T("FullBright"), CurrentValue = false, Callback = toggleFullBright })
    TabPrincipal:CreateToggle({ Name = T("NoFog"), CurrentValue = false, Callback = toggleNoFog })
    TabPrincipal:CreateToggle({ Name = T("Treat"), CurrentValue = false, Callback = loopAutoTreatment })

    TabPlayer:CreateToggle({ Name = T("Noclip"), CurrentValue = false, Callback = toggleNoclip })
    TabPlayer:CreateToggle({ Name = T("Fly"), CurrentValue = false, Callback = toggleFly })
    TabPlayer:CreateSlider({ Name = T("FlySpd"), Range = {10, 500}, Increment = 1, CurrentValue = 50, Callback = function(v) CurrentSettings.FlySpd = v flySpeed = v end })
    TabPlayer:CreateSlider({ Name = T("WS"), Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = setWalkSpeed })
    TabPlayer:CreateSlider({ Name = T("JP"), Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = setJumpPower })
    TabPlayer:CreateToggle({ Name = T("Mouse"), CurrentValue = false, Callback = toggleDesbloquearMouse })
    TabPlayer:CreateToggle({ Name = T("Cam"), CurrentValue = false, Callback = toggleDesbloquearCamera })

    TabESP:CreateToggle({ Name = T("SelP"), CurrentValue = false, Callback = function(v) CurrentSettings.SelP = v selectedESP.Pacient = v updateESPTargets() end })
    TabESP:CreateToggle({ Name = T("SelV"), CurrentValue = false, Callback = function(v) CurrentSettings.SelV = v selectedESP.Visitor = v updateESPTargets() end })
    TabESP:CreateToggle({ Name = T("SelA"), CurrentValue = false, Callback = function(v) CurrentSettings.SelA = v selectedESP.Anomaly = v updateESPTargets() end })
    TabESP:CreateToggle({ Name = T("MastESP"), CurrentValue = false, Callback = toggleMasterESP })

    TabProf:CreateInput({ Name = T("ProfName"), PlaceholderText = "Default", RemoveTextAfterFocusLost = false, Callback = function(Text) ProfileNameInput = Text end })
    TabProf:CreateButton({ Name = T("SaveProf"), Callback = function() SaveConfig(ProfileNameInput) end })
    TabProf:CreateButton({ Name = T("LoadProf"), Callback = function() LoadConfigManager(ProfileNameInput) end })

    TabGUI:CreateSlider({ Name = T("Fill"), Range = {0, 1}, Increment = 0.1, CurrentValue = espFillTransparency, Callback = function(Value) CurrentSettings.Fill = Value espFillTransparency = Value updateESPVisuals() end })
    TabGUI:CreateSlider({ Name = "Out", Range = {0, 1}, Increment = 0.1, CurrentValue = espOutlineTransparency, Callback = function(Value) CurrentSettings.Out = Value espOutlineTransparency = Value updateESPVisuals() end })

    TabConfigs:CreateDropdown({ Name = T("UiPref"), Options = uiOptions, CurrentOption = {preferredUI}, MultipleOptions = false, Callback = function(Option) handleUIChange(Option[1]) end })
    TabConfigs:CreateDropdown({ Name = T("Lang"), Options = langNames, CurrentOption = {currentLangName}, MultipleOptions = false, Callback = function(Option) handleLangChange(Option[1]) end })
    TabConfigs:CreateKeybind({ Name = T("Togg"), CurrentKeybind = "RightShift", HoldToInteract = false, Callback = function(Keybind) if typeof(Keybind) == "EnumItem" then currentToggleKey = Keybind end end })
    TabConfigs:CreateButton({ Name = T("Restart"), Callback = restartScript })
    TabConfigs:CreateButton({ Name = T("Close"), Callback = function() if globalEnv.CloseMiHubHospitalAnimals then globalEnv.CloseMiHubHospitalAnimals() end end })

elseif uiSelecionada == "WindUI" then
    local currentLangName = "English" for name, code in pairs(langMap) do if code == CurrentLang then currentLangName = name break end end
    Window = UiLibrary:CreateWindow({ Title = "Mi hub | " .. executorName, Icon = "door-open", Author = "Script", Folder = "AutoCheckInConfig", Size = UDim2.fromOffset(580, 520), Transparent = true, Theme = "Dark", SideBarWidth = 180, HasOutline = true, ToggleKey = Enum.KeyCode.RightShift })
    
    local TabPrincipal = Window:Tab({ Title = T("Main"), Icon = "layout-grid" })
    local TabPlayer = Window:Tab({ Title = T("Player"), Icon = "user" })
    local TabESP = Window:Tab({ Title = T("ESP"), Icon = "eye" })
    local TabProf = Window:Tab({ Title = T("Prof"), Icon = "save" })
    local TabGUI = Window:Tab({ Title = T("Custom"), Icon = "palette" })
    local TabConfigs = Window:Tab({ Title = T("Opt"), Icon = "settings" })

    TabPrincipal:Toggle({ Title = T("Insta"), Desc = T("InstaDesc"), Default = false, Callback = toggleInstaInteract })
    TabPrincipal:Toggle({ Title = T("Coff"), Desc = T("CoffDesc"), Default = false, Callback = toggleCoffeeMachine })
    TabPrincipal:Toggle({ Title = T("FixCam"), Desc = T("FixCamDesc"), Default = false, Callback = loopAutoFixCameras })
    TabPrincipal:Toggle({ Title = T("Check"), Desc = T("CheckDesc"), Default = false, Callback = loopAutoCheckIn })
    TabPrincipal:Toggle({ Title = T("Barney"), Desc = T("BarneyDesc"), Default = false, Callback = autoShutterBarney })
    TabPrincipal:Toggle({ Title = T("Monster"), Desc = T("MonsterDesc"), Default = false, Callback = loopAutoMonster })
    TabPrincipal:Toggle({ Title = T("Sanity"), Desc = T("SanityDesc"), Default = false, Callback = loopInfiniteSanity })
    TabPrincipal:Toggle({ Title = T("AntiLag"), Desc = T("AntiLagDesc"), Default = false, Callback = toggleAntiLag })
    TabPrincipal:Toggle({ Title = T("FullBright"), Desc = T("FullBrightDesc"), Default = false, Callback = toggleFullBright })
    TabPrincipal:Toggle({ Title = T("NoFog"), Desc = T("NoFogDesc"), Default = false, Callback = toggleNoFog })
    TabPrincipal:Toggle({ Title = T("Treat"), Desc = T("TreatDesc"), Default = false, Callback = loopAutoTreatment })

    TabPlayer:Toggle({ Title = T("Noclip"), Desc = T("NoclipDesc"), Default = false, Callback = toggleNoclip })
    TabPlayer:Toggle({ Title = T("Fly"), Desc = T("FlyDesc"), Default = false, Callback = toggleFly })
    TabPlayer:Slider({ Title = T("FlySpd"), Step = 1, Min = 10, Max = 500, Default = 50, Callback = function(v) CurrentSettings.FlySpd = v flySpeed = v end })
    TabPlayer:Slider({ Title = T("WS"), Step = 1, Min = 16, Max = 500, Default = 16, Callback = setWalkSpeed })
    TabPlayer:Slider({ Title = T("JP"), Step = 1, Min = 50, Max = 500, Default = 50, Callback = setJumpPower })
    TabPlayer:Toggle({ Title = T("Mouse"), Desc = T("MouseDesc"), Default = false, Callback = toggleDesbloquearMouse })
    TabPlayer:Toggle({ Title = T("Cam"), Desc = T("CamDesc"), Default = false, Callback = toggleDesbloquearCamera })

    TabESP:Toggle({ Title = T("SelP"), Default = false, Callback = function(v) CurrentSettings.SelP = v selectedESP.Pacient = v updateESPTargets() end })
    TabESP:Toggle({ Title = T("SelV"), Default = false, Callback = function(v) CurrentSettings.SelV = v selectedESP.Visitor = v updateESPTargets() end })
    TabESP:Toggle({ Title = T("SelA"), Default = false, Callback = function(v) CurrentSettings.SelA = v selectedESP.Anomaly = v updateESPTargets() end })
    TabESP:Toggle({ Title = T("MastESP"), Desc = T("MastDesc"), Default = false, Callback = toggleMasterESP })

    TabProf:Input({ Title = T("ProfName"), Desc = T("ProfMsg"), Default = "Default", Placeholder = "Ex: Config1", Callback = function(v) ProfileNameInput = v end })
    TabProf:Button({ Title = T("SaveProf"), Callback = function() SaveConfig(ProfileNameInput) end })
    TabProf:Button({ Title = T("LoadProf"), Callback = function() LoadConfigManager(ProfileNameInput) end })

    TabGUI:Dropdown({ Title = T("Theme"), Options = {"Dark", "Light", "Mocha", "Rose", "Aqua"}, Default = "Dark", Callback = function(tema) pcall(function() Window:SetTheme(tema) end) end })
    TabGUI:Slider({ Title = T("Fill"), Step = 0.1, Min = 0, Max = 1, Default = espFillTransparency, Callback = function(v) CurrentSettings.Fill = v espFillTransparency = v updateESPVisuals() end })
    TabGUI:Slider({ Title = T("Out"), Step = 0.1, Min = 0, Max = 1, Default = espOutlineTransparency, Callback = function(v) CurrentSettings.Out = v espOutlineTransparency = v updateESPVisuals() end })

    TabConfigs:Dropdown({ Title = T("UiPref"), Desc = T("UiPrefDesc"), Options = uiOptions, Default = preferredUI, Callback = handleUIChange })
    TabConfigs:Dropdown({ Title = T("Lang"), Desc = T("LangDesc"), Options = langNames, Default = currentLangName, Callback = handleLangChange })
    TabConfigs:Keybind({
        Title = T("Togg"), Default = "RightShift",
        Callback = function(Key)
            local k = (typeof(Key) == "EnumItem") and Key or Enum.KeyCode[Key]
            if k then currentToggleKey = k pcall(function() Window.ToggleKey = k end) end
        end
    })
    TabConfigs:Button({ Title = T("Restart"), Callback = restartScript })
    TabConfigs:Button({ Title = T("Close"), Callback = function() if globalEnv.CloseMiHubHospitalAnimals then globalEnv.CloseMiHubHospitalAnimals() end end })

elseif uiSelecionada == "Orion" then
    Window = UiLibrary:MakeWindow({Name = "Mi hub | " .. executorName, HidePremium = true, SaveConfig = false, IntroText = "Mi Hub"})
    local TMain = Window:MakeTab({Name = T("Main")}) local TPlr = Window:MakeTab({Name = T("Player")}) local TESP = Window:MakeTab({Name = T("ESP")}) local TOpt = Window:MakeTab({Name = T("Opt")})
    TMain:AddToggle({Name = T("Insta"), Default = false, Callback = toggleInstaInteract})
    TMain:AddToggle({Name = T("Coff"), Default = false, Callback = toggleCoffeeMachine})
    TMain:AddToggle({Name = T("FixCam"), Default = false, Callback = loopAutoFixCameras})
    TMain:AddToggle({Name = T("Check"), Default = false, Callback = loopAutoCheckIn})
    TMain:AddToggle({Name = T("Barney"), Default = false, Callback = autoShutterBarney})
    TMain:AddToggle({Name = T("Monster"), Default = false, Callback = loopAutoMonster})
    TMain:AddToggle({Name = T("Sanity"), Default = false, Callback = loopInfiniteSanity})
    TMain:AddToggle({Name = T("AntiLag"), Default = false, Callback = toggleAntiLag})
    TMain:AddToggle({Name = T("FullBright"), Default = false, Callback = toggleFullBright})
    TMain:AddToggle({Name = T("NoFog"), Default = false, Callback = toggleNoFog})
    TMain:AddToggle({Name = T("Treat"), Default = false, Callback = loopAutoTreatment})
    TPlr:AddToggle({Name = T("Noclip"), Default = false, Callback = toggleNoclip})
    TPlr:AddToggle({Name = T("Fly"), Default = false, Callback = toggleFly})
    TPlr:AddSlider({Name = T("WS"), Min = 16, Max = 500, Default = 16, Increment = 1, Callback = setWalkSpeed})
    TPlr:AddSlider({Name = T("JP"), Min = 50, Max = 500, Default = 50, Increment = 1, Callback = setJumpPower})
    TESP:AddToggle({Name = T("MastESP"), Default = false, Callback = toggleMasterESP})
    TOpt:AddButton({Name = T("Restart"), Callback = restartScript})
    TOpt:AddButton({Name = T("Close"), Callback = function() if globalEnv.CloseMiHubHospitalAnimals then globalEnv.CloseMiHubHospitalAnimals() end end})
    UiLibrary:Init()

else
    -- Fallback Nativo (Plano C Garantido)
    local sg = Instance.new("ScreenGui") sg.Name = "MiHubNative" sg.ResetOnSpawn = false sg.Parent = CoreGui:FindFirstChild("RobloxGui") or LocalPlayer:FindFirstChild("PlayerGui")
    local main = Instance.new("Frame") main.Size = UDim2.new(0, 320, 0, 420) main.Position = UDim2.new(0.5, -160, 0.5, -210) main.BackgroundColor3 = Color3.fromRGB(30, 30, 35) main.Parent = sg Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
    local title = Instance.new("TextLabel") title.Size = UDim2.new(1, 0, 
    0, 40) title.BackgroundColor3 = Color3.fromRGB(45, 45, 55) title.TextColor3 = Color3.fromRGB(255, 255, 255) title.Text = T("NativeTitle") title.Font = Enum.Font.GothamBold title.TextSize = 16 title.Parent = main Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)
    local scroll = Instance.new("ScrollingFrame") scroll.Size = UDim2.new(1, -20, 1, -60) scroll.Position = UDim2.new(0, 10, 0, 50) scroll.BackgroundTransparency = 1 scroll.CanvasSize = UDim2.new(0, 0, 0, 650) scroll.ScrollBarThickness = 4 scroll.Parent = main
    local list = Instance.new("UIListLayout") list.Parent = scroll list.Padding = UDim.new(0, 6)
    
    local function addNativaBtn(name, cb)
        local btn = Instance.new("TextButton") btn.Size = UDim2.new(1, -10, 0, 32) btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60) btn.TextColor3 = Color3.fromRGB(220, 220, 220) btn.Text = name btn.Font = Enum.Font.Gotham btn.TextSize = 13 btn.Parent = scroll Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local st = false btn.MouseButton1Click:Connect(function() st = not st btn.Text = (st and "✅ " or "❌ ") .. name btn.BackgroundColor3 = st and Color3.fromRGB(40, 70, 40) or Color3.fromRGB(50, 50, 60) cb(st) end)
    end
    addNativaBtn(T("Insta"), toggleInstaInteract) addNativaBtn(T("Coff"), toggleCoffeeMachine) addNativaBtn(T("FixCam"), loopAutoFixCameras)
    addNativaBtn(T("Check"), loopAutoCheckIn) addNativaBtn(T("Barney"), autoShutterBarney) addNativaBtn(T("Monster"), loopAutoMonster)
    addNativaBtn(T("Sanity"), loopInfiniteSanity) addNativaBtn(T("AntiLag"), toggleAntiLag) addNativaBtn(T("FullBright"), toggleFullBright) addNativaBtn(T("NoFog"), toggleNoFog)
    addNativaBtn(T("Treat"), loopAutoTreatment) addNativaBtn(T("Noclip"), toggleNoclip) addNativaBtn(T("Fly"), toggleFly)
    
    local restBtn = Instance.new("TextButton") restBtn.Size = UDim2.new(1, -10, 0, 32) restBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 180) restBtn.TextColor3 = Color3.fromRGB(255, 255, 255) restBtn.Text = T("Restart") restBtn.Font = Enum.Font.GothamBold restBtn.TextSize = 13 restBtn.Parent = scroll Instance.new("UICorner", restBtn).CornerRadius = UDim.new(0, 6)
    restBtn.MouseButton1Click:Connect(restartScript)

    local closeBtn = Instance.new("TextButton") closeBtn.Size = UDim2.new(1, -10, 0, 32) closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50) closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255) closeBtn.Text = T("Close") closeBtn.Font = Enum.Font.GothamBold closeBtn.TextSize = 13 closeBtn.Parent = scroll Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    closeBtn.MouseButton1Click:Connect(function() if globalEnv.CloseMiHubHospitalAnimals then globalEnv.CloseMiHubHospitalAnimals() end end)
end
