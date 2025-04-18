local QBCore = exports['qb-core']:GetCoreObject()

-- Utility: Show 3D Text
function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local p = GetGameplayCamCoords()
    local dist = #(p - coords)
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Show 3D message to nearby players
function Broadcast3DMessage(msg)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    CreateThread(function()
        local displayTime = 5000
        local startTime = GetGameTimer()
        while GetGameTimer() - startTime < displayTime do
            Wait(0)
            DrawText3D(playerCoords + vector3(0.0, 0.0, 1.0), msg)
        end
    end)
end

-- /flipcoin command
RegisterCommand("flipcoin", function()
    local result = math.random(1, 2) == 1 and "Heads" or "Tails"
    Broadcast3DMessage("🪙 flips a coin: " .. result)
end, false)

-- /rolldice command
RegisterCommand("rolldice", function()
    local result = math.random(1, 6)
    Broadcast3DMessage("🎲 rolls a dice: " .. result)
end, false)
