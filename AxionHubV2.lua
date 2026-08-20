--[[
    AXION BLOX FRUITS HUB  v2.0
    Keyless • Mobile • Gold/Black
    Made exclusively for Axion
]]

if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Character

local Players           = game:GetService("Players")
local LocalPlayer       = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local Workspace         = game:GetService("Workspace")
local VirtualUser       = game:GetService("VirtualUser")
local HttpService       = game:GetService("HttpService")
local CoreGui           = game:GetService("CoreGui")
local TeleportService   = game:GetService("TeleportService")
local UserInputService  = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui        = game:GetService("StarterGui")

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local SAVE_KEY = "AxionBloxHub_v2_" .. tostring(LocalPlayer.UserId)

local DefaultSettings = {
    AutoFarm = false,
    FarmMethod = "Nearest",
    BringMobs = true,
    FastAttack = true,
    AutoSkill = true,
    FarmDistance = 25,
    TweenSpeed = 180,
    AutoQuest = true,
    SelectedWeapon = "Melee",
    AutoChest = false,
    AutoFruit = false,
    AutoSpin = false,
    PreferBuddha = true,
    AutoRace = false,
    SelectedRace = "Human",
    RaceAutoGet = true,
    AutoStats = false,
    StatMelee = true,
    StatDefense = true,
    StatSword = false,
    StatGun = false,
    StatFruit = false,
    ESPPlayers = false,
    ESPChests = false,
    ESPFruits = false,
    ESPMobs = false,
    ESPDistance = true,
    Team = "Pirates",
    SeaProgress = true,
    Notify = true,
    MobileOptimized = true,
}

getgenv().AxionSettings = getgenv().AxionSettings or DefaultSettings
local S = getgenv().AxionSettings
for k, v in pairs(DefaultSettings) do
    if S[k] == nil then S[k] = v end
end

local function SaveConfig()
    pcall(function()
        if writefile then
            writefile(SAVE_KEY .. ".json", HttpService:JSONEncode(S))
        end
    end)
end

local function LoadConfig()
    pcall(function()
        if isfile and isfile(SAVE_KEY .. ".json") then
            local data = HttpService:JSONDecode(readfile(SAVE_KEY .. ".json"))
            for k, v in pairs(data) do
                if S[k] ~= nil then S[k] = v end
            end
        end
    end)
end

LoadConfig()

local function Notify(title, text, dur)
    if not S.Notify then return end
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Axion Hub",
            Text = text or "",
            Duration = dur or 3
        })
    end)
end

local Character, HumanoidRootPart, Humanoid

local function RefreshChar()
    Character = LocalPlayer.Character
    if not Character then return false end
    HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    Humanoid = Character:FindFirstChild("Humanoid")
    return HumanoidRootPart ~= nil and Humanoid ~= nil
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    RefreshChar()
end)
RefreshChar()

local function TweenTo(cf_or_pos)
    if not RefreshChar() then return end
    local target = typeof(cf_or_pos) == "CFrame" and cf_or_pos or CFrame.new(cf_or_pos)
    local dist = (HumanoidRootPart.Position - target.Position).Magnitude
    local t = math.clamp(dist / S.TweenSpeed, 0.15, 8)
    local tw = TweenService:Create(HumanoidRootPart, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = target})
    tw:Play()
    tw.Completed:Wait()
end

local function EquipWeapon()
    pcall(function()
        local bp = LocalPlayer.Backpack
        local char = LocalPlayer.Character
        if not char then return end
        local tool
        if S.SelectedWeapon == "Melee" then
            for _, t in pairs(bp:GetChildren()) do
                if t:IsA("Tool") and (t.ToolTip == "Melee" or t.Name:find("Combat") or t.Name:find("Dark") or t.Name:find("God") or t.Name:find("Super") or t.Name:find("Electric") or t.Name:find("Water") or t.Name:find("Death") or t.Name:find("Shark") or t.Name:find("Dragon") or t.Name:find("Sanguine")) then
                    tool = t
                    break
                end
            end
        elseif S.SelectedWeapon == "Sword" then
            for _, t in pairs(bp:GetChildren()) do
                if t:IsA("Tool") and t.ToolTip == "Sword" then
                    tool = t
                    break
                end
            end
        elseif S.SelectedWeapon == "Fruit" then
            for _, t in pairs(bp:GetChildren()) do
                if t:IsA("Tool") and (t.ToolTip == "Blox Fruit" or t.Name:find("Fruit")) then
                    tool = t
                    break
                end
            end
        end
        if tool then Humanoid:EquipTool(tool) end
    end)
end

local function FastAttack()
    if not S.FastAttack then return end
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.03)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end)
end

