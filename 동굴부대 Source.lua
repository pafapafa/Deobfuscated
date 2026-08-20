--!nocheck
-- [[

        원본:
            loadstring(game:HttpGet'https://luauscript-9njmj869.manus.space/api/projects/2640001/server-loader')()
        
    ]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = '\u{b3d9}\u{ad74}\u{bd80}\u{b300} | \u{b9ac}\u{ba54}\u{c774}\u{d06c}',
    LoadingTitle = '\u{b85c}\u{b529} \u{c911}...',
    LoadingSubtitle = 'by AVC \u{3163} \u{b09c}\u{b3c5}\u{d654}',
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false,
})
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local Workspace = game:GetService('Workspace')
local Teams = game:GetService('Teams')
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local KickEnabled = true
local MaxKills = 15
local KillCount = 0
local CountedKills = {}
local InfiniteAmmo = false
local WeaponModifyEnabled = false
local ESPEnabled = false
local ESPConnections = {}
local ESPData = {}
local NoclipEnabled = false
local NoclipConnection = nil
local FlyEnabled = false
local FlySpeed = 50
local FlyBodyVelocity = nil
local FlyBodyGyro = nil
local BigHeadEnabled = false
local HeadSize = 4
local OriginalHeadState = {}
local ShootAllEnabled = false
local ShootAllTask = nil
local ATMIndex = 1
local ATMPositions = {
    CFrame.new(203.51, 170.92, 181.98),
    CFrame.new(96.34, 171.13, 107.97),
    CFrame.new(-106.45, 174.33, 214.28),
    CFrame.new(-228.43, 197.95, 137.09),
    CFrame.new(-271.83, 197.76, -31.15),
    CFrame.new(-17.31, 203.32, -225.11),
}
local OutfitData = {
    ['\u{c721}\u{ad70}'] = {
        Shirt = 79985917986699,
        Pants = 127700059925360,
        Accessories = {83982474387274, 83099803300505},
    },
    ['\u{cde8}\u{c0ac}\u{bcd1}'] = {
        Shirt = 79985917986699,
        Pants = 127700059925360,
        Accessories = {18934391028},
    },
    ['\u{c758}\u{bb34}\u{bcd1}'] = {
        Shirt = 79985917986699,
        Pants = 127700059925361,
        Accessories = {107996542380666, 73825095710058},
    },
    ['\u{ad70}\u{c0ac}\u{acbd}\u{cc30}'] = {
        Shirt = 1240175738,
        Pants = 2773535966,
        Accessories = {138911539348252, 108634717681676},
    },
    ['\u{d2b9}\u{c218}\u{c784}\u{bb34}\u{b300}'] = {
        Shirt = 132763156221390,
        Pants = 9182181797,
        Accessories = {89788676232070, 85396301843767},
    },
    ['\u{d2b9}\u{c218}\u{c804}\u{c0ac}\u{b839}\u{bd80}'] = {
        Shirt = 132763156221390,
        Pants = 9182181797,
        Accessories = {71364927733047, 85396301843767},
    },
    ['\u{c870}\u{ad50}'] = {
        Shirt = 1975096281,
        Pants = 5345636999,
        Accessories = {14585469642},
    },
    ['\u{ad50}\u{ad00}'] = {
        Shirt = 8204885676,
        Pants = 2548613878,
        Accessories = {9883022320},
    },
    ['\u{bd80}\u{c0ac}\u{ad00}'] = {
        Shirt = 130145885960430,
        Pants = 12255488047,
        Accessories = {140508359474710},
    },
    ['\u{c7a5}\u{ad50}'] = {
        Shirt = 130145885960430,
        Pants = 12255488047,
        Accessories = {106533573066390},
    },
    ['\u{ad50}\u{c721}\u{c0ac}\u{b839}\u{bd80}'] = {
        Shirt = 130145885960430,
        Pants = 12255488047,
        Accessories = {106533573066390},
    },
    ['\u{bcf8}\u{bd80}'] = {
        Shirt = 10644088877,
        Pants = 263559062,
        Accessories = {},
    },
    ['\u{b808}\u{c774}\u{b354}'] = {
        Shirt = 126131032543110,
        Pants = 9542447042,
        Accessories = {12653276918},
    },
}
local R15Skeleton = {
    {
        'Head',
        'UpperTorso',
    },
    {
        'UpperTorso',
        'LowerTorso',
    },
    {
        'UpperTorso',
        'LeftUpperArm',
    },
    {
        'LeftUpperArm',
        'LeftLowerArm',
    },
    {
        'LeftLowerArm',
        'LeftHand',
    },
    {
        'UpperTorso',
        'RightUpperArm',
    },
    {
        'RightUpperArm',
        'RightLowerArm',
    },
    {
        'RightLowerArm',
        'RightHand',
    },
    {
        'LowerTorso',
        'LeftUpperLeg',
    },
    {
        'LeftUpperLeg',
        'LeftLowerLeg',
    },
    {
        'LeftLowerLeg',
        'LeftFoot',
    },
    {
        'LowerTorso',
        'RightUpperLeg',
    },
    {
        'RightUpperLeg',
        'RightLowerLeg',
    },
    {
        'RightLowerLeg',
        'RightFoot',
    },
}
local R6Skeleton = {
    {
        'Head',
        'Torso',
    },
    {
        'Torso',
        'Left Arm',
    },
    {
        'Torso',
        'Right Arm',
    },
    {
        'Torso',
        'Left Leg',
    },
    {
        'Torso',
        'Right Leg',
    },
}

