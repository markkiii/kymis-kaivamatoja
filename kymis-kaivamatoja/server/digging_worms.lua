ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('esx_digging:checkShovel', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local shovel = xPlayer.getInventoryItem('md_shovel')
    
    if shovel and shovel.count >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('esx_digging:rewardWorms')
AddEventHandler('esx_digging:rewardWorms', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local chance = math.random(1, 100)

    if chance <= 70 then 
        local wormCount = math.random(1, 1) 
        xPlayer.addInventoryItem('worms', wormCount)
        TriggerClientEvent('esx:showNotification', source, 'You dug up ' .. wormCount .. ' worms!')
    else
        TriggerClientEvent('esx:showNotification', source, 'You found nothing but dirt...')
    end
end)