local function UseSkills()
    if not S.AutoSkill then return end
    pcall(function()
        for _, key in ipairs({"Z", "X", "C", "V", "F"}) do
            VirtualInputManager:SendKeyEvent(true, key, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, key, false, game)
            task.wait(0.08)
        end
    end)
end

local function GetNearestEnemy(maxDist)
    maxDist = maxDist or 400
    local nearest, best = nil, maxDist
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    for _, mob in pairs(enemies:GetChildren()) do
        local hum = mob:FindFirstChild("Humanoid")
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and hrp then
            local d = (HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < best then
                best = d
                nearest = mob
            end
        end
    end
    return nearest
end

task.spawn(function()
    while true do
        task.wait(0.25)
        if S.AutoFarm and RefreshChar() then
            pcall(function()
                EquipWeapon()
                local mob = GetNearestEnemy()
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    local hrp = mob.HumanoidRootPart
                    if S.BringMobs then
                        hrp.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -S.FarmDistance)
                        hrp.CanCollide = false
                        hrp.Size = Vector3.new(2, 2, 2)
                    end
                    HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 0, S.FarmDistance)
                    FastAttack()
                    if math.random() < 0.35 then UseSkills() end
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1.2)
        if S.AutoChest and RefreshChar() then
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if not S.AutoChest then break end
                    local name = obj.Name:lower()
                    if name:find("chest") then
                        local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                        if part then
                            TweenTo(part.Position + Vector3.new(0, 4, 0))
                            task.wait(0.4)
                            pcall(function()
                                firetouchinterest(HumanoidRootPart, part, 0)
                                firetouchinterest(HumanoidRootPart, part, 1)
                            end)
                            task.wait(0.3)
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(2)
        if S.AutoFruit and RefreshChar() then
            pcall(function()
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name:find("Fruit") or (obj:IsA("Tool") and obj.Name:find("Fruit")) then
                        local part = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                        if part then
                            TweenTo(part.Position)
                            task.wait(0.6)
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(6)
        if S.AutoSpin then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(2.5)
        if S.AutoStats then
            pcall(function()
                local points = LocalPlayer.Data and LocalPlayer.Data.Points and LocalPlayer.Data.Points.Value or 0
                if points > 0 then
                    if S.StatMelee then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1) end
                    if S.StatDefense then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1) end
                    if S.StatSword then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1) end
                    if S.StatGun then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1) end
                    if S.StatFruit then ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1) end
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(12)
        if S.AutoRace and S.RaceAutoGet then
            pcall(function()
                local race = LocalPlayer.Data and LocalPlayer.Data.Race and LocalPlayer.Data.Race.Value
                if race and race ~= S.SelectedRace then
                    if S.SelectedRace == "Human" or S.SelectedRace == "Mink" or S.SelectedRace == "Fishman" or S.SelectedRace == "Skypiean" then
                        Notify("Race", "Tentando " .. S.SelectedRace)
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("Race Reroll")
                    end
                end
            end)
        end
    end
end)

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "AxionESP"
pcall(function() ESPFolder.Parent = CoreGui end)
if not ESPFolder.Parent then ESPFolder.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local function ClearESP()
    for _, v in pairs(ESPFolder:GetChildren()) do v:Destroy() end
end

local function MakeESP(adornee, text, color)
    if not adornee then return end
    local bill = Instance.new("BillboardGui")
    bill.Name = "ESP"
    bill.Adornee = adornee
    bill.Size = UDim2.new(0, 120, 0, 36)
    bill.StudsOffset = Vector3.new(0, 2.8, 0)
    bill.AlwaysOnTop = true
    bill.Parent = ESPFolder
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.TextStrokeTransparency = 0.4
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.Parent = bill
end