local function registerKill(player)
    if not player or player == LocalPlayer or CountedKills[player] then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass('Humanoid')

    if not humanoid or humanoid.Health > 0 then
        return
    end

    local creator = humanoid:FindFirstChild('creator')

    if not creator or not creator.Value then
        return
    end

    local killer = creator.Value
    local validKiller = killer == LocalPlayer or (typeof(killer) == 'Instance' and killer:IsDescendantOf(LocalPlayer.Character))

    if not validKiller then
        return
    end

    CountedKills[player] = true

    KillCount += 1

    Rayfield:Notify({
        Title = '\u{d0ac} \u{ce74}\u{c6b4}\u{d2b8}',
        Content = string.format('\u{d604}\u{c7ac} \u{d0ac}: %d / %d', KillCount, MaxKills),
        Duration = 2,
    })

    if KillCount >= MaxKills and KickEnabled then
        LocalPlayer:Kick('PSJ \u{d5c8}\u{be0c}\u{b97c} \u{c0ac}\u{c6a9}\u{d574}\u{c8fc}\u{c2dc}\u{b294} \u{d50c}\u{b808}\u{c774}\u{c5b4}\u{bd84}\u{b4e4} \u{b354}\u{c774}\u{c0c1}\u{c5d0} \u{bb34}\u{b2e8}\u{c0ac}\u{c0b4}\u{c740} \u{c601}\u{cc3d}\u{c5d0} \u{b4e4}\u{c5b4}\u{ac08}\u{c218}\u{c788}\u{c2b5}\u{b2c8}\u{b2e4}!')
    end
end
local function watchPlayerDeaths(player)
    if player == LocalPlayer then
        return
    end

    player.CharacterAdded:Connect(function(character)
        CountedKills[player] = nil

        local humanoid = character:WaitForChild('Humanoid', 5)

        if humanoid then
            humanoid.Died:Connect(function()
                registerKill(player)
            end)
        end
    end)

    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass('Humanoid')

        if humanoid then
            humanoid.Died:Connect(function()
                registerKill(player)
            end)
        end
    end
end

for _, player in ipairs(Players:GetPlayers())do
    watchPlayerDeaths(player)
end

Players.PlayerAdded:Connect(watchPlayerDeaths)

local function modifyWeapon(tool)
    if not tool or not tool:IsA('Tool') then
        return
    end

    local infoModule = tool:FindFirstChild('Info')

    if not infoModule then
        return
    end
    if WeaponModifyEnabled then
        pcall(function()
            local info = require(infoModule)

            if type(info) ~= 'table' then
                return
            end
            if info.damage then
                info.damage.max = 999999
                info.damage.min = 999999
                info.damage.headshot = 999999
            end

            info.rpm = 999999
            info.max_ammo = 999999
            info.reload_time = 0

            if info.spread then
                info.spread.min = 0
                info.spread.max = 0
                info.spread.min_running = 0
                info.spread.mult_running = 0
                info.spread.running = 0
                info.spread.jumping = 0
            end
            if info.recoil then
                info.recoil.rotation = 0

                if info.recoil.dir then
                    info.recoil.dir.X = {0, 0}
                    info.recoil.dir.Y = {0, 0}
                end
            end
        end)
    end
    if InfiniteAmmo then
        pcall(function()
            tool:SetAttribute('ammo', math.huge)
        end)
    end
end

task.spawn(function()
    while true do
        if InfiniteAmmo or WeaponModifyEnabled then
            pcall(function()
                if LocalPlayer.Backpack then
                    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren())do
                        modifyWeapon(tool)
                    end
                end
                if LocalPlayer.Character then
                    for _, tool in ipairs(LocalPlayer.Character:GetChildren())do
                        modifyWeapon(tool)
                    end
                end
            end)
        end

        task.wait(0.2)
    end
end)

local function worldToViewport(position)
    local point, visible = Camera:WorldToViewportPoint(position)

    return Vector2.new(point.X, point.Y), visible
end
local function cleanupESP(player)
    if not ESPData[player] then
        return
    end

    pcall(function()
        local data = ESPData[player]

        if data.Highlight then
            data.Highlight:Destroy()
        end
        if data.Billboard then
            data.Billboard:Destroy()
        end
        if data.SkeletonLines then
            for _, line in ipairs(data.SkeletonLines)do
                if line and line.Remove then
                    line:Remove()
                end
            end
        end
        if data.Tracer and data.Tracer.Remove then
            data.Tracer:Remove()
        end
    end)

    ESPData[player] = nil
end
local function createESP(player)
    if player == LocalPlayer or ESPData[player] then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    local head = character:FindFirstChild('Head')
    local root = character:FindFirstChild('HumanoidRootPart')

    if not head or not root then
        return
    end

    local highlight = Instance.new('Highlight')

    highlight.Name = 'ESP_Highlight'
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(255, 50, 50)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.65
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character

    local billboard = Instance.new('BillboardGui')

    billboard.Name = 'ESP_Billboard'
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local nameLabel = Instance.new('TextLabel')

    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard

    local distanceLabel = Instance.new('TextLabel')

    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = '0m'
    distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distanceLabel.TextStrokeTransparency = 0.3
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.Parent = billboard

    local skeletonLines = {}
    local tracer = nil

    if Drawing then
        for _ = 1, 14 do
            local line = Drawing.new('Line')

            line.Visible = false
            line.Color = Color3.fromRGB(0, 255, 128)
            line.Thickness = 1.6
            line.Transparency = 1

            table.insert(skeletonLines, line)
        end

        tracer = Drawing.new('Line')
        tracer.Visible = false
        tracer.Color = Color3.fromRGB(255, 80, 80)
        tracer.Thickness = 1.3
        tracer.Transparency = 0.75
    end

    ESPData[player] = {
        Highlight = highlight,
        Billboard = billboard,
        DistLabel = distanceLabel,
        SkeletonLines = skeletonLines,
        Tracer = tracer,
    }
