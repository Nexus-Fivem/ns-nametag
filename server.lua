local players = {}

local function isAdmin(playerId)
    local playerHexId = GetPlayerIdentifier(playerId, 0)
    print(playerHexId)
    for _, adminHex in ipairs(Config.Admins) do
        if 'steam:'..adminHex == playerHexId then
            return true
        end
    end
    return false
end

local function isMod(playerId)
    local playerHexId = GetPlayerIdentifier(playerId, 0)
    print(playerHexId)
    for _, adminHex in ipairs(Config.Mods) do
        if 'steam:'..adminHex == playerHexId then
            return true
        end
    end
    return false
end

RegisterNetEvent('nametag:setPlayerName')
AddEventHandler('nametag:setPlayerName', function(playerName)
    local src = source
    players[src] = {
        name = playerName,
        isAdmin = isAdmin(src),
        isMod = isMod(src)
    }
    print(isAdmin(source))
    TriggerClientEvent('nametag:updateNames', -1, players)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    players[src] = nil
    TriggerClientEvent('nametag:updateNames', -1, players)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerClientEvent('nametag:updateNames', -1, players)
    end
end)

