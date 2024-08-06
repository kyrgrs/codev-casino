RegisterNuiCallback('diceBet', function (data)
    TriggerServerEvent('ctake:server:diceBet', data.amount, data.rollOver)
end)

RegisterNetEvent('ctake:client:diceBet', function (number)
    SendNUIMessage({
        type = "rollDice",
        number = number
    })    
end)