task.spawn(function()
    while true do
        task.wait(1.4)
        ClearESP()
        if not RefreshChar() then continue end
        if S.ESPPlayers then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = math.floor((HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude)
                    local txt = S.ESPDistance and (plr.Name .. " [" .. dist .. "]") or plr.Name
                    MakeESP(plr.Character.HumanoidRootPart, txt, Color3.fromRGB(100, 180, 255))
                end
            end
        end
        if S.ESPChests then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find("chest") then
                    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                    if part then MakeESP(part, "Chest", Color3.fromRGB(255, 200, 50)) end
                end
            end
        end
        if S.ESPFruits then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj.Name:find("Fruit") then
                    local part = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                    if part then MakeESP(part, obj.Name, Color3.fromRGB(120, 255, 120)) end
                end
            end
        end
        if S.ESPMobs then
            local enemies = Workspace:FindFirstChild("Enemies")
            if enemies then
                for _, mob in pairs(enemies:GetChildren()) do
                    local hrp = mob:FindFirstChild("HumanoidRootPart")
                    local hum = mob:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        MakeESP(hrp, mob.Name, Color3.fromRGB(255, 100, 100))
                    end
                end
            end
        end
    end
end)

-- UI BLACK + GOLD MOBILE
local GOLD = Color3.fromRGB(212, 175, 55)
local GOLD_DARK = Color3.fromRGB(160, 125, 30)
local BG = Color3.fromRGB(12, 12, 14)
local BG2 = Color3.fromRGB(20, 20, 24)
local BG3 = Color3.fromRGB(28, 28, 34)
local TEXT = Color3.fromRGB(240, 235, 220)
local MUTED = Color3.fromRGB(160, 155, 140)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AxionHubV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 340, 0, 420)
Main.Position = UDim2.new(0.5, -170, 0.5, -210)
Main.BackgroundColor3 = BG
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = GOLD
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.3
MainStroke.Parent = Main

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = BG2
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 14)
TitleFix.Position = UDim2.new(0, 0, 1, -14)
TitleFix.BackgroundColor3 = BG2
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "AXION  •  BLOX FRUITS"
TitleLabel.TextColor3 = GOLD
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function()
    SaveConfig()
    ScreenGui:Destroy()
end)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -68, 0.5, -14)
MinBtn.BackgroundColor3 = BG3
MinBtn.Text = "–"
MinBtn.TextColor3 = GOLD
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Parent = TitleBar
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Main.Size = minimized and UDim2.new(0, 340, 0, 42) or UDim2.new(0, 340, 0, 420)
end)

local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Side = Instance.new("Frame")
Side.Size = UDim2.new(0, 88, 1, -50)
Side.Position = UDim2.new(0, 6, 0, 48)
Side.BackgroundColor3 = BG2
Side.BorderSizePixel = 0
Side.Parent = Main
local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 8)
SideCorner.Parent = Side

local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -106, 1, -58)
Content.Position = UDim2.new(0, 98, 0, 50)
Content.BackgroundColor3 = BG2
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = GOLD
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = Main
local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = Content

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 6)
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Parent = Content

local Pad = Instance.new("UIPadding")
Pad.PaddingTop = UDim.new(0, 8)
Pad.PaddingLeft = UDim.new(0, 8)
Pad.PaddingRight = UDim.new(0, 8)
Pad.PaddingBottom = UDim.new(0, 12)
Pad.Parent = Content

local function ClearContent()
    for _, c in pairs(Content:GetChildren()) do
        if c:IsA("GuiObject") and c ~= List and c ~= Pad then c:Destroy() end
    end
end

local function Section(title)
    local f = Instance.new("TextLabel")
    f.Size = UDim2.new(1, 0, 0, 22)
    f.BackgroundTransparency = 1
    f.Text = title
    f.TextColor3 = GOLD
    f.Font = Enum.Font.GothamBold
    f.TextSize = 12
    f.TextXAlignment = Enum.TextXAlignment.Left
    f.Parent = Content
end

local function Toggle(text, key, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 36)
    f.BackgroundColor3 = BG3
    f.BorderSizePixel = 0
    f.Parent = Content
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = f

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = TEXT
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 52, 0, 24)
    btn.Position = UDim2.new(1, -60, 0.5, -12)
    btn.BackgroundColor3 = S[key] and GOLD or Color3.fromRGB(50, 50, 55)
    btn.Text = S[key] and "ON" or "OFF"
    btn.TextColor3 = S[key] and Color3.fromRGB(20, 15, 5) or MUTED
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = f
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn

    btn.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        btn.BackgroundColor3 = S[key] and GOLD or Color3.fromRGB(50, 50, 55)
        btn.Text = S[key] and "ON" or "OFF"
        btn.TextColor3 = S[key] and Color3.fromRGB(20, 15, 5) or MUTED
        SaveConfig()
        if callback then callback(S[key]) end
        Notify("Axion", text .. (S[key] and " ON" or " OFF"), 2)
    end)
end

local function Dropdown(text, key, options)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 36)
    f.BackgroundColor3 = BG3
    f.BorderSizePixel = 0
    f.Parent = Content
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = f

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.42, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = TEXT
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f

    local idx = table.find(options, S[key]) or 1
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.52, -8, 0, 26)
    btn.Position = UDim2.new(0.46, 0, 0.5, -13)
    btn.BackgroundColor3 = Color3.fromRGB(40, 38, 32)
    btn.Text = tostring(S[key])
    btn.TextColor3 = GOLD
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = f
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn

    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        S[key] = options[idx]
        btn.Text = tostring(S[key])
        SaveConfig()
        Notify("Axion", text .. ": " .. S[key], 2)
    end)
