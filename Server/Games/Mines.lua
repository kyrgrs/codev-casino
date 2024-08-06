RegisterServerEvent('ctake:server:minesBet', function (amount)
    local src = source 
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if amount then 
        if tonumber(amount) < 0 then 
            return
        end
    end
    if player.money >= amount then
        player.money = player.money - amount
        savePlayerData(player, src)
        TriggerClientEvent('ctake:client:receiveData', src, player)
        TriggerClientEvent('ctake:client:minesBet', src)
        sendDiscordLog('bets', 'MINES', '**'..player.name..'** placed a bet of **$'..amount..'**', getPlayerIdentifier(src))
    end
end)

RegisterServerEvent('ctake:server:minesCashout', function (amount)
    local src = source 
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
    player.money = player.money + amount
    savePlayerData(player, src)
    sendDiscordLog('bets', 'MINES', '**'..player.name..'** cashed out **$'..amount..'**', getPlayerIdentifier(src))
    TriggerClientEvent('ctake:client:receiveData', src, player)
end)
