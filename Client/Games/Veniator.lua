RegisterNetEvent('ctake:client:veniatorWaiting', function()
    SendNUIMessage({
        action = "veniatorWaiting"
    })
end)

RegisterNetEvent('ctake:client:veniatorUpdate', function(coeff)
    SendNUIMessage({
        action = "veniatorUpdate",
        coeff = coeff
    })
end)

RegisterNetEvent('ctake:client:veniatorStarted', function()
    SendNUIMessage({
        action = "veniatorStarted",
    })
end)

RegisterNetEvent('ctake:client:veniatorFinished', function()
    SendNUIMessage({
        action = "veniatorFinished",
    })
end)

RegisterNetEvent('ctake:client:veniatorHistory', function(history)
    SendNUIMessage({
        action = "veniatorHistory",
        history = history
    })
end)

RegisterNetEvent('ctake:client:veniatorBet', function(result, index)
    SendNUIMessage({
        action = "veniatorBet",
        result = result,
        bet = index
    })
end)

RegisterNetEvent('ctake:client:veniatorCancelBet', function(result, index)
    SendNUIMessage({
        action = "veniatorCancelBet",
        result = result,
        bet = index
    })
end)

RegisterNuiCallback('placeBet', function (data)
    TriggerServerEvent('ctake:server:veniatorBet', data.bet, data.index)
end)

RegisterNuiCallback('cancelBet', function (data)
    TriggerServerEvent('ctake:server:veniatorCancelBet', data.bet, data.index)
end)