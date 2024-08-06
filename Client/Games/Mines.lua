RegisterNuiCallback('minesCashout', function(data)
    TriggerServerEvent('ctake:server:minesCashout', data.amount)
end)

RegisterNuiCallback('minesBet', function(data)
    TriggerServerEvent('ctake:server:minesBet', data.amount)
end)

RegisterNetEvent('ctake:client:minesBet', function(number)
    SendNUIMessage({
        type = "minesBet",
    })    
end)