end
local function updateESP()
    if not ESPEnabled then
        return
    end

    local viewport = Camera.ViewportSize
    local tracerOrigin = Vector2.new(viewport.X / 2, viewport.Y - 2)
    local localCharacter = LocalPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild('HumanoidRootPart')

    for player, data in pairs(ESPData)do
        local character = player.Character

        if not character or not character:FindFirstChild('HumanoidRootPart') then
            if data.Tracer then
                data.Tracer.Visible = false
            end
            if data.SkeletonLines then
                for _, line in ipairs(data.SkeletonLines)do
                    line.Visible = false
                end
            end
        else
            local root = character.HumanoidRootPart
            local head = character:FindFirstChild('Head')

            if localRoot then
                local distance = math.floor((root.Position - localRoot.Position).Magnitude)

                data.DistLabel.Text = distance .. 'm'
            end
            if Drawing and data.SkeletonLines then
                local origin = (head and head.Position) or root.Position
                local origin2D, originVisible = worldToViewport(origin)

                if data.Tracer then
                    data.Tracer.From = tracerOrigin
                    data.Tracer.To = origin2D
                    data.Tracer.Visible = originVisible
                end

                local skeleton = (character:FindFirstChild('UpperTorso') and R15Skeleton) or R6Skeleton

                for index, pair in ipairs(skeleton)do
                    local line = data.SkeletonLines[index]

                    if line then
                        local a = character:FindFirstChild(pair[1])
                        local b = character:FindFirstChild(pair[2])

                        if a and b then
                            local a2D, aVisible = worldToViewport(a.Position)
                            local b2D, bVisible = worldToViewport(b.Position)

                            if aVisible and bVisible then
                                line.From = a2D
                                line.To = b2D
                                line.Visible = true
                            else
                                line.Visible = false
                            end
                        else
                            line.Visible = false
                        end
                    end
                end

                for index = #skeleton + 1, #data.SkeletonLines do
                    if data.SkeletonLines[index] then
                        data.SkeletonLines[index].Visible = false
                    end
                end
            end
        end
    end
end
local function setNoclip(enabled)
    local character = LocalPlayer.Character

    if not character then
        return
    end

    for _, object in ipairs(character:GetChildren())do
        if object:IsA('BasePart') then
            object.CanCollide = not enabled
        end
    end
end
local function startFly()
    local character = LocalPlayer.Character

    if not character then
        return
    end

    local root = character:FindFirstChild('HumanoidRootPart')
    local humanoid = character:FindFirstChildOfClass('Humanoid')

    if not root or not humanoid then
        return
    end

    humanoid.PlatformStand = true
    FlyBodyVelocity = Instance.new('BodyVelocity')
    FlyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlyBodyVelocity.Velocity = Vector3.zero
    FlyBodyVelocity.Parent = root
    FlyBodyGyro = Instance.new('BodyGyro')
    FlyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    FlyBodyGyro.P = 90000
    FlyBodyGyro.Parent = root

    task.spawn(function()
        while FlyEnabled and FlyBodyVelocity and FlyBodyVelocity.Parent do
            local direction = Vector3.zero
            local cameraCFrame = Camera.CFrame

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction += cameraCFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction -= cameraCFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction -= cameraCFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction += cameraCFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction += Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then
                direction -= Vector3.new(0, 1, 0)
            end
            if direction.Magnitude > 0 then
                direction = direction.Unit * FlySpeed
            end

            FlyBodyVelocity.Velocity = direction
            FlyBodyGyro.CFrame = cameraCFrame

            RunService.RenderStepped:Wait()
        end
    end)
end
local function stopFly()
    local character = LocalPlayer.Character

    if character then
        local humanoid = character:FindFirstChildOfClass('Humanoid')

        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    if FlyBodyVelocity then
        FlyBodyVelocity:Destroy()
    end
    if FlyBodyGyro then
        FlyBodyGyro:Destroy()
    end
end
local function clearOutfit(character)
    for _, object in ipairs(character:GetChildren())do
        if object:IsA('Shirt') or object:IsA('Pants') or object:IsA('ShirtGraphic') or object:IsA('Accessory') or object:IsA('Hat') or object:IsA('BodyColors') or object:IsA('CharacterMesh') then
            pcall(function()
                object:Destroy()
            end)
        end
    end
end
local function applyOutfit(teamName)
    local outfit = OutfitData[teamName]

    if not outfit then
        return
    end

    local character = LocalPlayer.Character

    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass('Humanoid')

    if not humanoid then
        return
    end

    clearOutfit(character)
    task.wait(0.3)

    if outfit.Shirt then
        pcall(function()
            local shirt = Instance.new('Shirt')

            shirt.ShirtTemplate = 'rbxassetid://' .. outfit.Shirt
            shirt.Parent = character
        end)
    end
    if outfit.Pants then
        pcall(function()
            local pants = Instance.new('Pants')

            pants.PantsTemplate = 'rbxassetid://' .. outfit.Pants
            pants.Parent = character
        end)
    end

    task.wait(0.2)

    for _, assetId in ipairs(outfit.Accessories or {})do
        task.spawn(function()
            local ok, objects = pcall(function()
                return game:GetObjects('rbxassetid://' .. assetId)
            end)

            if ok and objects and objects[1] then
                pcall(function()
                    humanoid:AddAccessory(objects[1])
                end)
            end
        end)
    end
