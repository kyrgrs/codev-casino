local playerBets = {}
RegisterServerEvent('ctake:server:plinkoBet', function (amount, risk, row)
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
        local array = Config.PlinkoChances[row]
        local selectedIndex = selectIndexByProbability(array)
        
        if playerBets[src] then
            table.insert(playerBets[src], {amount = amount, risk = risk, row = row, selectedIndex = selectedIndex})
        else
            playerBets[src] = {}
            table.insert(playerBets[src], {amount = amount, risk = risk, row = row, selectedIndex = selectedIndex})
        end

        sendDiscordLog('bets', 'PLINKO', '**'..player.name..'** placed a bet of **$'..amount..'** on **'..row..'** with **'..risk..'** risk', getPlayerIdentifier(src))
        TriggerClientEvent('ctake:client:receiveData', src, player)
        TriggerClientEvent('ctake:client:plinkoBet', src, selectedIndex)
    end
end)

RegisterServerEvent('ctake:server:plinkoResult', function (amount, risk, row, index)
    local src = source 
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
    if playerBets[src] then
        for k, v in pairs(playerBets[src]) do
            if v.selectedIndex == index then
                if v.amount ~= amount then
                    return
                end
                if v.risk ~= risk then
                    return
                end
                if v.row ~= row then
                    return
                end
                local multiplier = Config.BucketMultipliers[risk][row][index + 1]
                player.money = player.money + (v.amount * multiplier)
                savePlayerData(player, src)
                sendDiscordLog('bets', 'PLINKO', '**'..player.name..'** won **$'..(v.amount * multiplier)..'** on **'..row..'** with **'..risk..'** risk', getPlayerIdentifier(src))
                table.remove(playerBets[src], k)
            end
        end
    else
        return
    end
    TriggerClientEvent('ctake:client:receiveData', src, player)
end)

function selectIndexByProbability(array)
    -- Toplam olasılık hesaplanır
    local totalProbability = 0
    for _, probability in ipairs(array) do
        totalProbability = totalProbability + probability
    end

    -- Rastgele bir sayı seçilir
    local randomNum = math.random() * totalProbability

    -- Seçilen sayıya göre indeks belirlenir
    local cumulativeProbability = 0
    for i, probability in ipairs(array) do
        cumulativeProbability = cumulativeProbability + probability
        if randomNum <= cumulativeProbability then
            return i
        end
    end

    -- Hata durumu için son indeksi döndürür
    return #array
end
