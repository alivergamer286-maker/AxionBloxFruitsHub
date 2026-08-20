--[[
    Axion Blox Fruits Hub
    Keyless | Auto Farm | ESP | Race | Chest | Fruit
    Made for Axion
]]

if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Settings
getgenv().AxionSettings = getgenv().AxionSettings or {
    AutoFarm = false,
    AutoFarmMethod = "Quest",
    SelectedNPC = "",
    AutoChest = false,
    AutoFruit = false,
    AutoSpin = false,
    SpinWhenReady = true,
    AutoStats = false,
    StatsMelee = true,
    StatsDefense = true,
    StatsSword = false,
    StatsGun = false,
    StatsFruit = false,
    AutoRace = false,
    SelectedRace = "Human",
    RaceAutoGet = true,
    ESPPlayers = false,
    ESPChests = false,
    ESPFruits = false,
    ESPMobs = false,
    FastAttack = true,
    BringMobs = true,
    TweenSpeed = 150,
    FarmDistance = 30,
    AutoSkill = true,
    AutoQuest = true,
    SeaProgress = true,
    Team = "Pirates",
    Notify = true
}

local Settings = getgenv().AxionSettings

local function Notify(title, text, duration)
    if not Settings.Notify then return end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title or "Axion Hub",
            Text = text or "",
            Duration = duration or 3
        })
    end)
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxionBloxHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 520, 0, 380)
Main.Position = UDim2.new(0.5, -260, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
Title.Text = "  Axion Blox Fruits Hub | Keyless"
Title.TextColor3 = Color3.fromRGB(255, 100, 120)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = Title
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0, 120, 1, -50)
TabFrame.Position = UDim2.new(0, 5, 0, 45)
TabFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
TabFrame.BorderSizePixel = 0
TabFrame.Parent = Main
local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabFrame

local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -140, 1, -55)
Content.Position = UDim2.new(0, 130, 0, 50)
Content.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.CanvasSize = UDim2.new(0, 0, 0, 600)
Content.Parent = Main
local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = Content

local function ClearContent()
    for _, v in pairs(Content:GetChildren()) do
        if v:IsA("GuiObject") and v.Name ~= "UIListLayout" then
            v:Destroy()
        end
    end
end

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = Content

local function CreateToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    frame.BorderSizePixel = 0
    frame.Parent = Content
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 235)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 22)
    btn.Position = UDim2.new(1, -45, 0.5, -11)
    btn.BackgroundColor3 = default and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 70)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = frame
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 5)
    bc.Parent = btn

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 70)
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
    return frame
end

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(255, 80, 100)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = Content
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateDropdown(text, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    frame.BorderSizePixel = 0
    frame.Parent = Content
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 235)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -10, 0, 24)
    btn.Position = UDim2.new(0.5, 0, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = default
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = frame
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 5)
    bc.Parent = btn

    local index = table.find(options, default) or 1
    btn.MouseButton1Click:Connect(function()
        index = index % #options + 1
        btn.Text = options[index]
        callback(options[index])
    end)
    return frame
end

local currentTab = "Farm"

local function LoadFarmTab()
    ClearContent()
    CreateToggle("Auto Farm Level", Settings.AutoFarm, function(v)
        Settings.AutoFarm = v
        Notify("Farm", v and "Auto Farm ON" or "Auto Farm OFF")
    end)
    CreateDropdown("Farm Method", {"Quest", "Nearest", "Selected"}, Settings.AutoFarmMethod, function(v)
        Settings.AutoFarmMethod = v
    end)
    CreateToggle("Auto Quest", Settings.AutoQuest, function(v) Settings.AutoQuest = v end)
    CreateToggle("Bring Mobs", Settings.BringMobs, function(v) Settings.BringMobs = v end)
    CreateToggle("Fast Attack", Settings.FastAttack, function(v) Settings.FastAttack = v end)
    CreateToggle("Auto Skill", Settings.AutoSkill, function(v) Settings.AutoSkill = v end)
    CreateToggle("Sea Progress", Settings.SeaProgress, function(v) Settings.SeaProgress = v end)
    CreateToggle("Auto Chest Farm", Settings.AutoChest, function(v)
        Settings.AutoChest = v
        Notify("Chest", v and "Chest Farm ON" or "Chest Farm OFF")
    end)
end

