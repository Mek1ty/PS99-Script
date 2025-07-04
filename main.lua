local __DARKLUA_BUNDLE_MODULES __DARKLUA_BUNDLE_MODULES={cache={}, load=function(m)if not __DARKLUA_BUNDLE_MODULES.cache[m]then __DARKLUA_BUNDLE_MODULES.cache[m]={c=__DARKLUA_BUNDLE_MODULES[m]()}end return __DARKLUA_BUNDLE_MODULES.cache[m].c end}do function __DARKLUA_BUNDLE_MODULES.a()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = ReplicatedStorage:WaitForChild("Network")
local Save = require(ReplicatedStorage.Library.Client.Save)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Event = {}


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

function Event.RunEvent(settings)
    settings = {
    ["Stamina"] = 0,
    ["CritChance"] = 0,
    ["Strength"] = 100,
    ["Size"] = 1
    }

    
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

    WaitForEventGround()

    
    Network:WaitForChild("Gym_SettingsUpdate"):FireServer(settings)
    print("Event settings updated.")
end

return Event
end end
Event = __DARKLUA_BUNDLE_MODULES.load('a')

Event.RunEvent()
