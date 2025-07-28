ESX = exports['es_extended']:getSharedObject()
local ox_target = exports.ox_target
local digging = false
local blips = {}

local digZones = {
    { coords = vector3(2267.3171, 3919.3135, 33.3483), radius = 10.0 },
    -- VOIT HALUTESSASI LISÄTÄ LISÄÄ KAIVUUALUEITA :)
}

local function isInDigZone()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for _, zone in ipairs(digZones) do
        if #(playerCoords - zone.coords) <= zone.radius then
            return true
        end
    end
    return false
end

local function startDigging()
    if digging then return end

    if not isInDigZone() then
        lib.notify({ title = 'Error', description = 'No nyt et voi ihan täällä kaivaa!', type = 'error' })
        return
    end

    ESX.TriggerServerCallback('esx_digging:checkShovel', function(hasShovel)
        if not hasShovel then
            lib.notify({ title = 'Error', description = 'Tarvitset lapion kaivaaksesi!', type = 'error' })
            return
        end

        digging = true
        local playerPed = PlayerPedId()

        RequestAnimDict("amb@world_human_gardener_plant@male@base")
        while not HasAnimDictLoaded("amb@world_human_gardener_plant@male@base") do
            Citizen.Wait(100)
        end

        TaskPlayAnim(playerPed, "amb@world_human_gardener_plant@male@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)
        
        local success = lib.progressBar({
            duration = 5000,
            label = 'Kaivetaan matoja...',
            useWhileDead = false,
            canCancel = true,
            disable = { move = true, combat = true }
        })

        ClearPedTasks(playerPed)
        digging = false

        if success then
            TriggerServerEvent('esx_digging:rewardWorms')
        end
    end)
end

for _, zone in ipairs(digZones) do
    local blip = AddBlipForCoord(zone.coords.x, zone.coords.y, zone.coords.z)
    SetBlipSprite(blip, 544)
    SetBlipDisplay(blip, 4) 
    SetBlipScale(blip, 0.6)
    SetBlipColour(blip, 2) 
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Kaivuualue")
    EndTextCommandSetBlipName(blip)
    table.insert(blips, blip)
end

for _, zone in ipairs(digZones) do
    ox_target:addSphereZone({
        coords = zone.coords,
        radius = zone.radius,
        debug = false, 
        options = {
            {
                name = 'dig_worms_' .. tostring(zone.coords), 
                icon = 'fas fa-shovel',
                label = 'Kaiva maata',
                canInteract = function()
                    return isInDigZone() and not digging
                end,
                onSelect = function()
                    startDigging()
                end
            }
        }
    })
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if not digging then
            RemoveAnimDict("amb@world_human_gardener_plant@male@base")
        end
    end
end)