local function LoadESPTab()
    ClearContent()
    CreateToggle("ESP Players", Settings.ESPPlayers, function(v)
        Settings.ESPPlayers = v
        Notify("ESP", "Players " .. (v and "ON" or "OFF"))
    end)
    CreateToggle("ESP Chests", Settings.ESPChests, function(v)
        Settings.ESPChests = v
    end)
    CreateToggle("ESP Fruits", Settings.ESPFruits, function(v)
        Settings.ESPFruits = v
    end)
    CreateToggle("ESP Mobs", Settings.ESPMobs, function(v)
        Settings.ESPMobs = v
    end)
end

local function LoadRaceTab()
    ClearContent()
    CreateDropdown("Selected Race", {"Human", "Mink", "Fishman", "Skypiean", "Cyborg", "Ghoul"}, Settings.SelectedRace, function(v)
        Settings.SelectedRace = v
        Notify("Race", "Selected: " .. v)
    end)
    CreateToggle("Auto Race Upgrade", Settings.AutoRace, function(v)
        Settings.AutoRace = v
        Notify("Race", v and "Auto Race ON" or "OFF")
    end)
    CreateToggle("Auto Get Race if Missing", Settings.RaceAutoGet, function(v)
        Settings.RaceAutoGet = v
    end)
    CreateButton("Force Race Reroll (Fragments)", function()
        Notify("Race", "Tentando reroll... (precisa de fragments)")
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Race Reroll")
        end)
    end)
end

local function LoadFruitTab()
    ClearContent()
    CreateToggle("Auto Collect Fruits", Settings.AutoFruit, function(v)
        Settings.AutoFruit = v
        Notify("Fruit", v and "Auto Fruit ON" or "OFF")
    end)
    CreateToggle("Auto Spin when Ready", Settings.AutoSpin, function(v)
        Settings.AutoSpin = v
        Notify("Spin", v and "Auto Spin ON" or "OFF")
    end)
    CreateButton("Force Spin Now", function()
        Notify("Spin", "Tentando spin...")
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
        end)
    end)
end

local function LoadStatsTab()
    ClearContent()
    CreateToggle("Auto Stats", Settings.AutoStats, function(v) Settings.AutoStats = v end)
    CreateToggle("Melee", Settings.StatsMelee, function(v) Settings.StatsMelee = v end)
    CreateToggle("Defense", Settings.StatsDefense, function(v) Settings.StatsDefense = v end)
    CreateToggle("Sword", Settings.StatsSword, function(v) Settings.StatsSword = v end)
    CreateToggle("Gun", Settings.StatsGun, function(v) Settings.StatsGun = v end)
    CreateToggle("Blox Fruit", Settings.StatsFruit, function(v) Settings.StatsFruit = v end)
end

local function LoadMiscTab()
    ClearContent()
    CreateButton("Server Hop", function()
        Notify("Misc", "Server hopping...")
        pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end)
    CreateButton("Rejoin", function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
    CreateToggle("Notifications", Settings.Notify, function(v) Settings.Notify = v end)
    CreateButton("Destroy Hub", function()
        ScreenGui:Destroy()
    end)
end

local tabs = {
    {Name = "Farm", Func = LoadFarmTab},
    {Name = "ESP", Func = LoadESPTab},
    {Name = "Race", Func = LoadRaceTab},
    {Name = "Fruit", Func = LoadFruitTab},
    {Name = "Stats", Func = LoadStatsTab},
    {Name = "Misc", Func = LoadMiscTab}
}

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 5, 0, 5 + (i-1)*38)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = tab.Name
    btn.TextColor3 = Color3.fromRGB(220, 220, 230)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = TabFrame
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    btn.MouseButton1Click:Connect(function()
        currentTab = tab.Name
        tab.Func()
    end)
end

LoadFarmTab()

local function GetCharacter()
    Character = LocalPlayer.Character
    if not Character then return nil end
    HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    Humanoid = Character:FindFirstChild("Humanoid")
    return Character
end

local function TweenTo(pos)
    if not GetCharacter() or not HumanoidRootPart then return end
    local distance = (HumanoidRootPart.Position - pos).Magnitude
    local time = distance / Settings.TweenSpeed
    local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
    tween:Play()
    tween.Completed:Wait()
end

