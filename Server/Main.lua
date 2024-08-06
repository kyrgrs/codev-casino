--$$$$$$$\  $$\      $$\       $$$$$$$$\ $$\   $$\  $$$$$$\  $$\      $$\   $$\  $$$$$$\  $$$$$$\ $$\    $$\ $$$$$$$$\      $$$$$$\   $$$$$$\  $$$$$$$\  $$$$$$\ $$$$$$$\ $$$$$$$$\  $$$$$$\  
--$$  ____| $$$\    $$$ |      $$  _____|$$ |  $$ |$$  __$$\ $$ |     $$ |  $$ |$$  __$$\ \_$$  _|$$ |   $$ |$$  _____|    $$  __$$\ $$  __$$\ $$  __$$\ \_$$  _|$$  __$$\\__$$  __|$$  __$$\ 
--$$ |      $$$$\  $$$$ |      $$ |      \$$\ $$  |$$ /  \__|$$ |     $$ |  $$ |$$ /  \__|  $$ |  $$ |   $$ |$$ |          $$ /  \__|$$ /  \__|$$ |  $$ |  $$ |  $$ |  $$ |  $$ |   $$ /  \__|
--$$$$$$$\  $$\$$\$$ $$ |      $$$$$\     \$$$$  / $$ |      $$ |     $$ |  $$ |\$$$$$$\    $$ |  \$$\  $$  |$$$$$\ $$$$$$\\$$$$$$\  $$ |      $$$$$$$  |  $$ |  $$$$$$$  |  $$ |   \$$$$$$\  
--\_____$$\ $$ \$$$  $$ |      $$  __|    $$  $$<  $$ |      $$ |     $$ |  $$ | \____$$\   $$ |   \$$\$$  / $$  __|\______|\____$$\ $$ |      $$  __$$<   $$ |  $$  ____/   $$ |    \____$$\ 
--$$\   $$ |$$ |\$  /$$ |      $$ |      $$  /\$$\ $$ |  $$\ $$ |     $$ |  $$ |$$\   $$ |  $$ |    \$$$  /  $$ |          $$\   $$ |$$ |  $$\ $$ |  $$ |  $$ |  $$ |        $$ |   $$\   $$ |
--\$$$$$$  |$$ | \_/ $$ |      $$$$$$$$\ $$ /  $$ |\$$$$$$  |$$$$$$$$\\$$$$$$  |\$$$$$$  |$$$$$$\    \$  /   $$$$$$$$\     \$$$$$$  |\$$$$$$  |$$ |  $$ |$$$$$$\ $$ |        $$ |   \$$$$$$  |
-- \______/ \__|     \__|      \________|\__|  \__| \______/ \________|\______/  \______/ \______|    \_/    \________|     \______/  \______/ \__|  \__|\______|\__|        \__|    \______/                                                                                                                                                                                           
-- discord.gg/fivemscripts
local QBCore = exports['qb-core']:GetCoreObject()

local chatMessages = {}

betTypes = {
	["home"] = "HOME",
	["draw"] = "DRAW",
	["away"] = "AWAY",
	["over-2-5"] = "OVER 2.5",
	["under-2-5"] = "UNDER 2.5",
	["both-team-score-yes"] = "BOTH TEAM SCORE YES",
	["both-team-score-no"] = "BOTH TEAM SCORE NO"
}

RegisterServerEvent('ctake:server:getLivematches', function()
	PerformHttpRequest('https://football-betting-odds1.p.rapidapi.com/provider1/live/inplaying', function(err, data, headers)
		if err == 200 then
			local curData = {}
			local data = json.decode(data)
			for k,v in pairs(data) do
				local homescore = string.sub(v.score, 1, 1)
				local awayscore = string.sub(v.score, 3, 3)
				table.insert(curData, {
					matchid = v.mid,
					home = v.home,
					away = v.away,
					home_score = homescore,
					away_score = awayscore,
					minutes = v.minutes,
					leagues = v.leagues,
					periodTXT = v.periodTXT,
				})
			end
			TriggerClientEvent('ctake:client:receiveLivematches', -1, curData)
		end
	end, 'GET', '', Config.Headers)
end)

RegisterServerEvent('ctake:server:getUpcomingmatches', function()
	PerformHttpRequest('https://football-betting-odds1.p.rapidapi.com/provider1/live/list', function(err, data, headers)
		if err == 200 then
			local curData = {}
			local data = json.decode(data)

			for k,v in pairs(data) do
				if v.status == "1" then
					local homescore = string.sub(v.score, 1, 1)
					local awayscore = string.sub(v.score, 3, 3)
					local odds = {}
					for kk,vv in pairs(betTypes) do
						local odd = v.odds[kk]
						if odd then
							table.insert(odds, {
								type = kk,
								title = vv,
								odd = odd
							})
						end
					end
					table.insert(curData, {
						matchid = v.mid,
						home = v.home,
						away = v.away,
						home_score = homescore,
						away_score = awayscore,
						start_time = os.date("%d.%m.%Y", v.startTime),
						start_hours = os.date("%H:%M", v.startTime),
						minutes = v.minutes,
						startTime = v.startTime,
						leagues = v.leagues,
						periodTXT = v.periodTXT,
						odds = odds
					})
				end
			end
			table.sort(curData, function(a, b) return a.startTime < b.startTime end)
			Wait(500)
			TriggerClientEvent('ctake:client:receiveUpcomingmatches', -1, curData)
		end
	end, 'GET', '', Config.Headers)
end)

