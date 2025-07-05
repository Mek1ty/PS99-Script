local __DARKLUA_BUNDLE_MODULES __DARKLUA_BUNDLE_MODULES={cache={}, load=function(m)if not __DARKLUA_BUNDLE_MODULES.cache[m]then __DARKLUA_BUNDLE_MODULES.cache[m]={c=__DARKLUA_BUNDLE_MODULES[m]()}end return __DARKLUA_BUNDLE_MODULES.cache[m].c end}do function __DARKLUA_BUNDLE_MODULES.a()local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = ReplicatedStorage:WaitForChild("Network")
local SaveModule = require(ReplicatedStorage.Library.Client.Save)
local Types = require(ReplicatedStorage.Library.Types.Gym)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Event = {}


local EventState = {
    Strength = 0,
    Rebirth = 0,
    RequiredStrength = 250,
    MaxRebirths = 999,
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


local function UpdateStats()
    local Save = SaveModule.Get()
    if Save and Save.Gym then
        EventState.Strength = Save.Gym.Strength or 0
        EventState.Rebirth = Save.Gym.Rebirth or 0
        EventState.RequiredStrength = Types.RebirthRequirements[EventState.Rebirth + 1] or math.huge
        EventState.MaxRebirths = Types.MAX_REBIRTHS or 999
    end
end


function Event.StartAutoClick()
    task.spawn(function()
        local ok, module = pcall(function()
            return require(workspace.__THINGS.__INSTANCE_CONTAINER.Active.GymEvent.ClientModule.ClientGymAuto)
        end)

        if ok and module and typeof(module.StartAuto) == "function" then
            print("[Event] Запуск StartAuto() из ClientGymAuto")
            module.StartAuto()
        else
            warn("[Event] Не удалось запустить автоклик: ClientGymAuto не найден или повреждён")
        end
    end)
end


function Event.TryRebirth()
    UpdateStats()

    if EventState.Rebirth >= EventState.MaxRebirths then
        EventState.AutoClicking = false
        warn("[Event] Достигнут максимальный ребиртх:", EventState.Rebirth)
        return
    end

    if EventState.Strength >= EventState.RequiredStrength then
        local rebirthEvent = Network:FindFirstChild("Gym_Rebirth")
        if rebirthEvent then
            local success, err = pcall(function()
                rebirthEvent:InvokeServer()
            end)
            if success then
                print("[Event] Rebirth выполнен!")
                task.wait(0.5)
                UpdateStats()
            else
                warn("[Event] Ошибка ребирта:", err)
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
        warn("[Event] Цикл ребиртов завершён: достигнут лимит.")
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
    task.wait(1)
    Event.StartAutoClick()
    Event.StartRebirthLoop()
end


function Event.GetState()
    UpdateStats()
    return EventState
end

return Event
end end
Event = __DARKLUA_BUNDLE_MODULES.load('a')

Event.RunEvent()