local function GetNearestMob()
    local nearest, dist = nil, math.huge
    for _, v in pairs(Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local d = (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                nearest = v
            end
        end
    end
    return nearest
end

local function Attack()
    if not Settings.FastAttack then return end
    pcall(function()
        local VirtualInputManager = game:GetService("VirtualInputManager")
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end)
end

spawn(function()
    while task.wait(0.3) do
        if Settings.AutoFarm and GetCharacter() then
            pcall(function()
                local mob = GetNearestMob()
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    if Settings.BringMobs then
                        mob.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -Settings.FarmDistance)
                    end
                    HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.FarmDistance)
                    Attack()
                    if Settings.AutoSkill then
                        pcall(function()
                            local vim = game:GetService("VirtualInputManager")
                            vim:SendKeyEvent(true, "Z", false, game)
                            task.wait(0.1)
                            vim:SendKeyEvent(false, "Z", false, game)
                        end)
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait(1) do
        if Settings.AutoChest and GetCharacter() then
            pcall(function()
                for _, chest in pairs(Workspace:GetDescendants()) do
                    if chest.Name:lower():find("chest") and (chest:IsA("Part") or chest:IsA("Model")) then
                        local part = chest:IsA("Model") and (chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")) or chest
                        if part then
                            TweenTo(part.Position + Vector3.new(0, 3, 0))
                            task.wait(0.5)
                            pcall(function()
                                firetouchinterest(HumanoidRootPart, part, 0)
                                firetouchinterest(HumanoidRootPart, part, 1)
                            end)
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait(2) do
        if Settings.AutoFruit and GetCharacter() then
            pcall(function()
                for _, fruit in pairs(Workspace:GetChildren()) do
                    if fruit.Name:find("Fruit") or fruit:FindFirstChild("Fruit") then
                        local part = fruit:FindFirstChild("Handle") or fruit:FindFirstChildWhichIsA("BasePart")
                        if part then
                            TweenTo(part.Position)
                            task.wait(0.8)
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait(5) do
        if Settings.AutoSpin then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
            end)
        end
    end
end)

spawn(function()
    while task.wait(3) do
        if Settings.AutoStats then
            pcall(function()
                local points = LocalPlayer.Data.Points.Value
                if points > 0 then
                    if Settings.StatsMelee then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
                    end
                    if Settings.StatsDefense then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
                    end
                    if Settings.StatsSword then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
                    end
                    if Settings.StatsGun then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1)
                    end
                    if Settings.StatsFruit then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
                    end
                end
            end)
        end
    end
end)

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "AxionESP"
ESPFolder.Parent = CoreGui

local function ClearESP()
    for _, v in pairs(ESPFolder:GetChildren()) do
        v:Destroy()
    end
end

local function CreateESP(obj, text, color)
    if not obj then return end
    local bill = Instance.new("BillboardGui")
    bill.Name = "ESP"
    bill.Adornee = obj
    bill.Size = UDim2.new(0, 100, 0, 40)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.AlwaysOnTop = true
    bill.Parent = ESPFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255, 100, 100)
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Parent = bill
end

spawn(function()
    while task.wait(1.5) do
        ClearESP()
        if Settings.ESPPlayers then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    CreateESP(plr.Character.HumanoidRootPart, plr.Name .. " [" .. math.floor((HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude) .. "]", Color3.fromRGB(100, 200, 255))
                end
            end
        end
        if Settings.ESPChests then
            for _, chest in pairs(Workspace:GetDescendants()) do
                if chest.Name:lower():find("chest") then
                    local part = chest:IsA("BasePart") and chest or chest:FindFirstChildWhichIsA("BasePart")
                    if part then
                        CreateESP(part, "Chest", Color3.fromRGB(255, 215, 0))
                    end
                end
            end
        end
        if Settings.ESPFruits then
            for _, fruit in pairs(Workspace:GetChildren()) do
                if fruit.Name:find("Fruit") then
                    local part = fruit:FindFirstChild("Handle") or fruit:FindFirstChildWhichIsA("BasePart")
                    if part then
                        CreateESP(part, fruit.Name, Color3.fromRGB(150, 255, 100))
                    end
                end
            end
        end
    end
end)

spawn(function()
    while task.wait(10) do
        if Settings.AutoRace and Settings.RaceAutoGet then
            pcall(function()
                local race = LocalPlayer.Data.Race.Value
                if race ~= Settings.SelectedRace and (Settings.SelectedRace == "Human" or Settings.SelectedRace == "Mink" or Settings.SelectedRace == "Fishman" or Settings.SelectedRace == "Skypiean") then
                    Notify("Race", "Tentando obter " .. Settings.SelectedRace)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Race Reroll")
                end
            end)
        end
    end
end)

Notify("Axion Hub", "Carregado com sucesso! Keyless.", 5)
print("[Axion] Blox Fruits Hub loaded | Keyless")