end

local function ActionBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = GOLD_DARK
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 245, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = Content
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Color = GOLD
    stroke.Thickness = 1
    stroke.Transparency = 0.4
    stroke.Parent = btn
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

local tabs = {
    {Name = "Farm", Icon = "F"},
    {Name = "ESP", Icon = "E"},
    {Name = "Race", Icon = "R"},
    {Name = "Fruit", Icon = "Fr"},
    {Name = "Stats", Icon = "S"},
    {Name = "Misc", Icon = "M"},
}

local currentTab = "Farm"
local tabButtons = {}

local function LoadTab(name)
    currentTab = name
    ClearContent()
    for _, b in pairs(tabButtons) do
        b.BackgroundColor3 = BG3
        b.TextColor3 = MUTED
    end
    if tabButtons[name] then
        tabButtons[name].BackgroundColor3 = GOLD_DARK
        tabButtons[name].TextColor3 = GOLD
    end

    if name == "Farm" then
        Section("AUTO FARM")
        Toggle("Auto Farm Level", "AutoFarm")
        Dropdown("Method", "FarmMethod", {"Nearest", "Quest", "Boss"})
        Dropdown("Weapon", "SelectedWeapon", {"Melee", "Sword", "Fruit"})
        Toggle("Bring Mobs", "BringMobs")
        Toggle("Fast Attack", "FastAttack")
        Toggle("Auto Skill (Z/X/C/V)", "AutoSkill")
        Toggle("Auto Quest", "AutoQuest")
        Section("CHEST")
        Toggle("Auto Chest Farm", "AutoChest")
    elseif name == "ESP" then
        Section("ESP")
        Toggle("Players", "ESPPlayers")
        Toggle("Chests", "ESPChests")
        Toggle("Fruits", "ESPFruits")
        Toggle("Mobs", "ESPMobs")
        Toggle("Show Distance", "ESPDistance")
    elseif name == "Race" then
        Section("RACE (Human focus)")
        Dropdown("Target Race", "SelectedRace", {"Human", "Mink", "Fishman", "Skypiean", "Cyborg", "Ghoul"})
        Toggle("Auto Race System", "AutoRace")
        Toggle("Auto Get if Missing", "RaceAutoGet")
        ActionBtn("Force Race Reroll", function()
            Notify("Race", "Reroll enviado (precisa fragments)")
            pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("Race Reroll") end)
        end)
    elseif name == "Fruit" then
        Section("FRUIT")
        Toggle("Auto Collect Fruits", "AutoFruit")
        Toggle("Auto Spin", "AutoSpin")
        Toggle("Prefer Buddha", "PreferBuddha")
        ActionBtn("Force Spin Now", function()
            Notify("Fruit", "Spin enviado")
            pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy") end)
        end)
    elseif name == "Stats" then
        Section("AUTO STATS")
        Toggle("Enable Auto Stats", "AutoStats")
        Toggle("Melee", "StatMelee")
        Toggle("Defense", "StatDefense")
        Toggle("Sword", "StatSword")
        Toggle("Gun", "StatGun")
        Toggle("Blox Fruit", "StatFruit")
    elseif name == "Misc" then
        Section("MISC")
        Toggle("Notifications", "Notify")
        ActionBtn("Save Config Now", function()
            SaveConfig()
            Notify("Axion", "Config salva")
        end)
        ActionBtn("Server Hop", function()
            Notify("Misc", "Server hop...")
            pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
        end)
        ActionBtn("Rejoin", function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
        ActionBtn("Destroy Hub", function()
            SaveConfig()
            ScreenGui:Destroy()
        end)
    end
end

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.Position = UDim2.new(0, 5, 0, 6 + (i-1)*48)
    btn.BackgroundColor3 = BG3
    btn.Text = tab.Icon .. "\n" .. tab.Name
    btn.TextColor3 = MUTED
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = Side
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = btn
    tabButtons[tab.Name] = btn
    btn.MouseButton1Click:Connect(function()
        LoadTab(tab.Name)
    end)
end

LoadTab("Farm")

task.spawn(function()
    while ScreenGui.Parent do
        for i = 0, 1, 0.02 do
            if not ScreenGui.Parent then break end
            TitleLabel.TextTransparency = 0.15 + 0.15 * math.sin(i * math.pi * 2)
            task.wait(0.04)
        end
    end
end)

Notify("Axion Hub v2", "Carregado • Black & Gold • Keyless", 4)
print("[Axion] Blox Fruits Hub v2.0 loaded | Keyless | Mobile optimized")
