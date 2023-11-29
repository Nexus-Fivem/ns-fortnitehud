local steamData = {}

function ExtractIdentifiers(src)
    local identifiers = {}
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        end
    end
    return identifiers
end

RegisterNetEvent("ns-fortnitehud:refreshdata")
AddEventHandler("ns-fortnitehud:refreshdata", function()
    local source = source
    local ids = ExtractIdentifiers(source)
    local steamID = ""

    if ids.steam then
        steamID = ids.steam:gsub("steam:", "")
    else
        steamID = ""
    end

    steamID = tonumber(steamID, 16)

    local steamAPIKey = Config.steamAPIKey
    local steamAPIURL = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" .. steamAPIKey .. "&steamids=" .. steamID

    PerformHttpRequest(steamAPIURL, function(err, text, headers)
        local jsonData = json.decode(text)
        local profile = jsonData.response.players[1]

        if profile then
            local avatarURL = profile.avatarfull
            local steamName = profile.personaname

            steamData[source] = {
                steamID = steamID,
                avatarURL = avatarURL,
                steamName = steamName
            }

            TriggerClientEvent("ns-fortnitehud:getsteamdata", source, steamData[source])
        else
            print("Steam profili bulunamadı.")
        end
    end)
end)

RegisterNetEvent('ns-fortnitehud:allonlines', function()
    TriggerClientEvent('ns-fortnitehud:getonlines', source, #GetPlayers())
end)

local PlayerKills = {}

RegisterServerEvent('ns-fortnitehud:playerDied')
AddEventHandler('ns-fortnitehud:playerDied', function(killerID)
    if killerID then
        if PlayerKills[killerID] == nil then
            PlayerKills[killerID] = 0
        end
        PlayerKills[killerID] = PlayerKills[killerID] + 1
        TriggerClientEvent('ns-fortnitehud:load', killerID, nil, nil, PlayerKills[killerID], nil)
    end
end)
