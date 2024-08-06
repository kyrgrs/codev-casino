--$$$$$$$\  $$\      $$\       $$$$$$$$\ $$\   $$\  $$$$$$\  $$\      $$\   $$\  $$$$$$\  $$$$$$\ $$\    $$\ $$$$$$$$\      $$$$$$\   $$$$$$\  $$$$$$$\  $$$$$$\ $$$$$$$\ $$$$$$$$\  $$$$$$\  
--$$  ____| $$$\    $$$ |      $$  _____|$$ |  $$ |$$  __$$\ $$ |     $$ |  $$ |$$  __$$\ \_$$  _|$$ |   $$ |$$  _____|    $$  __$$\ $$  __$$\ $$  __$$\ \_$$  _|$$  __$$\\__$$  __|$$  __$$\ 
--$$ |      $$$$\  $$$$ |      $$ |      \$$\ $$  |$$ /  \__|$$ |     $$ |  $$ |$$ /  \__|  $$ |  $$ |   $$ |$$ |          $$ /  \__|$$ /  \__|$$ |  $$ |  $$ |  $$ |  $$ |  $$ |   $$ /  \__|
--$$$$$$$\  $$\$$\$$ $$ |      $$$$$\     \$$$$  / $$ |      $$ |     $$ |  $$ |\$$$$$$\    $$ |  \$$\  $$  |$$$$$\ $$$$$$\\$$$$$$\  $$ |      $$$$$$$  |  $$ |  $$$$$$$  |  $$ |   \$$$$$$\  
--\_____$$\ $$ \$$$  $$ |      $$  __|    $$  $$<  $$ |      $$ |     $$ |  $$ | \____$$\   $$ |   \$$\$$  / $$  __|\______|\____$$\ $$ |      $$  __$$<   $$ |  $$  ____/   $$ |    \____$$\ 
--$$\   $$ |$$ |\$  /$$ |      $$ |      $$  /\$$\ $$ |  $$\ $$ |     $$ |  $$ |$$\   $$ |  $$ |    \$$$  /  $$ |          $$\   $$ |$$ |  $$\ $$ |  $$ |  $$ |  $$ |        $$ |   $$\   $$ |
--\$$$$$$  |$$ | \_/ $$ |      $$$$$$$$\ $$ /  $$ |\$$$$$$  |$$$$$$$$\\$$$$$$  |\$$$$$$  |$$$$$$\    \$  /   $$$$$$$$\     \$$$$$$  |\$$$$$$  |$$ |  $$ |$$$$$$\ $$ |        $$ |   \$$$$$$  |
-- \______/ \__|     \__|      \________|\__|  \__| \______/ \________|\______/  \______/ \______|    \_/    \________|     \______/  \______/ \__|  \__|\______|\__|        \__|    \______/                                                                                                                                                                                           
-- discord.gg/fivemscripts
objects = {}
local languageLoaded = false

RegisterNetEvent('ctake:client:open', function ()
    if Config.Locale ~= "en" and not languageLoaded then 
        languageLoaded = true
        SendNUIMessage({
            action = "loadLanguage",
            data = Config.Locales[Config.Locale]
        })
    end
    TriggerServerEvent('ctake:server:fetchData')
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(0)
    SendNUIMessage({
        action = "open",
        casinoName = Config.CasinoName,
    })
end)

RegisterNUICallback('close', function ()
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(0)
end)

RegisterNUICallback('getLivematches', function(data)
    TriggerServerEvent('ctake:server:getLivematches')
    TriggerServerEvent('ctake:server:getUpcomingmatches')
end)

RegisterNUICallback('updatePFP', function(data)
    TriggerServerEvent('ctake:server:updatePFP', data.url)
end)

RegisterNUICallback('updateName', function(data)
    TriggerServerEvent('ctake:server:updateName', data.name)
end)

RegisterNUICallback('deposit', function(data)
    TriggerServerEvent('ctake:server:deposit', data.type, data.amount)
end)

RegisterNUICallback('withdraw', function(data)
    TriggerServerEvent('ctake:server:withdraw', data.type, data.amount)
end)

RegisterNUICallback('getMyBets', function(data)
    TriggerServerEvent('ctake:server:getMyBets')
end)

RegisterNUICallback('sendMessage', function(data)
    TriggerServerEvent('ctake:server:sendMessage', data.message)
end)

RegisterNUICallback('deleteMessage', function(data)
    TriggerServerEvent('ctake:server:deleteMessage', data.index)
end)

RegisterNUICallback('banPlayer', function(data)
    TriggerServerEvent('ctake:server:banPlayer', data.index)
end)

RegisterNUICallback('timeoutPlayer', function(data)
    TriggerServerEvent('ctake:server:timeoutPlayer', data.index)
end)

RegisterNUICallback('playCoupon', function(data)
    TriggerServerEvent('ctake:server:playCoupon', data)
end)

RegisterNetEvent('ctake:client:receiveData', function(data)
    SendNUIMessage({
        action = "receiveData",
        data = data
    })
end)

RegisterNetEvent('ctake:client:receiveMessages', function(data)
    SendNUIMessage({
        action = "receiveMessages",
        data = data
    })
end)

RegisterNetEvent('ctake:client:receiveLivematches', function(data)
    SendNUIMessage({
        action = "receiveLivematches",
        data = data
    })
end)

RegisterNetEvent('ctake:client:receiveUpcomingmatches', function(data)
    SendNUIMessage({
        action = "receiveUpcomingmatches",
        data = data
    })
end)

RegisterNetEvent('ctake:client:receiveBets', function(data)
    SendNUIMessage({
        action = "receiveBets",
        data = data
    })
end)

Citizen.CreateThread(function()
    TriggerServerEvent('ctake:server:fetchObjects')
end)

RegisterNetEvent('ctake:client:receiveObjects', function(data)
    for k,v in pairs(objects) do 
        DeleteObject(v)
    end

    for k,v in pairs(data) do 
        local obj = GetHashKey("qua_ocasino_betmachine")
        RequestModel(obj)
        while not HasModelLoaded(obj) do
            Citizen.Wait(0)
        end
        local obj2 = CreateObject(obj, v.x, v.y, v.z - 0.6, false, false, true)
        SetEntityHeading(obj2, v.h)
        FreezeEntityPosition(obj2, true)
        objects[k] = obj2
    end
end)


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    for k,v in pairs(objects) do 
        DeleteObject(v)
    end
end)