end
local function changeTeam(teamName)
    local team = Teams:FindFirstChild(teamName)

    if not team then
        for _, candidate in ipairs(Teams:GetChildren())do
            if string.find(candidate.Name, teamName) or string.find(teamName, candidate.Name) then
                team = candidate

                break
            end
        end
    end
    if team then
        pcall(function()
            LocalPlayer.Team = team
            LocalPlayer.TeamColor = team.TeamColor
        end)
    end

    applyOutfit(teamName)
    Rayfield:Notify({
        Title = '\u{d300}\u{bcc0}\u{acbd}',
        Content = teamName .. ' \u{c801}\u{c6a9} \u{c2dc}\u{b3c4} \u{c644}\u{b8cc} (\u{bcf5}\u{c7a5}\u{c740} \u{c2e4}\u{d589}\u{ae30}\u{c5d0} \u{b530}\u{b77c} \u{c548} \u{bc14}\u{b014} \u{c218} \u{c788}\u{c74c})',
        Duration = 3,
    })
end
local function teleportTo(position, name)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = character:WaitForChild('HumanoidRootPart', 5)

    if root then
        root.CFrame = CFrame.new(position)

        Rayfield:Notify({
            Title = '\u{c21c}\u{ac04}\u{c774}\u{b3d9}',
            Content = name .. '(\u{c73c})\u{b85c} \u{c774}\u{b3d9}\u{d588}\u{c2b5}\u{b2c8}\u{b2e4}.',
            Duration = 2,
        })
    end
end
local function applyBigHead(player)
    if player == LocalPlayer or not BigHeadEnabled then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    local head = character:FindFirstChild('Head')

    if not head then
        return
    end
    if not OriginalHeadState[player] then
        OriginalHeadState[player] = {
            Size = head.Size,
            Transparency = head.Transparency,
            CanCollide = head.CanCollide,
        }
    end

    pcall(function()
        head.Size = Vector3.new(HeadSize, HeadSize, HeadSize)

        local mesh = head:FindFirstChildOfClass('SpecialMesh') or head:FindFirstChildOfClass('FileMesh')

        if mesh then
            mesh.Scale = Vector3.new(HeadSize, HeadSize, HeadSize)
        end

        head.Transparency = 0.5
        head.CanCollide = false
        head.Massless = true
    end)
end
local function restoreHead(player)
    local character = player.Character

    if not character then
        return
    end

    local head = character:FindFirstChild('Head')
    local saved = OriginalHeadState[player]

    if head and saved then
        pcall(function()
            head.Size = saved.Size
            head.Transparency = saved.Transparency or 0
            head.CanCollide = saved.CanCollide or true
            head.Massless = false

            local mesh = head:FindFirstChildOfClass('SpecialMesh') or head:FindFirstChildOfClass('FileMesh')

            if mesh then
                mesh.Scale = Vector3.new(1, 1, 1)
            end
        end)
    end
end
local function getTargets()
    local result = {}

    for _, player in ipairs(Players:GetPlayers())do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass('Humanoid')
            local root = player.Character:FindFirstChild('HumanoidRootPart')

            if humanoid and humanoid.Health > 0 and root then
                table.insert(result, player)
            end
        end
    end

    return result
end
local function equipTool()
    local character = LocalPlayer.Character

    if character then
        local equipped = character:FindFirstChildOfClass('Tool')

        if equipped then
            return equipped
        end
    end
    if LocalPlayer.Backpack then
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren())do
            if tool:IsA('Tool') then
                character = LocalPlayer.Character

                if character then
                    local humanoid = character:FindFirstChildOfClass('Humanoid')

                    if humanoid then
                        pcall(function()
                            humanoid:EquipTool(tool)
                        end)

                        return tool
                    end
                end
            end
        end
    end

    return nil
end
local function moveMouseTo(position)
    local point, visible = Camera:WorldToScreenPoint(position)

    if visible and mousemoverel then
        local viewport = Camera.ViewportSize

        mousemoverel(point.X - viewport.X / 2, point.Y - viewport.Y / 2)
    end
end
local function shootTarget(target)
    local targetCharacter = target.Character

    if not targetCharacter then
        return
    end

    local targetRoot = targetCharacter:FindFirstChild('HumanoidRootPart')
    local targetHead = targetCharacter:FindFirstChild('Head')

    if not targetRoot then
        return
    end

    local ownCharacter = LocalPlayer.Character

    if not ownCharacter then
        return
    end

    local ownRoot = ownCharacter:FindFirstChild('HumanoidRootPart')

    if not ownRoot then
        return
    end

    local targetPosition = (targetHead and targetHead.Position) or targetRoot.Position

    ownRoot.CFrame = CFrame.lookAt(targetRoot.Position + targetRoot.CFrame.LookVector * 6 + Vector3.new(0, 1.5, 0), targetPosition)

    task.wait(0.05)
    pcall(function()
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPosition)
    end)
    moveMouseTo(targetPosition)

    local tool = equipTool()

    if tool then
        local deadline = os.clock() + 0.5

        while os.clock() < deadline do
            local targetHumanoid = targetCharacter:FindFirstChildOfClass('Humanoid')

            if not targetHumanoid or targetHumanoid.Health <= 0 then
                break
            end

            pcall(function()
                tool:Activate()
            end)
            moveMouseTo(targetPosition)
            task.wait(0.05)
        end
    end
end
local function shootAllLoop()
    while ShootAllEnabled do
        local targets = getTargets()

        if #targets > 0 then
            for _, player in ipairs(targets)do
                if not ShootAllEnabled then
                    break
                end

                pcall(function()
                    shootTarget(player)
                end)
                task.wait(0.1)
            end
        end

        task.wait(0.3)
    end
end

