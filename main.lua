local __DARKLUA_BUNDLE_MODULES __DARKLUA_BUNDLE_MODULES={cache={}, load=function(m)if not __DARKLUA_BUNDLE_MODULES.cache[m]then __DARKLUA_BUNDLE_MODULES.cache[m]={c=__DARKLUA_BUNDLE_MODULES[m]()}end return __DARKLUA_BUNDLE_MODULES.cache[m].c end}do function __DARKLUA_BUNDLE_MODULES.a()local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = ReplicatedStorage:WaitForChild("Network")
local SaveModule = require(ReplicatedStorage.Library.Client.Save)
local Types = require(ReplicatedStorage.Library.Types.Gym)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local InstancingCmds = require(ReplicatedStorage.Library.Client.InstancingCmds)
local InstanceZoneCmds = require(ReplicatedStorage.Library.Client.InstanceZoneCmds)

local Event = {}




local EventState = {
    Strength = 0,
    Rebirth = 0,
    RequiredStrength = 250,
    MaxRebirths = 35,
    AutoClicking = true,
}


Event.DefaultSettings = {
    ["Stamina"] = 0,
    ["CritChance"] = 0,
    ["Strength"] = 100,
    ["Size"] = 1
}


local function Teleport(position: Vector3)
    if LocalPlayer.Character then
        LocalPlayer.Character:MoveTo(position)
    end
end

function Event.TeleportToBestZone()
    
    local bestZone = InstanceZoneCmds.GetMaximumOwnedZoneNumber()

    local zonePath = workspace.__THINGS.__INSTANCE_CONTAINER
        .Active.GymEvent:FindFirstChild(tostring(bestZone) .. " | Area " .. tostring(bestZone))

    if zonePath and zonePath:FindFirstChild("PARTS_LOD") and zonePath.PARTS_LOD:FindFirstChild("Path") then
        local union = zonePath.PARTS_LOD.Path:FindFirstChild("Union")
        if union and union:IsA("BasePart") then
            Teleport(union.Position)
            print("[Event] Teleported to zone " .. bestZone)
        end
    else
        warn("[Event] Failed to locate teleport target for zone " .. bestZone)
    end
end




local function UpdateStats()
    local Save = SaveModule.Get()
    if Save and Save.Gym then
        EventState.Strength = Save.Gym.Strength or 0
        EventState.Rebirth = Save.Gym.Rebirths or 0
        EventState.RequiredStrength = Types.RebirthRequirements[EventState.Rebirth + 1] or math.huge
        EventState.MaxRebirths = Types.MAX_REBIRTHS or 999
    end
end


function Event.StartAutoClick()
    task.spawn(function()
        
        local function WaitForClientGymAuto()
            local modulePath
            repeat
                local container = workspace:FindFirstChild("__THINGS")
                    and workspace.__THINGS:FindFirstChild("__INSTANCE_CONTAINER")
                    and workspace.__THINGS.__INSTANCE_CONTAINER:FindFirstChild("Active")
                    and workspace.__THINGS.__INSTANCE_CONTAINER.Active:FindFirstChild("GymEvent")
                    and workspace.__THINGS.__INSTANCE_CONTAINER.Active.GymEvent:FindFirstChild("ClientModule")

                if container then
                    modulePath = container:FindFirstChild("ClientGymAuto")
                end

                task.wait(1)
            until modulePath and modulePath:IsA("ModuleScript")

            return modulePath
        end

        
        local function WaitForGymTrain()
            local trainModule
            repeat
                local gymEvent = workspace:FindFirstChild("__THINGS")
                    and workspace.__THINGS.__INSTANCE_CONTAINER:FindFirstChild("Active")
                    and workspace.__THINGS.__INSTANCE_CONTAINER.Active:FindFirstChild("GymEvent")

                if gymEvent and gymEvent:FindFirstChild("ClientModule") then
                    trainModule = gymEvent.ClientModule:FindFirstChild("GymTrain")
                end

                task.wait(1)
            until trainModule and trainModule:IsA("ModuleScript")

            return trainModule
        end

        local gymAutoModule = WaitForClientGymAuto()
        local gymTrainModule = WaitForGymTrain()

        if not gymAutoModule or not gymTrainModule then
            warn("[Event] Could not find ClientGymAuto or GymTrain module")
            return
        end

        local successAuto, auto = pcall(require, gymAutoModule)
        local successTrain, GymTrain = pcall(require, gymTrainModule)

        if successAuto and auto and typeof(auto.StartAuto) == "function"
            and successTrain and GymTrain and typeof(GymTrain.SetTrainingByIndex) == "function" then

            print("[Event] Starting auto click with training mode 1")
            GymTrain.SetTrainingByIndex(1)
            auto.StartAuto()
        else
            warn("[Event] Failed to initialize auto training")
        end
    end)
end