RegisterServerEvent('ctake:server:fetchData', function(amount)
	local src = source
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if player then
		local isAdmin = isPlayerAdmin(src)
		player.isAdmin = isAdmin
		TriggerClientEvent('ctake:client:receiveData', src, player)
	end
end)

RegisterServerEvent('ctake:server:getMyBets', function()
	local src = source
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if player then
		TriggerClientEvent('ctake:client:receiveBets', src, player.bets)
	end
end)

RegisterServerEvent('ctake:server:updatePFP', function(url)
	local src = source
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if player then
		player.image = url
		savePlayerData(player, src)
	end
end)

RegisterServerEvent('ctake:server:updateName', function(name)
	local src = source
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if player then
		if string.len(name) > 2 then
			-- check for blackwords
			for k,v in pairs(Config.Blackwords) do 
				if string.match(name, v) then 
					return
				end
			end
			player.name = name
			savePlayerData(player, src)
		end
	end
end)

RegisterServerEvent('ctake:server:deposit', function(type, amount)
	local src = source
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if player then
		if removePlayerMoney(type, amount) then
			player.money = player.money + amount
			savePlayerData(player, src)
		end
	end
end)

RegisterServerEvent('ctake:server:withdraw', function(type, amount)
	local src = source
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if player and player.money >= tonumber(amount) then
		if addPlayerMoney(type, amount) then
			player.money = player.money - tonumber(amount)
			savePlayerData(player, src)
		end
	end
end)

RegisterServerEvent('ctake:server:permissionCheck', function()
	local src = source
	local user_id = vRP.getUserId(src)
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if user_id == 1 then
		TriggerClientEvent('ctake:client:createObject', src)
		print("s-a spawnat propu")
	end
end)

RegisterServerEvent('ctake:server:saveObject', function(coords, heading)
	local src = source
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if player.isAdmin then 
		local file = LoadResourceFile(GetCurrentResourceName(), 'Server/Data/objects.json')
		local data = json.decode(file)
		table.insert(data, {
			x = coords.x,
			y = coords.y,
			z = coords.z,
			h = heading,
		})
		SaveResourceFile(GetCurrentResourceName(), 'Server/Data/objects.json', json.encode(data), -1)
		TriggerClientEvent('ctake:client:receiveObjects', -1, data)
	end
end)

RegisterServerEvent('ctake:server:fetchObjects', function()
	local src = source
	local file = LoadResourceFile(GetCurrentResourceName(), 'Server/Data/objects.json')
	local data = json.decode(file)
	TriggerClientEvent('ctake:client:receiveObjects', src, data)
end)

RegisterServerEvent('ctake:server:deleteObject', function(index)
	local src = source
	local file = LoadResourceFile(GetCurrentResourceName(), 'Server/Data/objects.json')
	local data = json.decode(file)
	table.remove(data, index)
	SaveResourceFile(GetCurrentResourceName(), 'Server/Data/objects.json', json.encode(data), -1)
	TriggerClientEvent('ctake:client:receiveObjects', -1, data)
end)

RegisterServerEvent('ctake:server:deleteMessage', function(index)
	local src = source 
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if player.isAdmin then
		table.remove(chatMessages, index + 1)
		TriggerClientEvent('ctake:client:receiveMessages', -1, chatMessages)
	end
end)

RegisterServerEvent('ctake:server:banPlayer', function(index)
	local src = source 
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if player.isAdmin then 
		local target = chatMessages[index + 1].identifier
		local targetPlayer = getPlayerData(target)
		targetPlayer.chatban = true
		for k,v in pairs(chatMessages) do 
			if v.identifier == target then 
				table.remove(chatMessages, k)
			end
		end
		TriggerClientEvent('ctake:client:receiveMessages', -1, chatMessages)
		savePlayerData(targetPlayer)
	end
end)

RegisterServerEvent('ctake:server:timeoutPlayer', function(index)
	local src = source 
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if player.isAdmin then 
		local target = chatMessages[index + 1].identifier
		local targetPlayer = getPlayerData(target)
		targetPlayer.timeout = os.time() + Config.TimeoutTime
		for k,v in pairs(chatMessages) do 
			if v.identifier == target then 
				table.remove(chatMessages, k)
			end
		end
		TriggerClientEvent('ctake:client:receiveMessages', -1, chatMessages)
		savePlayerData(targetPlayer)
	end
end)

