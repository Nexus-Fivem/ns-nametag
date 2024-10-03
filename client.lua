local playerNames = {}

CreateThread(function()
    local playerId = PlayerId()
    local playerName = GetPlayerName(playerId)
    local name = nil
    if Config.DisplayName then 
        if Config.Framework == "QBCore" then
            Wait(100)
            local QBCore = exports['qb-core']:GetCoreObject()
            local PlayerData = QBCore.Functions.GetPlayerData()
            if Config.Surname then
                name = PlayerData.charinfo.firstname.." "..PlayerData.charinfo.lastname
                print(name)
            else 
                name = PlayerData.charinfo.firstname
                print(name)
            end
            print(name)
            TriggerServerEvent('nametag:setPlayerName', name)
        elseif Config.Framework == "ESX" then
            local ESX = exports["es_extended"]:getSharedObject()
            local PlayerData = ESX.GetPlayerData()
            if Config.Surname then
                name = PlayerData.firstName.." "..PlayerData.lastName
            else 
                name = PlayerData.firstName
            end
        TriggerServerEvent('nametag:setPlayerName', name)
        end
    else
    TriggerServerEvent('nametag:setPlayerName', playerName)
    end
end)

RegisterNetEvent('nametag:updateNames')
AddEventHandler('nametag:updateNames', function(players)
    playerNames = players
end)

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local playersData = {}
        for _, player in ipairs(GetActivePlayers()) do
            local otherPed = GetPlayerPed(player)
            if otherPed ~= playerPed then
                local otherCoords = GetEntityCoords(otherPed)
                local bonecoords = GetWorldPositionOfEntityBone(otherPed, 12844)
                local distance = #(playerCoords - otherCoords)
                if distance < Config.Distance then
                    local playerId = GetPlayerServerId(player)
                    local playerData = playerNames[playerId]
                    if playerData then
                        local playerName = playerData.name or "Unknown"
                        local isAdmin = playerData.isAdmin
                        local isMod = playerData.isMod
                        local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(otherCoords.x, otherCoords.y, otherCoords.z + 1)
                        if onScreen then
                            screenX = screenX - 0.125
                            screenY = screenY - 0.06
                            if IsPedInAnyVehicle(otherPed) then 
                                screenY = screenY - 0.02
                            end
                            local scale = math.max(0.5, 1.0 - (distance / 50.0)) 
                            table.insert(playersData, {
                                playerId = playerId,
                                playerName = playerName,
                                screenX = screenX,
                                screenY = screenY,
                                scale = scale,
                                isAdmin = isAdmin,
                                isMod = isMod
                            })
                        end
                    end
                end
            end
        end
        SendNUIMessage({
            type = "updateNametags",
            players = playersData
        })

        Wait(0)
    end
end)
