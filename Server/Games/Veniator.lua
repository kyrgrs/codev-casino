local Veniator = {
    history = {},
    started = false,
    status = "idle",
    finishCoeff = 1,
    coeff = 1,
    bets = {},
}

Citizen.CreateThread(function ()
    Wait(2000)
    while true do
        if not Veniator.started then
            Veniator.started = true
            if Veniator.status == "idle" then 
                Veniator.finishCoeff = veniatorCalculation()
                Veniator.status = "waiting"
                TriggerClientEvent('ctake:client:veniatorWaiting', -1)
            end
        else
            if Veniator.status == "waiting" then 
                Citizen.Wait(10000)
                Veniator.status = "started"
                TriggerClientEvent('ctake:client:veniatorStarted', -1)
            elseif Veniator.status == "started" then
                local addValue = math.random(10, 20) / 1000 -- 0.010 - 0.020 * 2 * 1.5
                if Veniator.coeff <= 30 then 
                    Veniator.coeff = round(Veniator.coeff + (addValue * (math.floor(Veniator.coeff) * 1.05)), 2)
                else
                    Veniator.coeff = round(Veniator.coeff + (addValue * (math.floor(30) * 1.05)), 2)
                end
                TriggerClientEvent('ctake:client:veniatorUpdate', -1, Veniator.coeff)
                if Veniator.coeff >= Veniator.finishCoeff then 
                    Veniator.status = "finished"
                    TriggerClientEvent('ctake:client:veniatorFinished', -1)
                    Wait(4000)
                    Veniator.status = "idle"
                    Veniator.started = false
                    Veniator.coeff = 1
                    Veniator.bets = {}
                    table.insert(Veniator.history, Veniator.finishCoeff)
                    if #Veniator.history > 20 then
                        table.remove(Veniator.history, 1)
                    end
                    TriggerClientEvent('ctake:client:veniatorHistory', -1, Veniator.history)
                end
            end
        end

        Citizen.Wait(100)
    end
end)

RegisterServerEvent('ctake:server:veniatorBet', function (amount, index)
    local src = source 
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if amount then 
        if tonumber(amount) < 0 then 
            return
        end
    end
    if Veniator.status == "waiting" then 
        if player.money >= amount then
            player.money = player.money - amount
            savePlayerData(player, src)
            TriggerClientEvent('ctake:client:receiveData', src, player)
            TriggerClientEvent('ctake:client:veniatorBet', src, true, index)
            table.insert(Veniator.bets, {
                identifier = identifier,
                amount = amount,
                index = index
            })
            sendDiscordLog('bets', 'VENIATOR', '**'..player.name..'** placed a bet of **$'..amount..'** on **'..index..'**', getPlayerIdentifier(src))
        else
            TriggerClientEvent('ctake:client:veniatorBet', src, false, index)
        end
    end
end)

RegisterServerEvent('ctake:server:veniatorCancelBet', function (amount, index)
    local src = source 
    local identifier = getPlayerIdentifier(src)
    local player = getPlayerData(identifier, src)
    if Veniator.status == "waiting" then
        for k,v in pairs(Veniator.bets) do 
            if v.identifier == identifier and v.index == index then
                player.money = player.money + v.amount
                savePlayerData(player, src)
                sendDiscordLog('bets', 'VENIATOR', '**'..player.name..'** cancelled a bet of **$'..v.amount..'**', getPlayerIdentifier(src))
                TriggerClientEvent('ctake:client:receiveData', src, player)
                TriggerClientEvent('ctake:client:veniatorCancelBet', src, true, index)
                table.remove(Veniator.bets, k)
            end
        end
    elseif Veniator.status == "started" then 
        -- cash out
        for k,v in pairs(Veniator.bets) do 
            if v.identifier == identifier and v.index == index then 
                player.money = player.money + (v.amount * Veniator.coeff)
                table.insert(player.veniatorHistory, {
                    amount = v.amount,
                    coeff = Veniator.coeff,
                    win = v.amount * Veniator.coeff,
                    time = os.date("%I:%M%p")
                })
                sendDiscordLog('bets', 'VENIATOR', '**'..player.name..'** cashed out **$'..(v.amount * Veniator.coeff)..'** on **'..Veniator.coeff..'x**', getPlayerIdentifier(src))
                savePlayerData(player, src)
                TriggerClientEvent('ctake:client:receiveData', src, player)
                TriggerClientEvent('ctake:client:veniatorCancelBet', src, true, index)
                table.remove(Veniator.bets, k)
            end
        end
    end
end)

function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end
