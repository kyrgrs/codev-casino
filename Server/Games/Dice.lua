RegisterServerEvent('ctake:server:diceBet', function (amount, rollOver)
    local src = source 
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if amount then 
        if tonumber(amount) < 0 then 
            return
        end
    end
    if player.money >= amount then
        local random = math.random(100, 10000) / 100
        player.money = player.money - amount
        if random >= rollOver then 
            local possibleWin = ((rollOver / (100 - rollOver) + rollOver / 1000 ) + 1) - (rollOver / 350)
            player.money = player.money + (amount * possibleWin)
        end
        sendDiscordLog('bets',  'DICE', '**'..player.name..'** placed a bet of **$'..amount..'** and rolled **'..random..'**. '..(random >= rollOver and '**WON**' or '**LOST**'), getPlayerIdentifier(src))
        savePlayerData(player, src)
        TriggerClientEvent('ctake:client:receiveData', src, player)
        TriggerClientEvent('ctake:client:diceBet', src, random)
    end
end)