RegisterServerEvent('ctake:server:sendMessage', function(message)
	local src = source
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	local name = player.name
	if player then
		if player.chatban then 
			return
		end
		if player.timeout and player.timeout > os.time() then 
			return
		elseif player.timeout and player.timeout < os.time() then 
			player.timeout = false
			savePlayerData(player, src)
		end
		if player.isAdmin then 
			name = "<span style='color:red;'>[ADMIN]</span> "..name   
		end
		-- check for blackwords
		for k,v in pairs(Config.Blackwords) do 
			if string.match(message, v) then 
				if Config.TimeoutWhenBlackword then 
					player.timeout = os.time() + Config.TimeoutTime
					savePlayerData(player, src)
				end
				return
			end
		end
		local messageData = {
			name = name,
			identifier = identifier,
			message = message,
			image = player.image,
			-- time as 00:00AM
			time = os.date("%I:%M%p"),
		}
		table.insert(chatMessages, messageData)
		TriggerClientEvent('ctake:client:receiveMessages', -1, chatMessages)
	end
end)

RegisterServerEvent('ctake:server:playCoupon', function(data)
	local src = source
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	local playerCoupons = data.coupons
	local totalOdd = 1
	local newCoupon = {}
	for k,v in pairs(playerCoupons) do 
		local match = getMatchFromMatchId(v.match)
		local odds = match.odds
		if match.odds then 
			Wait(100)
			local odd = tonumber(odds[v.value])
			table.insert(newCoupon, {
				matchid = v.match,
				match = match.home .. " - " .. match.away,
				odd = odd,
				type = v.value,
				status = "pending",
			})
			totalOdd = totalOdd * odd
		end
	end

	Wait(200)
	local coupon = {
		id = math.random(100000, 999999),
		coupons = newCoupon,
		status = "pending",
		amount = data.price,
		potential = data.price * totalOdd,
		maxOdd = totalOdd,
		day = os.date("%d.%m.%Y"),
	}
	if player.money >= tonumber(data.price) then
		player.money = player.money - tonumber(data.price)
		table.insert(player.bets, coupon)
		savePlayerData(player, src)
		TriggerClientEvent('ctake:client:receiveData', src, player)
		TriggerClientEvent('ctake:client:receiveBets', src, player.bets)
	end
end)

RegisterCommand('createprop', function(source, args, raw)
	local Player = vRP.getUserId(source)
	local src = source
	local identifier = getPlayerIdentifier(src)
	local player = getPlayerData(identifier, src)
	if Player == 1 then
		local model = args[1]
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(src)))
		local prop = CreateObject(GetHashKey(model), x, y, z, true, true, true)
		SetEntityHeading(prop, GetEntityHeading(GetPlayerPed(src)))
		PlaceObjectOnGroundProperly(prop)
	end
end)

function getMatchFromMatchId(matchId)
	-- https://football-betting-odds1.p.rapidapi.com/provider1/live/match/1000000
	local curData = {}
	PerformHttpRequest('https://football-betting-odds1.p.rapidapi.com/provider1/live/match/'..matchId, function(err, data, headers)
		if err == 200 then
			local data = json.decode(data)
			curData = data
			-- if data.status == "1" then 
			-- end
		end
	end, 'GET', '', Config.Headers)
	Wait(100)
	return curData
end

Citizen.CreateThread(function()
	while true do 
		local file = LoadResourceFile(GetCurrentResourceName(), 'Server/Data/players.json')
		local data = json.decode(file)
		for k,v in pairs(data) do
			if v.bets then
				for kk,vv in pairs(v.bets) do
					if vv.status == "pending" then
						local win = true
						for i,j in pairs(vv.coupons) do 
							local match = getMatchFromMatchId(j.matchid)
							local status = checkIfBetWin(match, j)
							if status == "pending" then 
								break
							elseif status == "lost" then 
								win = false
							end
							j.status = status
						end
						if win then 
							vv.status = "won"
							v.money = v.money + vv.potential
							savePlayerData(v)
						else
							vv.status = "lost"
							savePlayerData(v)
						end
					end
				end
			end
		end

		Citizen.Wait(100123012000)
	end
end)

function checkIfBetWin(match, bet)
	-- match.score = "1-0" // home score before - away score after - 
	if os.time() - 500 > match.lastUpdateTime then 
		local homescore, awayscore = match.score:match("(.+)-(.+)")
		local status = "lost"
		if bet.type == "home" then
			if tonumber(homescore) > tonumber(awayscore) then
				status = "won"
			end
		elseif bet.type == "draw" then
			if tonumber(homescore) == tonumber(awayscore) then
				status = "won"
			end
		elseif bet.type == "away" then
			if tonumber(homescore) < tonumber(awayscore) then
				status = "won"
			end
		elseif bet.type == "over-2-5" then
			if tonumber(homescore) + tonumber(awayscore) > 2.5 then
				status = "won"
			end
		elseif bet.type == "under-2-5" then
			if tonumber(homescore) + tonumber(awayscore) < 2.5 then
				status = "won"
			end
		elseif bet.type == "both-team-score-yes" then
			if tonumber(homescore) > 0 and tonumber(awayscore) > 0 then
				status = "won"
			end
		elseif bet.type == "both-team-score-no" then
			if tonumber(homescore) == 0 and tonumber(awayscore) == 0 then
				status = "won"
			end
		end

		return status
	else
		return "pending"
	end
end