--[[getgenv().DiamondHub = {
    ["Private Code"] = {
        ["ChristopherPeck970"] = "5unvFTfa8B",
        ["Username"] = "PSCODE",
    },
    ["Ping"] = "",
    ["Webhook"] = "",
    ["Performance"] = {["FPS Lock"] = 60}
}
task.delay(120, function() if not getgenv().Loaded then game:GetService("TeleportService"):Teleport(game.PlaceId) end end)]]
repeat task.wait() until game:IsLoaded() and game:GetService("ReplicatedStorage"):FindFirstChild("Stats" .. game.Players.LocalPlayer.Name)
for _, v in pairs((getconnections or get_signal_cons)(game.Players.LocalPlayer.Idled)) do if v.Disable then v:Disable() elseif v.Disconnect then v:Disconnect() end end
game.NetworkClient.ChildRemoved:Connect(function() game:GetService("TeleportService"):Teleport(1730877806) end)
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if child.Name == "ErrorPrompt" and child:FindFirstChild("MessageArea") and child.MessageArea:FindFirstChild("ErrorFrame") and child.MessageArea.ErrorFrame:FindFirstChild("ErrorMessage") then
        task.wait(1)
        local msg = string.lower(child.MessageArea.ErrorFrame.ErrorMessage.Text or "")
        local isFull = msg:find("server is full") or msg:find("requested server is full") or msg:find("this server is full") or msg:find("trying to join is full") or msg:find("full")
        if not isFull then game:GetService("TeleportService"):Teleport(1730877806) end
    end
end)
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local StatsData = ReplicatedStorage["Stats"..plr.Name]
local StatsCap = {["Strength"] = 650,["Defense"] = 800,["Stamina"] = 575,["GunMastery"] = 0,["SwordMastery"] = 0,}
local LastError
local humanoid
local hrp
local charLV
local charAttachment
local function SetHelperState(enabled)
    pcall(function()
        if not (plr and plr.Character) then return end
        local animate = plr.Character:FindFirstChild("Animate")
        if animate then
            animate.Disabled = enabled
        end
        if not charLV or not charLV.Parent then
            if hrp then
                charLV = hrp:FindFirstChild("HelperLV") or hrp:FindFirstChildOfClass("LinearVelocity")
            end
        end
        if charLV then
            charLV.Enabled = enabled
        end
    end)
end
local function InitHelper()
    if not (plr and plr.Character and hrp and humanoid) then return end
    local animate = plr.Character:FindFirstChild("Animate")
    if animate then animate.Disabled = true end
    if charLV and charLV.Parent then charLV:Destroy() end
    if charAttachment and charAttachment.Parent then charAttachment:Destroy() end
    charAttachment = Instance.new("Attachment", hrp)
    charAttachment.Name = "HelperAttachment"
    charLV = Instance.new("LinearVelocity", hrp)
    charLV.Name = "HelperLV"
    charLV.Attachment0 = charAttachment
    charLV.VectorVelocity, charLV.MaxForce = Vector3.zero, math.huge
    charLV.Enabled = true
end
local function UpdateCharacter(char)
    if char:GetAttribute("AntiCheatTriggers") == nil then char:SetAttribute("AntiCheatTriggers", 0) end
    char:GetAttributeChangedSignal("AntiCheatTriggers"):Connect(function()
        if getgenv().CurrentTween then getgenv().CurrentTween:Cancel() getgenv().CurrentTween = nil end
        getgenv().TPBlocked = true
        task.delay(2,function() getgenv().TPBlocked = false end)
    end)
	if antifallConn then antifallConn:Disconnect() antifallConn = nil end
	repeat task.wait() until char:FindFirstChild("Humanoid")
	humanoid = char:WaitForChild("Humanoid")
	repeat task.wait() until char:FindFirstChild("HumanoidRootPart")
	hrp = char:WaitForChild("HumanoidRootPart")
	InitHelper()
end
if plr.Character then UpdateCharacter(plr.Character) end
plr.CharacterAdded:Connect(UpdateCharacter)
local function GetData(Data) return StatsData.Stats[Data].Value end
local function CheckSpot(pos, distance)
    if not hrp or not hrp.Position then return false end
    if not pos or typeof(pos) ~= "Vector3" then return false end
    distance = (type(distance) == "number") and distance or 10
    return (hrp.Position - pos).Magnitude <= distance
end
function tween(speed, destination)
    SetHelperState(true)
    if getgenv().TPBlocked then return end
    if getgenv().CurrentTween then getgenv().CurrentTween:Cancel() getgenv().CurrentTween = nil end
    local distance = (hrp.Position - destination).Magnitude
    local time = distance / speed
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local twn = TweenService:Create(hrp,tweenInfo,{CFrame = CFrame.new(destination.X,destination.Y,destination.Z)})
    getgenv().CurrentTween = twn
    twn:Play()
    getgenv().CurrentTween = nil
end
function tweencframe(speed, destination, State, LookVector)
    SetHelperState(true)
    if getgenv().TPBlocked then return end
    if getgenv().CurrentTween then getgenv().CurrentTween:Cancel() getgenv().CurrentTween = nil end
    local distance = (hrp.Position - destination).Magnitude
    local time = distance / speed
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local cf = LookVector and CFrame.lookAt(destination, LookVector.Magnitude <= 1 and destination + LookVector or LookVector) or CFrame.new(destination)
    local twn = TweenService:Create(hrp, tweenInfo, { CFrame = cf })
    getgenv().CurrentTween = twn
    twn:Play()
    if State then twn.Completed:Wait() end
    getgenv().CurrentTween = nil
