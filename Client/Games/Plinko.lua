RegisterNuiCallback('plinkoBet', function (data)
    TriggerServerEvent('ctake:server:plinkoBet', data.amount, data.risk, data.row)
end)

RegisterNuiCallback('plinkoResult', function (data)
    TriggerServerEvent('ctake:server:plinkoResult', data.amount, data.risk, data.row, data.index)
end)

RegisterNetEvent('ctake:client:plinkoBet', function (number)
    SendNUIMessage({
        type = "dropBall",
        index = number
    })    
end)