local InfiniteTaser = false
local SavedTaserStats = {}

local function isTaser(tool)
    if not tool or not tool:IsA('Tool') then
        return false
    end

    local lowerName = string.lower(tool.Name)

    if string.find(lowerName, 'taser') or string.find(tool.Name, '\u{d14c}\u{c774}\u{c800}') then
        return true
    end

    local infoModule = tool:FindFirstChild('Info')

    if infoModule then
        local ok, info = pcall(require, infoModule)

        if ok and type(info) == 'table' then
            if info.effects and info.effects.impact == 'taser' then
                return true
            end
            if info.gui_text and info.gui_text.ammo_type and info.gui_text.ammo_type.Text == 'Lithium Battery' then
                return true
            end
        end
    end
    if tool:FindFirstChild('Handle') then
        local handle = tool.Handle

        if handle:FindFirstChild('TaserEffects') or handle:FindFirstChild('TaserSound') then
            return true
        end
    end

    return false
end
local function applyTaser(tool)
    if not isTaser(tool) then
        return
    end

    local infoModule = tool:FindFirstChild('Info')

    if not infoModule then
        return
    end

    pcall(function()
        local info = require(infoModule)

        if type(info) ~= 'table' then
            return
        end
        if not SavedTaserStats[tool] then
            SavedTaserStats[tool] = {
                damage = info.damage and {
                    max = info.damage.max,
                    min = info.damage.min,
                    headshot = info.damage.headshot,
                } or nil,
                rpm = info.rpm,
                max_ammo = info.max_ammo,
                reload_time = info.reload_time,
            }
        end
        if info.damage then
            info.damage.max = 0
            info.damage.min = 0
            info.damage.headshot = 0
        end

        info.rpm = 999999
        info.max_ammo = 999999
        info.reload_time = 0

        if info.recoil then
            info.recoil.rotation = 0

            if info.recoil.dir then
                info.recoil.dir.X = {0, 0}
                info.recoil.dir.Y = {0, 0}
            end
        end
    end)
    pcall(function()
        tool:SetAttribute('ammo', math.huge)
        tool:SetAttribute('MaxAmmo', 999999)
    end)
end
local function restoreTaser(tool)
    local infoModule = tool:FindFirstChild('Info')

    if not infoModule then
        return
    end

    local saved = SavedTaserStats[tool]

    pcall(function()
        local info = require(infoModule)

        if type(info) ~= 'table' then
            return
        end
        if saved then
            if saved.damage and info.damage then
                info.damage.max = saved.damage.max
                info.damage.min = saved.damage.min
                info.damage.headshot = saved.damage.headshot
            end

            info.rpm = saved.rpm
            info.max_ammo = saved.max_ammo
            info.reload_time = saved.reload_time
        else
            if info.damage then
                info.damage.max = 3
                info.damage.min = 1
                info.damage.headshot = 5
            end

            info.rpm = 200
            info.max_ammo = 3
            info.reload_time = 2
        end
    end)
    pcall(function()
        tool:SetAttribute('ammo', 3)
        tool:SetAttribute('MaxAmmo', 3)
    end)

    SavedTaserStats[tool] = nil
end

task.spawn(function()
    while true do
        if InfiniteTaser then
            pcall(function()
                if LocalPlayer.Backpack then
                    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren())do
                        if isTaser(tool) then
                            applyTaser(tool)
                        end
                    end
                end
                if LocalPlayer.Character then
                    for _, tool in ipairs(LocalPlayer.Character:GetChildren())do
                        if isTaser(tool) then
                            applyTaser(tool)
                        end
                    end
                end
            end)
        end

        task.wait(0.15)
    end
end)

local WeaponTab = Window:CreateTab('\u{bb34}\u{ae30}/\u{d0c4}\u{c57d}', 4483362458)