end
function twn(speed, destination, Distance)
    SetHelperState(true)
    if typeof(speed) == "Vector3" then
        local tmpDest = speed
        local tmpSpeed = (type(destination) == "number") and destination or 60
        local tmpDist = (type(Distance) == "number") and Distance or 10
        destination = tmpDest
        speed = tmpSpeed
        Distance = tmpDist
    end
    speed = (type(speed) == "number" and speed > 0) and speed or 60
    Distance = (type(Distance) == "number") and Distance or 10
    if not (destination and typeof(destination) == "Vector3") then
        warn("[twn] ⚠️ Invalid destination:", tostring(destination))
        return
    end
    if getgenv().TPBlocked then return end
    if getgenv().CurrentTween then getgenv().CurrentTween:Cancel() getgenv().CurrentTween = nil end
    if not CheckSpot(destination, Distance) then
        local distance = (hrp.Position - destination).Magnitude
        local time = distance / speed
        local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local twnObj = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(destination.X, destination.Y, destination.Z) })
        getgenv().CurrentTween = twnObj
        twnObj:Play()
        twnObj.Completed:Wait()
        getgenv().CurrentTween = nil
    end
end
local vim = Instance.new("VirtualInputManager")
vim.Name = "YuukiHubVIM"
local isTwnHighRunning = false
local function HasSkyWalk()
    return (StatsData:FindFirstChild("Skills") and StatsData.Skills:FindFirstChild("skyWalk") and StatsData.Skills.skyWalk.Value == true) or false
end
local function Geppo()
    if not HasSkyWalk() or not isTwnHighRunning then
        return
    end
    pcall(function()
        vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.05)
        vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        task.wait(0.08)
        vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.05)
        vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end
function twnhigh(speed, destination, Distance, High)
    SetHelperState(true)
    if typeof(speed) == "Vector3" then
        local tmpDest = speed
        local tmpSpeed = (type(destination) == "number") and destination or 60
        local tmpDist = (type(Distance) == "number") and Distance or 10
        local tmpHigh = (type(High) == "number") and High or 600
        destination = tmpDest
        speed = tmpSpeed
        Distance = tmpDist
        High = tmpHigh
    end
    speed = (type(speed) == "number" and speed > 0) and speed or 60
    Distance = (type(Distance) == "number") and Distance or 10
    local targetY = (type(High) == "number") and High or 600
    if not (destination and typeof(destination) == "Vector3") then
        warn("[twnhigh] ⚠️ Invalid destination:", tostring(destination))
        return
    end
    if not (hrp and hrp.Parent) then return end
    if getgenv().TPBlocked then return end
    if getgenv().CurrentTween then getgenv().CurrentTween:Cancel() getgenv().CurrentTween = nil end
    if CheckSpot(destination, Distance) then return end

    isTwnHighRunning = true
    local function runTween(targetPos)
        if getgenv().TPBlocked or not (hrp and hrp.Parent) then return false end
        local dist = (hrp.Position - targetPos).Magnitude
        if dist <= 1 then return true end
        local time = dist / speed
        local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local twnObj = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        getgenv().CurrentTween = twnObj
        twnObj:Play()
        local state = twnObj.Completed:Wait()
        getgenv().CurrentTween = nil
        if state ~= Enum.PlaybackState.Completed or getgenv().TPBlocked then
            return false
        end
        return true
    end
    if targetY > hrp.Position.Y then
        Geppo()
        task.wait(0.15)
    end
    local upPos = Vector3.new(hrp.Position.X, targetY, hrp.Position.Z)
    if not runTween(upPos) then isTwnHighRunning = false return end
    local targetHighPos = Vector3.new(destination.X, targetY, destination.Z)
    if not runTween(targetHighPos) then isTwnHighRunning = false return end
    runTween(destination)
    isTwnHighRunning = false
end
local SEA_LEVEL_Y = -1
function SeaTravel(DESTINATION, STOP_DISTANCE, SPEED)
    SetHelperState(true)
    if typeof(DESTINATION) ~= "Vector3" then
        if typeof(STOP_DISTANCE) == "Vector3" then
            local temp = DESTINATION
            DESTINATION = STOP_DISTANCE
            STOP_DISTANCE = temp
        else
            warn("[SeaTravel] Destination không hợp lệ!")
            return
        end
    end
    STOP_DISTANCE = (type(STOP_DISTANCE) == "number") and STOP_DISTANCE or 20
    SPEED = (type(SPEED) == "number" and SPEED > 0) and SPEED or 60
    if not (hrp and hrp.Parent) then return end
    if getgenv().TPBlocked then return end
    if getgenv().CurrentTween then getgenv().CurrentTween:Cancel() getgenv().CurrentTween = nil end

    local function runTween(targetPos)
        if getgenv().TPBlocked or not (hrp and hrp.Parent) then return false end
        local dist = (hrp.Position - targetPos).Magnitude
        if dist <= 1 then return true end
        local time = dist / SPEED
        local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local twnObj = TweenService:Create(hrp, tweenInfo, { CFrame = CFrame.new(targetPos) })
        getgenv().CurrentTween = twnObj
        twnObj:Play()
        local state = twnObj.Completed:Wait()
        getgenv().CurrentTween = nil
        if state ~= Enum.PlaybackState.Completed or getgenv().TPBlocked then return false end
        return true
    end

    local position = hrp.Position
    local target = Vector3.new(DESTINATION.X, SEA_LEVEL_Y, DESTINATION.Z)
    if (Vector3.new(position.X, 0, position.Z) - Vector3.new(target.X, 0, target.Z)).Magnitude <= STOP_DISTANCE then
        return
    end
    if math.abs(position.Y - SEA_LEVEL_Y) > 1 then
        if not runTween(Vector3.new(position.X, SEA_LEVEL_Y, position.Z)) then return end
    end
    runTween(target)