local function FreezeCharacter()
    task.spawn(function()
        local humanoid
        repeat
            task.wait(0.5)
            if LocalPlayer.Character then
                humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            end
        until humanoid

        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        humanoid.AutoRotate = false

        
        while true do
            if humanoid then
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
                humanoid.AutoRotate = false
            end
            task.wait(0.5)
        end
    end)
end



local function GetOwnedZones()
    local owned = {}
    local save = InstanceZoneCmds.GetSaveTable()
    for key, value in pairs(save) do
        local zoneId = tonumber(string.match(key, "%d+"))
        if value and zoneId then
            owned[zoneId] = true
        end
    end
    return owned
end

local function GetGymCoins()
    local Save = SaveModule.Get()
    for _, entry in pairs(Save.Inventory.Currency) do
        if entry.id == "GymCoins" then
            return tonumber(entry._am) or 0
        end
    end
    return 0
end


local function GetZoneCost(index)
    local zones = InstancingCmds.Get().instanceZones
    local zoneData = zones and zones[index]
    return zoneData and zoneData.CurrencyCost or math.huge
end



function Event.TryBuyZoneForRebirth(currentRebirths)
    
    if currentRebirths == 0 or currentRebirths % 5 ~= 0 then return end

    local targetZone = (currentRebirths / 5) + 1
    local ownedZone = InstanceZoneCmds.GetMaximumOwnedZoneNumber()
    if ownedZone >= targetZone then return end

    local requiredCoins = GetZoneCost(targetZone)
    if requiredCoins == math.huge then return end

    print(string.format("[Event] Need to buy zone %d for rebirth %d", targetZone, currentRebirths))
    
    while GetGymCoins() < requiredCoins do
        print(string.format("[Event] Waiting for %d GymCoins to unlock zone %d...", requiredCoins, targetZone))
        task.wait(1)
    end

    local success, result = pcall(function()
        return Network:WaitForChild("InstanceZones_RequestPurchase"):InvokeServer("GymEvent", targetZone)
    end)

    if success then
        print(string.format("[Event] Zone %d successfully purchased!", targetZone))
        task.delay(1, function()
            Event.TeleportToBestZone()
        end)
    else
        warn("[Event] Failed to purchase zone:", result)
    end
end







function Event.TryRebirth()
    UpdateStats()

    if EventState.Rebirth >= EventState.MaxRebirths then
        EventState.AutoClicking = false
        warn("[Event] Max rebirths reached:", EventState.Rebirth)
        return
    end

    if EventState.Rebirth > 0 and EventState.Rebirth % 5 == 0 then
        local requiredZone = (EventState.Rebirth / 5) + 1
        local ownedZone = InstanceZoneCmds.GetMaximumOwnedZoneNumber()

        if ownedZone < requiredZone then
            print(string.format("[Event] Zone %d is required before continuing rebirths past %d", requiredZone, EventState.Rebirth))
            return
        end
    end


    if EventState.Strength >= EventState.RequiredStrength then
        local rebirthEvent = Network:FindFirstChild("Gym_Rebirth")
        if rebirthEvent then
            local success, err = pcall(function()
                rebirthEvent:InvokeServer()
            end)
            if success then
                print("[Event] Rebirth completed!")
                task.wait(0.5)
                UpdateStats()

                Event.TryBuyZoneForRebirth(EventState.Rebirth)
            else
                warn("[Event] Rebirth failed:", err)
            end
        end
    end
end




function Event.StartRebirthLoop()
    task.spawn(function()
        while EventState.Rebirth < (Types.MAX_REBIRTHS or math.huge) do
            Event.TryRebirth()
            task.wait(5)
        end
        warn("[Event] Rebirth loop stopped: max rebirths reached")
    end)
end


local function WaitForEventGround()
    local found = false
    repeat
        Teleport(Vector3.new(-9949.36133, 19.2279053, -289.342651))
        print("Teleporting to event...")
        task.wait(10)

        local eventArea = workspace:FindFirstChild("__THINGS")
        if eventArea then
            local ground = eventArea:FindFirstChild("__FAKE_INSTANCE_GROUND")
            if ground then
                local gymEvent = ground:FindFirstChild("GymEvent")
                if gymEvent and #gymEvent:GetDescendants() > 0 then
                    found = true
                end
            end
        end
    until found
end


function Event.RunEvent(settings)
    settings = settings or Event.DefaultSettings
    WaitForEventGround()


    
    Network:WaitForChild("Gym_SettingsUpdate"):FireServer(settings)
    print("Event settings updated.")
    FreezeCharacter()
    UpdateStats()

    Event.TryBuyZoneForRebirth(EventState.Rebirth)
    task.spawn(Event.TeleportToBestZone)
    task.spawn(Event.StartAutoClick)
    task.spawn(Event.StartRebirthLoop)
end



function Event.GetState()
    UpdateStats()
    return EventState
end

return Event
end end
Event = __DARKLUA_BUNDLE_MODULES.load('a')

Event.RunEvent()