WeaponTab:CreateToggle({
    Name = '\u{d0ac} \u{c81c}\u{d55c} \u{d0a5}',
    CurrentValue = true,
    Flag = 'KickEnabled',
    Callback = function(value)
        KickEnabled = value

        Rayfield:Notify({
            Title = '\u{d0ac} \u{c81c}\u{d55c} \u{d0a5}',
            Content = value and '\u{d0a5} \u{ae30}\u{b2a5} \u{d65c}\u{c131}\u{d654}' or '\u{d0a5} \u{ae30}\u{b2a5} \u{be44}\u{d65c}\u{c131}\u{d654}',
            Duration = 2,
        })
    end,
})
WeaponTab:CreateInput({
    Name = '\u{cd5c}\u{b300} \u{d0ac} \u{c218} \u{c124}\u{c815}',
    PlaceholderText = '\u{c22b}\u{c790} \u{c785}\u{b825} \u{d6c4} \u{c5d4}\u{d130}',
    CurrentValue = '15',
    Flag = 'MaxKillsInput',
    Callback = function(value)
        local number = tonumber(value)

        if number and number >= 1 then
            MaxKills = math.floor(number)

            Rayfield:Notify({
                Title = '\u{cd5c}\u{b300} \u{d0ac} \u{c218} \u{bcc0}\u{acbd}',
                Content = '\u{cd5c}\u{b300} \u{d0ac}\u{c218}\u{ac00} ' .. MaxKills .. '\u{d0ac}\u{b85c} \u{c124}\u{c815}\u{b418}\u{c5c8}\u{c2b5}\u{b2c8}\u{b2e4}!',
                Duration = 3,
            })
        else
            Rayfield:Notify({
                Title = '\u{c624}\u{b958}',
                Content = '\u{c62c}\u{bc14}\u{b978} \u{c22b}\u{c790}\u{b97c} \u{c785}\u{b825}\u{d574}\u{c8fc}\u{c138}\u{c694} (1 \u{c774}\u{c0c1})',
                Duration = 2,
            })
        end
    end,
})
WeaponTab:CreateLabel('\u{cd5c}\u{b300} \u{ad8c}\u{c7a5} \u{d0ac}\u{c218}\u{b294} 15\u{d0ac}\u{c785}\u{b2c8}\u{b2e4}!')
WeaponTab:CreateToggle({
    Name = '\u{bb34}\u{d55c}\u{cd1d}\u{c54c}',
    CurrentValue = false,
    Flag = 'InfiniteAmmo',
    Callback = function(value)
        InfiniteAmmo = value

        Rayfield:Notify({
            Title = '\u{bb34}\u{d55c}\u{cd1d}\u{c54c}',
            Content = value and '\u{bb34}\u{d55c}\u{cd1d}\u{c54c} \u{d65c}\u{c131}\u{d654}' or '\u{bb34}\u{d55c}\u{cd1d}\u{c54c} \u{be44}\u{d65c}\u{c131}\u{d654}',
            Duration = 2,
        })
    end,
})
WeaponTab:CreateToggle({
    Name = '\u{bb34}\u{ae30} \u{c2a4}\u{d0ef} \u{adf9}\u{b300}\u{d654} (\u{b370}\u{bbf8}\u{c9c0}/\u{c5f0}\u{c0ac}/\u{bb34}\u{bc18}\u{b3d9})',
    CurrentValue = false,
    Flag = 'WeaponModifyToggle',
    Callback = function(value)
        WeaponModifyEnabled = value

        Rayfield:Notify({
            Title = '\u{bb34}\u{ae30} \u{ac1c}\u{c870}',
            Content = value and '\u{bb34}\u{ae30} \u{c2a4}\u{d0ef} \u{ac1c}\u{c870}\u{ac00} \u{d65c}\u{c131}\u{d654}\u{b418}\u{c5c8}\u{c2b5}\u{b2c8}\u{b2e4}.' or '\u{be44}\u{d65c}\u{c131}\u{d654}\u{b418}\u{c5c8}\u{c2b5}\u{b2c8}\u{b2e4}. (\u{c2a4}\u{d0ef} \u{c6d0}\u{bcf5}\u{c740} \u{b9ac}\u{c2a4}\u{d3f0} \u{d544}\u{c694})',
            Duration = 2,
        })
    end,
})
WeaponTab:CreateToggle({
    Name = '\u{baa8}\u{b4e0} \u{d50c}\u{b808}\u{c774}\u{c5b4} \u{c3d8}\u{ae30} (\u{c790}\u{b3d9}\u{c21c}\u{ac04}\u{c774}\u{b3d9})',
    CurrentValue = false,
    Flag = 'ShootAll',
    Callback = function(value)
        ShootAllEnabled = value

        if value then
            ShootAllTask = task.spawn(shootAllLoop)

            Rayfield:Notify({
                Title = '\u{c790}\u{b3d9}\u{acf5}\u{aca9}',
                Content = '\u{baa8}\u{b4e0} \u{d50c}\u{b808}\u{c774}\u{c5b4} \u{c3d8}\u{ae30} \u{d65c}\u{c131}\u{d654}',
                Duration = 2,
            })
        else
            if ShootAllTask then
                task.cancel(ShootAllTask)

                ShootAllTask = nil
            end

            Rayfield:Notify({
                Title = '\u{c790}\u{b3d9}\u{acf5}\u{aca9}',
                Content = '\u{baa8}\u{b4e0} \u{d50c}\u{b808}\u{c774}\u{c5b4} \u{c3d8}\u{ae30} \u{be44}\u{d65c}\u{c131}\u{d654}',
                Duration = 2,
            })
        end
    end,
})
WeaponTab:CreateToggle({
    Name = '\u{bb34}\u{d55c} \u{d14c}\u{c774}\u{c800} (\u{b300}\u{bbf8}\u{c9c0} 0 / \u{cd08}\u{ace0}\u{c5f0}\u{c0ac} / \u{bb34}\u{d55c}\u{d0c4})',
    CurrentValue = false,
    Flag = 'InfiniteTaser',
    Callback = function(value)
        InfiniteTaser = value

        if value then
            pcall(function()
                if LocalPlayer.Backpack then
                    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren())do
                        if isTaser(tool) then
                            applyTaser(tool)
                        end
                    end
                end
                if LocalPlayer.Character then
                    for _, tool in ipairs(LocalPlayer.Character:GetChildren())do
                        if isTaser(tool) then
                            applyTaser(tool)
                        end
                    end
                end
            end)
            Rayfield:Notify({
                Title = '\u{bb34}\u{d55c} \u{d14c}\u{c774}\u{c800}',
                Content = '\u{d14c}\u{c774}\u{c800} \u{ac1c}\u{c870} \u{d65c}\u{c131}\u{d654} (\u{b300}\u{bbf8}\u{c9c0} 0 / \u{cd08}\u{ace0}\u{c5f0}\u{c0ac} / \u{bb34}\u{d55c}\u{d0c4})',
                Duration = 2,
            })
        else
            pcall(function()
                if LocalPlayer.Backpack then
                    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren())do
                        if isTaser(tool) then
                            restoreTaser(tool)
                        end
                    end
                end
                if LocalPlayer.Character then
                    for _, tool in ipairs(LocalPlayer.Character:GetChildren())do
                        if isTaser(tool) then
                            restoreTaser(tool)
                        end
                    end
                end
            end)
            Rayfield:Notify({
                Title = '\u{bb34}\u{d55c} \u{d14c}\u{c774}\u{c800}',
                Content = '\u{d14c}\u{c774}\u{c800} \u{ac1c}\u{c870} \u{be44}\u{d65c}\u{c131}\u{d654} (\u{c6d0}\u{bcf8} \u{c2a4}\u{d0ef} \u{bcf5}\u{c6d0})',
                Duration = 2,
            })
        end
    end,
})