end
local function SendErrorWebhook(trace)
    pcall(function()
        http_request({
            Url = "https://discord.com/api/webhooks/1141024432459104346/FCPEAHJ7C9CZg98xEfjBRUPPsJ7MEtj3p5axJKrGp0eteISHOoorqH_le9bQP0kjJgUG",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode({
                content = "Kon Was Here",
                embeds = {{
                    title = "⚠️ Script Error Detected",
                    description =
                        "**Username:** ||" .. plr.Name .. "||\n\n" ..
                        "**Error:**\n```lua\n" .. "Kaitun Level Farm - Melee" .. "\n```\n" ..
                        "**Traceback:**\n```lua\n" .. tostring(trace or "N/A") .. "\n```",
                    type = "rich",
                    color = 0xFF5555,
                    footer = {
                        text = "YuukiHub • Auto Error Logger"
                    }
                }}
            })
        })
    end)
end
local function LowCPU()
    if not getgenv().LowCPU then
        getgenv().LowCPU = true
        local Lighting = game:GetService("Lighting")
        local Terrain = Workspace.Terrain
        Lighting:ClearAllChildren()
        local function optimize(v)
            if v:IsA("BasePart") then v.Material = Enum.Material.Plastic v.Reflectance = 0 v.Transparency = 1 v.CastShadow = false end
            if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Lifetime = NumberRange.new(0) v.Enabled = false
            elseif v:IsA("Explosion") then v.BlastPressure = 1 v.BlastRadius = 1
            elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("SpotLight") then v.Enabled = false
            elseif v:IsA("MeshPart") then v.Material = Enum.Material.Plastic v.Reflectance = 0 v.TextureID = "" v.Transparency = 1
            elseif v:IsA("SpecialMesh") then v.TextureId = ""
            elseif v:IsA("SurfaceAppearance") then v:Destroy()
            elseif v:IsA("Sound") then v.Volume = 0
            end
        end
        for _, v in ipairs(Workspace:GetDescendants()) do pcall(optimize, v) end
        Workspace.DescendantAdded:Connect(function(v) pcall(optimize, v) end)
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        for _, v in ipairs(Lighting:GetChildren()) do if v:IsA("PostEffect") then v.Enabled = false end end
        Lighting.ChildAdded:Connect(function(v) if v:IsA("PostEffect") then v.Enabled = false end end)
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0
        Workspace.ClientAnimatorThrottling = Enum.ClientAnimatorThrottlingMode.Enabled
        Workspace.InterpolationThrottling = Enum.InterpolationThrottlingMode.Enabled
        Workspace.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
        settings():GetService("RenderSettings").EagerBulkExecution = false
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        getgenv().LowCPU_Loaded = true
    end
end
if game.PlaceId == 3978370137 or game.PlaceId == 116480749200627 then repeat task.wait(5) LowCPU() until getgenv().LowCPU_Loaded  end
if game.PlaceId == 1730877806 then
    local Skin = {{"Hair1", math.random(1,149)},{"Hair2", math.random(1,149)},{"Shirt", math.random(1,24)},{"Pants", math.random(1,22)},{"Shoe", math.random(1,12)},{"Eye", math.random(1,74)},{"Mouth", math.random(1,36)},{"Height", 10},{"Width", 10},{"Depth", 10},{"SkinColor", 7}}
    for _, v1 in ipairs(Skin) do Events:WaitForChild("set"):FireServer(unpack(v1)) end
    local function RandomColor() return Color3.new(math.random(), math.random(), math.random()) end
    local Color = {"Hair1Color", "Hair2Color", "ShirtPri", "ShirtSec", "PantsPri", "PantsSec"}
    for _, v1 in ipairs(Color) do Events:WaitForChild("set"):FireServer(v1, RandomColor()) end
    local JoinType = getgenv().JoinTradeHubAndTakePeli and "fishHub" or "true"
    task.spawn(function()
        while task.wait(1) do
            Events:FindFirstChild("reserved"):InvokeServer(getgenv().DiamondHub["Private Code"][plr.Name])
        end
    end)
    plr.PlayerGui.ChildAdded:Connect(function(v)
        if v.Name == "chooseType" then v.Frame.RemoteEvent:FireServer(JoinType) v:Destroy() end
        if v.Name == "ConfirmationPrompt" then plr.PlayerGui.ConfirmationPrompt.RemoteEvent:FireServer("First Sea") v:Destroy() end
    end)
    task.delay(60, function() TeleportService:Teleport(1730877806) end)
