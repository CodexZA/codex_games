local QBCore = exports['qb-core']:GetCoreObject()

-- CONFIG
local COOLDOWN_TIME = 5     -- seconds between uses
local DISPLAY_TIME  = 5000  -- ms 3D text remains
local RANGE         = 15.0  -- how far away others see your text

-- cooldown tracker
local lastUse = 0
local function canUse()
    local now = GetGameTimer()
    if now - lastUse < (COOLDOWN_TIME * 1000) then return false end
    lastUse = now
    return true
end

-- Draw 3D text at world coords
local function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local cam = GetGameplayCamCoords()
    local dist = #(cam - coords)
    local scale = (1 / dist) * 1.5 * ((1 / GetGameplayCamFov()) * 100)

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextCentre(1)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Show the 3D text over the sender’s head
RegisterNetEvent('qbox-games:client:showAction', function(message, senderId)
    local target = GetPlayerFromServerId(senderId)
    if target == -1 then return end

    CreateThread(function()
        local endTime = GetGameTimer() + DISPLAY_TIME
        while GetGameTimer() < endTime do
            Wait(0)
            local ped = GetPlayerPed(target)
            if DoesEntityExist(ped) then
                local pos = GetEntityCoords(ped)
                DrawText3D(pos + vector3(0,0,1.0), message)
            end
        end
    end)
end)

-- /flipcoin
RegisterCommand('flipcoin', function()
    if not canUse() then return end
    local result = (math.random(2) == 1)
        and "🪙 flips a coin: Heads"
        or "🪙 flips a coin: Tails"
    TriggerServerEvent('qbox-games:shareResult', result)
end, false)

-- /rolldice
RegisterCommand('rolldice', function()
    if not canUse() then return end
    local result = '🎲 rolls a dice: ' .. math.random(1,6)
    TriggerServerEvent('qbox-games:shareResult', result)
end, false)

-- /rps
RegisterCommand('rps', function()
    if not canUse() then return end
    local opts  = {'✊ Rock','✋ Paper','✌️ Scissors'}
    local pick  = opts[math.random(#opts)]
    local result = '🕹️ plays RPS: ' .. pick
    TriggerServerEvent('qbox-games:shareResult', result)
end, false)