local PlayerTab = Window:CreateTab('\u{d50c}\u{b808}\u{c774}\u{c5b4} \u{ae30}\u{b2a5}', 4483362458)

PlayerTab:CreateToggle({
    Name = '\u{d50c}\u{b808}\u{c774}\u{c5b4} ESP',
    CurrentValue = false,
    Flag = 'ESP',
    Callback = function(value)
        ESPEnabled = value

        if value then
            for _, player in ipairs(Players:GetPlayers())do
                if player ~= LocalPlayer and player.Character then
                    createESP(player)
                end
            end

            ESPConnections.Heartbeat = RunService.Heartbeat:Connect(updateESP)

            Rayfield:Notify({
                Title = 'ESP',
                Content = '\u{d50c}\u{b808}\u{c774}\u{c5b4} ESP + \u{c2a4}\u{cf08}\u{b808}\u{d1a4} + \u{d2b8}\u{b808}\u{c774}\u{c11c} \u{d65c}\u{c131}\u{d654}',
                Duration = 2,
            })
        else
            if ESPConnections.Heartbeat then
                ESPConnections.Heartbeat:Disconnect()
            end

            for player in pairs(ESPData)do
                cleanupESP(player)
            end

            Rayfield:Notify({
                Title = 'ESP',
                Content = '\u{d50c}\u{b808}\u{c774}\u{c5b4} ESP \u{be44}\u{d65c}\u{c131}\u{d654}',
                Duration = 2,
            })
        end
    end,
})
PlayerTab:CreateToggle({
    Name = 'Noclip',
    CurrentValue = false,
    Flag = 'Noclip',
    Callback = function(value)
        NoclipEnabled = value

        if value then
            NoclipConnection = RunService.Stepped:Connect(function()
                setNoclip(true)
            end)

            Rayfield:Notify({
                Title = 'Noclip',
                Content = 'Noclip \u{d65c}\u{c131}\u{d654}',
                Duration = 2,
            })
        else
            if NoclipConnection then
                NoclipConnection:Disconnect()
            end

            setNoclip(false)
            Rayfield:Notify({
                Title = 'Noclip',
                Content = 'Noclip \u{be44}\u{d65c}\u{c131}\u{d654}',
                Duration = 2,
            })
        end
    end,
})
PlayerTab:CreateToggle({
    Name = 'Fly',
    CurrentValue = false,
    Flag = 'Fly',
    Callback = function(value)
        FlyEnabled = value

        if value then
            startFly()
            Rayfield:Notify({
                Title = 'Fly',
                Content = 'Fly \u{d65c}\u{c131}\u{d654} (WASD + Space/Ctrl)',
                Duration = 2,
            })
        else
            stopFly()
            Rayfield:Notify({
                Title = 'Fly',
                Content = 'Fly \u{be44}\u{d65c}\u{c131}\u{d654}',
                Duration = 2,
            })
        end
    end,
})
PlayerTab:CreateSlider({
    Name = 'Fly \u{c18d}\u{b3c4}',
    Range = {10, 250},
    Increment = 5,
    CurrentValue = 50,
    Flag = 'FlySpeed',
    Callback = function(value)
        FlySpeed = value
    end,
})

local TeamTab = Window:CreateTab('\u{d300}\u{bcc0}\u{acbd}', 4483362458)

TeamTab:CreateLabel('\u{26a0}\u{fe0f} \u{c774} \u{d300}\u{c740} \u{c790}\u{c2e0}\u{c5d0}\u{ac8c}\u{b9cc} \u{bcf4}\u{c774}\u{ba70}, \u{bcf5}\u{c7a5}\u{c740} \u{c2e4}\u{d589}\u{ae30}\u{c5d0} \u{b530}\u{b77c} \u{c548} \u{bc14}\u{b014} \u{c218} \u{c788}\u{c2b5}\u{b2c8}\u{b2e4}')
TeamTab:CreateLabel('\u{c7ac}\u{bbf8}\u{b85c}\u{b9cc} \u{c0ac}\u{c6a9}\u{d574}\u{c8fc}\u{c138}\u{c694} (\u{c637}\u{c774} \u{bc97}\u{aca8}\u{c9c8} \u{c218} \u{c788}\u{c74c})')

local TeamNames = {
    '\u{c721}\u{ad70}',
    '\u{cde8}\u{c0ac}\u{bcd1}',
    '\u{c758}\u{bb34}\u{bcd1}',
    '\u{ad70}\u{c0ac}\u{acbd}\u{cc30}',
    '\u{d2b9}\u{c218}\u{c784}\u{bb34}\u{b300}',
    '\u{d2b9}\u{c218}\u{c804}\u{c0ac}\u{b839}\u{bd80}',
    '\u{c870}\u{ad50}',
    '\u{ad50}\u{ad00}',
    '\u{bd80}\u{c0ac}\u{ad00}',
    '\u{c7a5}\u{ad50}',
    '\u{ad50}\u{c721}\u{c0ac}\u{b839}\u{bd80}',
    '\u{bcf8}\u{bd80}',
    '\u{b808}\u{c774}\u{b354}',
}

for _, teamName in ipairs(TeamNames)do
    TeamTab:CreateButton({
        Name = teamName,
        Callback = function()
            changeTeam(teamName)
        end,
    })
end