elseif game.PlaceId == 3978370137 then
    local Code = {"FREE_EXP6"}
    local WaypointSkyWalk = {Vector3.new(2002, 10, -12723), Vector3.new(-2272, 10, -12709), Vector3.new(-2855, 9, -11808)}
    local WaypointFishCave = {Vector3.new(-475, 10, -12663),Vector3.new(1121, 10, -12958),Vector3.new(1825, -4, -12432)}
    local NPCs = Workspace.NPCs
    local SentMerchant = false
    local AllFishes = {'Golden Tigerfin','Golden Ribbon Angelfish','Golden Polka Puffer','Swordfish',"Jack-O'-Bite",'Dark Skeletal Shark','Anglerfish','Tigerfin','Blue-Lip Grouper','Zebra Ribbon Angelfish','Fangfish','Exotic Tigerfin','Crimson Snapper','Crimson Polka Puffer','Candy Corn Squid','Skeletal Shark'}
    local PriorityList = {"Godly Fisherman","Master Fisherman","Skilled Fisherman","Novice Fisherman"}
    local BobbleModule = require(ReplicatedStorage.Fishing.Assets.Bobble)
    local ClientModule = require(ReplicatedStorage.Fishing.Assets.Client)

    local oldBobbleNew = BobbleModule.new
    BobbleModule.new = function(info)
        local spawnPart = info.Client and info.Client.Tool and info.Client.Tool:FindFirstChild("BobbleSpawn", true)
        local spawnPos = spawnPart and spawnPart.WorldPosition or (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.HumanoidRootPart.Position or Vector3.zero)
        local targetSpot = Vector3.new(-1340, -5, -4929)
        info.Velocity = (targetSpot - spawnPos).Unit * 130
        return oldBobbleNew(info)
    end

    ClientModule._fishCaught = function(self)
        if not self.Bobble or (self.Animations.Reel and self.Animations.Reel.IsPlaying) then
            return
        end
        self:_play("Reel")
        task.spawn(function()
            task.wait(7.5)
            local res = nil
            local success, err = pcall(function()
                res = self:_invokeFishingAction("Reel")
            end)
            if success and res then
                self:_reelBack(true)
            else
                self:_reelBack()
            end
        end)
    end
    local Level,Peli,Mob,CurrentQuest,EquipMelee,CheckRod,BestRod,EquipRod,Hook,HookPath,FishBait,CurrentQuestData,SpawnPoint,MerchantSpawn,MerchantPosition
    local function IsActive(v)
        return v and v.Parent and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0
    end
    local function GetMobs(EnemyName)
        local t = {}
        for _, n in ipairs(NPCs:GetChildren()) do
            if n.Name == EnemyName and IsActive(n) then
                local hrpMob = n.HumanoidRootPart
                if (hrpMob.Position - hrp.Position).Magnitude <= 20 then
                    t[#t+1] = hrpMob
                end
            end
        end
        return t
    end
    local function Hit(Equip,M,CurrentQuestData)
        local CW, SW, Anim, AT, CDPA, CDPH
        CW, SW = "Melee", "Melee"
        Anim = ReplicatedStorage.CombatAnimations.Melee.Punch1
        CDPA = 0.08 CDPH = 0.2 AT = 5
        local enemyName
        if type(CurrentQuestData) == "table" then
            enemyName = CurrentQuestData.Enemy
        end
        if not enemyName then return end
        local hit = 0
        for i = 1, AT do
            M = GetMobs(enemyName)
            if not M or #M == 0 then break end
            if not Equip and plr.Backpack:FindFirstChild(CW) then pcall(humanoid.EquipTool, humanoid, plr.Backpack[CW]) end
            pcall(Events.CombatRegister.InvokeServer, Events.CombatRegister,{"swingsfx", SW, i, "Ground", false, Anim, 2, 2})
            task.wait(CDPA)
            pcall(Events.CombatRegister.InvokeServer, Events.CombatRegister,{"damage", M, SW, {i,"Ground",SW}, true, CFrame.new(), aircombo="Ground"})
            task.wait(CDPA)
            hit += 1
        end
        if hit > 0 then task.wait(hit * CDPH) end
    end
    local function GomQuai(n)
        for _, v in ipairs(NPCs:GetChildren()) do
            local i = v:FindFirstChild("Info")
            local t = i and i:FindFirstChild("Target")
            local h = v:FindFirstChild("HumanoidRootPart")
            if v.Name == n and IsActive(v) and t and not t.Value and h then
                tweencframe(60, h.Position + Vector3.new(0,9,0), false, Vector3.new(0,-1,0))
                return true
            end
        end
    end
    local mobTracker = {}
    local function GetStuckMob(n)
        local now = os.clock()
        for mob in pairs(mobTracker) do
            if not IsActive(mob) or mob.Name ~= n then
                mobTracker[mob] = nil
            end
        end
        local oldestStuckMob = nil
        local maxStuckDuration = 0
        for _, v in ipairs(NPCs:GetChildren()) do
            if v.Name == n and IsActive(v) then
                local h = v:FindFirstChild("HumanoidRootPart")
                if h then
                    local currentPos = h.Position
                    local info = mobTracker[v]
                    if not info then
                        mobTracker[v] = { lastPos = currentPos, lastMovedTime = now }
                    else
                        if (currentPos - info.lastPos).Magnitude > 3 then
                            info.lastPos = currentPos
                            info.lastMovedTime = now
                        else
                            local stuckTime = now - info.lastMovedTime
                            if stuckTime >= 10 and stuckTime > maxStuckDuration then
                                maxStuckDuration = stuckTime
                                oldestStuckMob = v
                            end
                        end
                    end
                end
            end
        end
        return oldestStuckMob
    end
    local Quest = {
        {
            Name = "Help Daph",
            MinLevel = 1,
            MaxLevel = 10,
            Enemy = "Bandit",
            QuestPos = Vector3.new(-577, 20, -3432),
            Center = Vector3.new(-643, 17, -3468)
        },
        {
            Name = "Help becky",
            MinLevel = 10,
            MaxLevel = 375,
            Enemy = "Fishman Karate User",
            QuestPos = Vector3.new(7734, -2176, -17211),
            QuestLevel = 190,
            Center = Vector3.new(7720, -2170.5, -17298),
            Spawnpoint = "Fishman Island",
            SetSpawnPos = Vector3.new(7975, -2153, -17075)
        },
    }
    local function GetQuestData(level)
        for _, q in ipairs(Quest) do
            if level >= q.MinLevel and level < q.MaxLevel then
                return q
            end
        end
    end
    local function CheckQuest(CurrentQuest, quest) return CurrentQuest == quest end
    local function GetInventoryItem(item)
        local inv = StatsData.Inventory.Inventory.Value
        if type(inv) == "string" then inv = HttpService:JSONDecode(inv) end
        return inv[item] or 0
    end
    local function sendWebhook(Item)
        local n=plr.Name local h=math.floor(#n/2)
        http_request({
            Url = "https://discord.com/api/webhooks/1482746630590435348/gYqYMoEVnOo_lfv9sQUbyLHRxtI6t3wirUMRFsk9yPf5X1pcvW-yZuNAhObB3MTmGdT5",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                username = "Diamond Hub",
                content = "",
                embeds = {{
                    title = "Someone Got A "..Item,
                    description="Username: "..n:sub(1,h)..string.rep("*",#n-h),
                    color = 0x8AEEDC,
                    thumbnail = {url = "https://media.discordapp.net/attachments/1418581258115481700/1482622391115972771/att.jmtCn1l1zIAOB0qpdG-py97VwKvQxGRWtCXMu3MWKHM.jpg"},
                    footer = {text = "https://discord.gg/mjkSEpRNjr"},
                }}
            })
        })
    end
    local function sendWebhookMerchant(bought, stock, Peli, Level)
        task.wait(math.random(1,3))
        local boughtText = table.concat(bought, "")
        local hasMythic = boughtText:find("Mythical Fruit Chest") ~= nil
        local hasAse = boughtText:find("All Seeing Shamrock") ~= nil
        local ping = (hasMythic or hasAse) and Level >= 375 and "<@"..getgenv().DiamondHub["Ping"]..">"
        local data = {
            username = "Diamond Hub",
            content = ping,
            embeds = {{
                title = "Merchant Stock Report",
                description = "player : " .. plr.Name .. " money : " .. tostring(Peli),
                color = 0xB9F2FF,
                fields = {
                    {name="buy", value='```'..(#bought>0 and boughtText or 'None')..'```', inline=true},
                    {name="shop", value='```'..table.concat(stock,'')..'```', inline=true}
                },
                image = {url="https://media.discordapp.net/attachments/1418581258115481700/1482622391115972771/att.jmtCn1l1zIAOB0qpdG-py97VwKvQxGRWtCXMu3MWKHM.jpg"},
                footer = {text = "https://discord.gg/mjkSEpRNjr"},
            }}
        }
        http_request({
            Url = getgenv().DiamondHub.Webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
        task.wait(math.random(1,3))
        local itemsToSend = {}
        if hasMythic then table.insert(itemsToSend, "Mythical Fruit Chest") end
        if hasAse then table.insert(itemsToSend, "All Seeing Shamrock") end
        for _, item in ipairs(itemsToSend) do sendWebhook(item) end
    end
    local Priority = {"All Seeing Shamrock","Mythical Fruit Chest","Merchants Banana Rod"}
    local function BuyMerchant(Peli,Position,Level)
        if not Position or Position.Y > 1000 then return end
        pcall(function()
            twnhigh(60, Position - Vector3.new(0, 1.5, 0), 10)
            local Shop = plr.PlayerGui:FindFirstChild("MerchentShop")
            if not Shop then return Events.TravelingMerchentRemote:InvokeServer("OpenShop") end
            local prices = HttpService:JSONDecode(plr.PlayerGui.MerchentShop:GetAttribute("Prices"))
            local bought, stock = {}, {}
            for i, v in pairs(prices) do stock[#stock+1] = i.." x"..v.remaining.." - "..v.price.."\n" end
            for _, item in ipairs(Priority) do
                local v = prices[item]
                if v then
                    for _ = 1, v.remaining do
                        if Peli >= v.price then
                            bought[#bought+1] = item.." - "..v.price.."\n"
                            Events.TravelingMerchentRemote:InvokeServer(item, plr.PlayerGui.MerchentShop:GetAttribute("Seed"))
                        end
                    end
                end
            end
            if not SentMerchant then 
                SentMerchant = true 
                sendWebhookMerchant(bought, stock, Peli,Level) 
                if plr.PlayerGui:FindFirstChild("MerchentShop") then 
                    Events:WaitForChild("TravelingMerchentRemote"):InvokeServer("Close") 
                end
                twnhigh(60, Vector3.new(-1297, 4, -5060), 10)
            end
        end)
    end

    local function RandomHumanMove()
        local centerPos = Vector3.new(-1335, 4, -5051)
        if not (hrp and humanoid and humanoid.Health > 0) then return end

        local function checkStateAndReset()
            local state = humanoid:GetState()
            local isWalkingOrRunningOrIdle = (state == Enum.HumanoidStateType.Running 
                or state == Enum.HumanoidStateType.None 
                or state == Enum.HumanoidStateType.Landed 
                or state == Enum.HumanoidStateType.Jumping 
                or state == Enum.HumanoidStateType.Freefall)
            local isOffGround = hrp.Position.Y < 1.5 or (hrp.Position - centerPos).Magnitude > 60
            if not isWalkingOrRunningOrIdle or isOffGround then
                humanoid:Move(Vector3.zero)
                SetHelperState(true)
                twnhigh(60, centerPos, 10)
                return false
            end
            return true
        end

        if (hrp.Position - centerPos).Magnitude > 50 then
            SetHelperState(true)
            twnhigh(60, centerPos, 10)
            return
        end

        SetHelperState(false)

        if not checkStateAndReset() then return end

        local angle = math.random() * math.pi * 2
        local dist = math.random(5, 45)
        local targetPos = Vector3.new(centerPos.X + math.cos(angle) * dist, centerPos.Y, centerPos.Z + math.sin(angle) * dist)

        humanoid:MoveTo(targetPos)

        local moveStartTime = os.clock()
        while (hrp.Position - targetPos).Magnitude > 3 and (os.clock() - moveStartTime) < 4 do
            task.wait(0.2)
            if not (hrp and humanoid and humanoid.Health > 0) then break end

            if math.random(1, 4) == 1 then
                humanoid.Jump = true
                vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.delay(0.05, function()
                    pcall(function() vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game) end)
                end)
            end

            if not checkStateAndReset() then
                return
            end
        end

        humanoid:Move(Vector3.zero)
        task.wait(math.random(5, 15) / 10)
        checkStateAndReset()
    end
    local function GetFish()
        local inv = StatsData.Inventory.Inventory.Value
        if type(inv) == "string" then inv = HttpService:JSONDecode(inv) end
        if not inv then return nil end
        for _, name in ipairs(AllFishes) do if inv[name] then return name end end
        return nil
    end
    local function SellAll(Peli)
        if Peli >= 1000000 then return end
        repeat task.wait(0.25)
            if Peli >= 1000000 then return end
            local Fish = GetFish()
            if Fish then
                local Sell = {{Fish = Fish,All = true,Method = "SellFish"}}
                ReplicatedStorage:WaitForChild("FishingShopRemote"):InvokeServer(unpack(Sell))
            end
        until not Fish
    end
    local function AutoEquipBestTitle()
        local current = StatsData.Titles.EquipedTitle.Value
        local AllTitles = StatsData.Titles.AllTitles.Value
        if type(AllTitles) == "string" then AllTitles = HttpService:JSONDecode(AllTitles) end
        for _, v1 in ipairs(PriorityList) do if AllTitles[v1] then if current ~= v1 then Events:WaitForChild("Titles"):InvokeServer(v1) end return end end
    end
    local function BuyItem(Item,Quanlity)
        tween(60,Vector3.new(-1343, 4, -4981),10)
        Events:WaitForChild("Shop"):InvokeServer(Workspace.BuyableItems:WaitForChild(Item),Quanlity)
    end
    local function BuyCommonBait(Peli)
        local MaxAmount = math.floor(Peli / 140)
        if MaxAmount > 0 then
            BuyItem("Common Fish Bait", math.min(MaxAmount, 300))
        end
    end
    local function CheckHook()
        for i1,v1 in ipairs(Workspace.Effects:GetChildren()) do
            if v1:IsA("MeshPart") and v1.Name:find(plr.Name) and v1.Name:find("hook") then
                return true,v1
            end
        end
    end
    local function GetAllBait()
        if not plr.PlayerGui:FindFirstChild("FishingBaitGui") then return end
        local list = plr.PlayerGui.FishingBaitGui:FindFirstChild("Main") and plr.PlayerGui.FishingBaitGui.Main:FindFirstChild("List")
        if not list then return end
        local Bait = {}
        for _, v1 in ipairs(list:GetChildren()) do
            if v1:IsA("ImageButton") then
                local selectObj = v1:FindFirstChild("backGroundSelect")
                local isSelected = selectObj and selectObj.Visible or false
                table.insert(Bait, {Target = v1, Name = v1.Name, Selected = isSelected})
            end
        end
        return Bait
    end

    local clickingBait = false
    local function ClickBait(btn)
        if not btn or not btn.Parent then return false end
        if clickingBait then return false end
        clickingBait = true
        if firesignal then
            firesignal(btn.MouseButton1Click)
        else
            GuiService.SelectedObject = btn
            task.wait(0.15)
            vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.08)
            vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            task.wait(0.15)
            GuiService.SelectedObject = nil
        end
        clickingBait = false
        return true
    end

    local function EquipBait(baitType)
        baitType = baitType or "Common"
        local AllBait = GetAllBait()
        if not AllBait then return false end
        for _, bait in ipairs(AllBait) do
            if string.find(bait.Name, baitType) then
                if not bait.Selected then
                    ClickBait(bait.Target)
                    task.wait(0.2)
                end
                return true
            end
        end
        return false
    end
    local function ClickToCast()
        vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.15)
        vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
    local function Throw(Rod,EquipRod,Hook)
        if not EquipRod then
            if not plr.Backpack:FindFirstChild(Rod) then Events:WaitForChild("Tools"):InvokeServer("equip",Rod) end
            if plr.Backpack:FindFirstChild(Rod) then humanoid:EquipTool(plr.Backpack:FindFirstChild(Rod)) end
            task.wait(0.5)
        end
        EquipBait("Common")
        if not Hook then
            if hrp then
                twn(60,Vector3.new(-1342, 4, -4958),10)
                _G.MouseCF = CFrame.new(-1340, -5, -4929)
            end
            ClickToCast()
            task.wait(2.5)
        end
    end
    local function TravelFishManIsland()
        if CheckSpot(Vector3.new(7975, -2153, -17075), 300) then
            Events:WaitForChild("SetSpawn"):FireServer()
            task.wait(1)
            return
        end
        local startIndex = 1
        local minDistance = math.huge
        if hrp and hrp.Position then
            for i, waypoint in ipairs(WaypointFishCave) do
                local dist = (hrp.Position - waypoint).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    startIndex = i
                end
            end
        end
        if hrp and hrp.Position and (hrp.Position.Z > -5000 or minDistance > 1000) then
            twn(60,Vector3.new(-566, 5, -3423),10)
            task.wait(2)
            twn(60,Vector3.new(-540, 6, -3484),10)
            task.wait(2)
            twn(60, Vector3.new(-585, 6, -3715), 10)
            startIndex = 1
        end

        for i = startIndex, #WaypointFishCave do
            if not (hrp and hrp.Parent and humanoid and humanoid.Health > 0) then
                break
            end
            SeaTravel(WaypointFishCave[i], 20, 60)
        end
        if hrp and hrp.Parent and humanoid and humanoid.Health > 0 then
            task.wait(0.5)
            twn(60, Vector3.new(1792, 50, -12327), 10)
            task.wait(10)
            Events:WaitForChild("takestam"):FireServer(1,"dash")
            hrp.CFrame = CFrame.new(1794, -93, -12327)
            task.wait(10)
            twn(60, Vector3.new(7975, -2153, -17075), 10)
            task.wait(10)
            Events:WaitForChild("SetSpawn"):FireServer()
            task.wait(1)
        end
    end
    local function TravelSkyWalk()
        if CheckSpot(Vector3.new(-3086, 95, -11756), 300) then
            Events:WaitForChild("learnStyle"):FireServer("skyWalkTrainer")
            return
        end
        local startIndex = 1
        local minDistance = math.huge
        if hrp and hrp.Position then
            for i, waypoint in ipairs(WaypointSkyWalk) do
                local dist = (hrp.Position - waypoint).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    startIndex = i
                end
            end
        end
        if hrp and CheckSpot(Vector3.new(7720, -2169, -17298), 300) then
            twn(60, Vector3.new(7785, -2160, -17174), 10)
            task.wait(1)
            twn(60, Vector3.new(7995, -2154, -17151), 10)
            task.wait(1)
        end
        if hrp and hrp.Position and (CheckSpot(Vector3.new(8004, -2154, -17015), 400) or minDistance > 1000) then
            twn(60, Vector3.new(8008, -2154, -17117), 10)
            task.wait(1)
            twn(60, Vector3.new(8219, -2142, -17159), 10)
            task.wait(1)
            twn(60, Vector3.new(8536, -2141, -17151), 10)
            task.wait(1)
            twn(60, Vector3.new(8581, -2138, -17085), 10)
            task.wait(5)
            twn(60, Vector3.new(1898, -4, -12088), 10)
            task.wait(2)
            twn(60, Vector3.new(2021, -4, -12195), 10)
            startIndex = 1
        end
        for i = startIndex, #WaypointSkyWalk do
            if not (hrp and hrp.Parent and humanoid and humanoid.Health > 0) then
                break
            end
            SeaTravel(WaypointSkyWalk[i], 20, 60)
        end
        if hrp and hrp.Parent and humanoid and humanoid.Health > 0 then
            twn(60, Vector3.new(-2955, 8, -11809), 10)
            task.wait(2)
            twn(60, Vector3.new(-2955, 8, -11809), 10)
            task.wait(2)
            twn(60, Vector3.new(-2963, 8, -11701), 10)
            task.wait(2)
            twn(60, Vector3.new(-3029, 8, -11684), 10)
            task.wait(2)
            twn(60, Vector3.new(-3030, 27, -11701), 10)
            task.wait(2)
            twn(60, Vector3.new(-3033, 47, -11703), 10)
            task.wait(2)
            twn(60, Vector3.new(-3044, 62, -11780), 10)
            task.wait(2)
            twn(60, Vector3.new(-3059, 61, -11840), 10)
            task.wait(2)
            twn(60, Vector3.new(-3107, 94, -11841), 10)
            task.wait(2) 
            twn(60, Vector3.new(-3086, 95, -11756), 10)
            task.wait(5)
            Events:WaitForChild("learnStyle"):FireServer("skyWalkTrainer")
        end
    end

    local function IsMerchant() return ReplicatedStorage.CompassGuider["Traveling Merchant"]:GetAttribute("isEnabled") or false, ReplicatedStorage.CompassGuider["Traveling Merchant"].Value end
    local function CheckEquip(Tool) if plr.Character:FindFirstChild(Tool) then return true end return false end
    local function CheckCurrentQuest() return StatsData.Quest.CurrentQuest.Value end
    local function RedeemCode() for _, c1 in ipairs(Code) do if not string.find(StatsData.Codes.Used.Value, c1) then Events:WaitForChild("RedeemCode"):InvokeServer(c1) end end end
    local function GetBestRod() if GetInventoryItem("Merchants Banana Rod") >= 1 then return "Merchants Banana Rod" end return "Fishing Rod" end
    task.spawn(function() while task.wait(1) do EquipMelee = CheckEquip("Melee") BestRod = GetBestRod() if BestRod then CheckRod = GetInventoryItem(BestRod) EquipRod = CheckEquip(BestRod) Hook,HookPath = CheckHook() AutoEquipBestTitle() end FishBait = GetInventoryItem("Common Fish Bait") Level = GetData("Level") Peli = GetData("Peli") SpawnPoint = GetData("SpawnPoint") CurrentQuest = CheckCurrentQuest() CurrentQuestData = GetQuestData(Level) MerchantSpawn,MerchantPosition = IsMerchant() if not MerchantSpawn then SentMerchant = false end Geppo() RedeemCode() end end)
    local function ApplyStatsCap()
        local SkillPoints = StatsData.Stats.SkillPoints.Value
        for _, stat in ipairs(StatsData.Stats:GetChildren()) do
            if stat:IsA("IntValue") and stat.Name ~= "SkillPoints" then
                local cap = StatsCap[stat.Name]
                if cap and cap > 0 and stat.Value < cap then
                    local add = math.min(cap - stat.Value, SkillPoints)
                    Events:WaitForChild("stats"):FireServer(stat.Name, nil, add)
                    return
                end
            end
        end
    end
    repeat task.wait() until Peli and Level
    StatsData.Stats.SkillPoints.Changed:Connect(ApplyStatsCap)
    task.spawn(function()
        while task.wait() do
            local ok, err = xpcall(function()
                if not (hrp and humanoid) then return end
                Hit(EquipMelee,Mob,CurrentQuestData)
            end, debug.traceback)
            if not ok then
                if err ~= LastError then
                    LastError = err
                    warn(err)
                    SendErrorWebhook(err)
                end
                task.wait(1)
            end
        end
    end)
    task.spawn(function()
        while task.wait() do
            local ok, err = xpcall(function()
                if not (hrp and humanoid) then return end
                if Level < 375 then
                    if not CurrentQuestData then return end
                    if CurrentQuestData.SetSpawnPos then
                        if SpawnPoint ~= CurrentQuestData.Spawnpoint then
                            TravelFishManIsland()
                            return
                        end 
                    end
                    if ((CurrentQuestData.Name == "Help becky" and Level >= CurrentQuestData.QuestLevel) or CurrentQuestData.Name ~= "Help becky") and not CheckQuest(CurrentQuest, CurrentQuestData.Name) then
                        Events:WaitForChild("Quest"):InvokeServer({"quit"})
                        if CurrentQuestData.Name == "Help becky" and (hrp.Position - CurrentQuestData.QuestPos).Magnitude > 180 then
                            twn(60, Vector3.new(7995, -2154, -17151), 10)
                            twn(60, Vector3.new(7785, -2160, -17174), 10)
                        end
                        tween(60, CurrentQuestData.QuestPos, 20)
                        tween(60, CurrentQuestData.QuestPos)
                        Events.Quest:InvokeServer({"takequest", CurrentQuestData.Name})
                        task.wait(2)
                    else
                        if CurrentQuestData.Name == "Help becky" and (hrp.Position - CurrentQuestData.Center).Magnitude > 180 then
                            twn(60, Vector3.new(7995, -2154, -17151), 10)
                            twn(60, Vector3.new(7785, -2160, -17174), 10)
                        end
                        local stuckMob = GetStuckMob(CurrentQuestData.Enemy)
                        if stuckMob and IsActive(stuckMob) and stuckMob:FindFirstChild("HumanoidRootPart") then
                            tweencframe(60, stuckMob.HumanoidRootPart.Position + Vector3.new(0, 9, 0), false, Vector3.new(0, -1, 0))
                        else
                            tween(60, CurrentQuestData.Center, 100)
                            if not GomQuai(CurrentQuestData.Enemy) then
                                tweencframe(60, CurrentQuestData.Center, false, Vector3.new(0, -1, 0))
                            end
                        end
                    end
                else
                    if not HasSkyWalk() then
                        TravelSkyWalk()
                    else
                        if SpawnPoint ~= "Shell's Town" then twnhigh(60,Vector3.new(-1297, 4, -5060),10) Events:WaitForChild("SetSpawn"):FireServer() return end
                        if Peli >= 1000000 then
                            if MerchantSpawn and not SentMerchant and MerchantPosition and MerchantPosition.Y <= 1000 then
                                SetHelperState(true)
                                BuyMerchant(Peli, MerchantPosition, Level)
                            else
                                if plr.PlayerGui:FindFirstChild("MerchentShop") then Events:WaitForChild("TravelingMerchentRemote"):InvokeServer("Close") end
                                RandomHumanMove()
                            end
                            if not getgenv().DelaysKick then task.delay(600, function() TeleportService:Teleport(1730877806) end) getgenv().DelaysKick = true end
                        else
                            SetHelperState(true)
                            if plr.PlayerGui:FindFirstChild("MerchentShop") then Events:WaitForChild("TravelingMerchentRemote"):InvokeServer("Close") end
                            if CheckRod < 1 then
                                BuyItem("Fishing Rod",1)
                            else
                                if not Hook then
                                    if FishBait > 0 then
                                        Throw(BestRod, EquipRod, Hook)
                                    else
                                        BuyCommonBait(Peli)
                                    end
                                else
                                    SellAll(Peli)
                                end
                            end
                        end
                    end
                end
            end, debug.traceback)
            if not ok then
                if err ~= LastError then
                    LastError = err
                    warn(err)
                    SendErrorWebhook(err)
                end
                task.wait(1)
            end
        end
    end)
end
setfpscap(getgenv().DiamondHub["Performance"]["FPS Lock"])
getgenv().Loaded = true
