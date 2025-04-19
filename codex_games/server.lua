local QBCore = exports['qb-core']:GetCoreObject()

-- How far away others can see the 3D text
local RANGE = 15.0

RegisterServerEvent('qbox-games:shareResult', function(message)
    local src      = source
    local srcPed   = GetPlayerPed(src)
    if not srcPed then return end

    local srcCoords = GetEntityCoords(srcPed)
    for _, id in ipairs(QBCore.Functions.GetPlayers()) do
        local ped = GetPlayerPed(id)
        if ped then
            local dist = #(GetEntityCoords(ped) - srcCoords)
            if dist <= RANGE then
                TriggerClientEvent('qbox-games:client:showAction', id, message, src)
            end
        end
    end
end)

print('[qbox-games] mini‑games resource loaded')