local TeleportTab = Window:CreateTab('\u{c21c}\u{ac04}\u{c774}\u{b3d9}', 4483362458)
local Teleports = {
    {
        Name = '\u{c5f0}\u{bcd1}\u{c7a5}',
        Pos = Vector3.new(-70.83, 170.67, 60.71),
    },
    {
        Name = '\u{c758}\u{bb34}\u{c2e4}',
        Pos = Vector3.new(-82.45, 174.33, 237.5),
    },
    {
        Name = '\u{c601}\u{cc3d}',
        Pos = Vector3.new(-30.41, 141.5, 44.96),
    },
    {
        Name = '\u{c9c0}\u{d558}',
        Pos = Vector3.new(6.04, 141.21, 67.4),
    },
    {
        Name = '\u{b808}\u{c774}\u{b354} \u{ae30}\u{c9c0}',
        Pos = Vector3.new(-197.16, 141.21, 139.67),
    },
    {
        Name = 'PX',
        Pos = Vector3.new(-225.69, 197.7, -80.57),
    },
    {
        Name = '\u{c624}\u{be44}',
        Pos = Vector3.new(-362.6, 197.44, 30.94),
    },
    {
        Name = '\u{ae09}\u{c2dd}\u{c18c}',
        Pos = Vector3.new(-283.68, 198.9, 229.38),
    },
    {
        Name = '\u{c721}\u{ad70} \u{bcf8}\u{bd80} \u{ac74}\u{bb3c}',
        Pos = Vector3.new(-283.31, 204.91, -211.72),
    },
    {
        Name = '\u{b3d9}\u{ad74} \u{ad50}\u{c721}\u{c18c}',
        Pos = Vector3.new(84.52, 203.41, -192.8),
    },
    {
        Name = '\u{ad81}\u{ae08}\u{d558}\u{ba74} \u{b20c}\u{b7ec}\u{bcf4}\u{b4e0}\u{ac00}\u{314b}',
        Pos = Vector3.new(4.66, 141.21, -23.95),
    },
    {
        Name = '\u{c911}\u{c2ec}\u{ac74}\u{bb3c}',
        Pos = Vector3.new(-245.75, 199.18, 46.98),
    },
    {
        Name = '\u{bcbd}\u{c704}\u{cabd}',
        Pos = Vector3.new(321.85, 255.69, 18.44),
    },
}

for _, entry in ipairs(Teleports)do
    TeleportTab:CreateButton({
        Name = entry.Name,
        Callback = function()
            teleportTo(entry.Pos, entry.Name)
        end,
    })
end

TeleportTab:CreateButton({
    Name = 'ATM\u{ae30} \u{c21c}\u{ac04}\u{c774}\u{b3d9}',
    Callback = function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local root = character:WaitForChild('HumanoidRootPart', 5)

        if root then
            root.CFrame = ATMPositions[ATMIndex]

            ATMIndex += 1

            if ATMIndex > #ATMPositions then
                ATMIndex = 1
            end

            Rayfield:Notify({
                Title = '\u{c21c}\u{ac04}\u{c774}\u{b3d9}',
                Content = '\u{b2e4}\u{c74c} ATM\u{ae30}\u{b85c} \u{c774}\u{b3d9}\u{d588}\u{c2b5}\u{b2c8}\u{b2e4}.',
                Duration = 2,
            })
        end
    end,
})

local HitboxTab = Window:CreateTab('hitbox', 4483362458)

HitboxTab:CreateToggle({
    Name = '\u{c0c1}\u{b300}\u{bc29} \u{ba38}\u{b9ac} \u{d06c}\u{ac8c}',
    CurrentValue = false,
    Flag = 'BigHead',
    Callback = function(value)
        BigHeadEnabled = value

        if value then
            for _, player in ipairs(Players:GetPlayers())do
                if player ~= LocalPlayer then
                    applyBigHead(player)
                end
            end

            Rayfield:Notify({
                Title = 'hitbox',
                Content = '\u{c0c1}\u{b300}\u{bc29} \u{d788}\u{d2b8}\u{bc15}\u{c2a4} \u{d655}\u{b300} \u{d65c}\u{c131}\u{d654}',
                Duration = 2,
            })
        else
            for _, player in ipairs(Players:GetPlayers())do
                restoreHead(player)
            end

            Rayfield:Notify({
                Title = 'hitbox',
                Content = '\u{be44}\u{d65c}\u{c131}\u{d654}\u{b428}',
                Duration = 2,
            })
        end
    end,
})
HitboxTab:CreateSlider({
    Name = '\u{d788}\u{d2b8}\u{bc15}\u{c2a4} \u{d06c}\u{ae30}',
    Range = {1, 150},
    Increment = 0.5,
    Suffix = '\u{bc30}',
    CurrentValue = 4,
    Flag = 'HeadSize',
    Callback = function(value)
        HeadSize = value

        if BigHeadEnabled then
            for _, player in ipairs(Players:GetPlayers())do
                if player ~= LocalPlayer then
                    applyBigHead(player)
                end
            end
        end
    end,
})
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)

    if NoclipEnabled then
        setNoclip(true)
    end
    if FlyEnabled then
        startFly()
    end
end)
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)

        if ESPEnabled then
            createESP(player)
        end
        if BigHeadEnabled then
            applyBigHead(player)
        end
    end)
end)
Players.PlayerRemoving:Connect(function(player)
    cleanupESP(player)

    OriginalHeadState[player] = nil
end)

for _, player in ipairs(Players:GetPlayers())do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(1)

            if ESPEnabled then
                createESP(player)
            end
            if BigHeadEnabled then
                applyBigHead(player)
            end
        end)
    end
end
