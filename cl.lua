
local kill = 0
local bombs = {
    -1600701090,
    -1813897027,
    615608432,
    -1420407917,
    126349499,
    -1169823560,
    600439132,
    -37975472,
    1233104067,
    741814745,
    101631238,
    -1168940174,
}

CreateThread(function()
    while true do
        Wait(10)
        TriggerEvent('ns-fortnitehud:load')
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        TriggerServerEvent("ns-fortnitehud:refreshdata")
    end
end)

CreateThread(function()
    
    while true do
        local oyuncu = PlayerPedId();
        Wait(200)
        local _, weaponHash = GetCurrentPedWeapon(oyuncu)
        if _ then
            local _, clipAmmo = GetAmmoInClip(oyuncu, weaponHash)
            local totalAmmo = GetAmmoInPedWeapon(oyuncu, weaponHash)
            if IsControlPressed(0, 24) or lastAmmo ~= clipAmmo or  lastMaxAmmo ~= totalAmmo then
             
                if  IsPedArmed(oyuncu, 4 ) then
                    if weaponHash then 
                    end

                        TriggerEvent("ns-fortnitehud:load", math.ceil(totalAmmo-clipAmmo), math.ceil(clipAmmo))
                        lastAmmo = clipAmmo
                        lastMaxAmmo = totalAmmo
                        Wait(5)
                end 
            end
            else i = 1, #bombs do
                TriggerEvent("ns-fortnitehud:load", 0, GetAmmoInPedWeapon(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId())))
            end
        end
    end
end)

RegisterNetEvent("ns-fortnitehud:getsteamdata")
AddEventHandler("ns-fortnitehud:getsteamdata", function(data)
    SendNUIMessage({
        type = 'infolar',
        steamfoto = data.avatarURL,
        isim = data.steamName
    })
end)

CreateThread(function()
    while true do 
        TriggerServerEvent('ns-fortnitehud:allonlines')
        Wait(5000)
    end
end)

RegisterNetEvent('ns-fortnitehud:getonlines', function(online)
    TriggerEvent('ns-fortnitehud:load', nil, nil, nil, online)
end)






RegisterNetEvent('ns-fortnitehud:load', function(totalAmmo, clipAmmo, kill, players)
    local weapon = GetSelectedPedWeapon(PlayerPedId());
    local oyuncu = PlayerPedId();


    local loadData = {
        cantakey = Config.Inventory,
        mapkey = Config.Map,
        health = GetEntityHealth(oyuncu)/2,
        healthlow = GetEntityHealth(oyuncu)/2,
        stamina = math.ceil(100 - GetPlayerSprintStaminaRemaining(PlayerId())),
        armor = GetPedArmour(oyuncu),
        armorlow = GetPedArmour(oyuncu),
        weapon = GetSelectedPedWeapon(oyuncu),
        clipAmmo = clipAmmo,
        totalAmmo = totalAmmo,
        killnumber = kill,
        players = players,
        carheal = GetEntityHealth(GetVehiclePedIsIn(oyuncu)),
        id = GetPlayerServerId(PlayerId()),
        konusma = MumbleIsPlayerTalking(PlayerId()),
        arabadami = GetVehiclePedIsUsing(oyuncu)
     
    }


    SendNUIMessage({
        type = 'updateHud',
        data = loadData
    })

end)

CreateThread(function()
    local minimapOn = true
    RegisterCommand("minimap", function()
        minimapOn = not minimapOn
    end, false)

    CreateThread(function()
        while true do
            DisplayRadar(minimapOn)
            DisplayAmmoThisFrame(false)
            Wait(1)
        end
    end)
end)

-- Minimap
CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    while not HasScaleformMovieLoaded(minimap) do
      Wait(1)
    end
    SetMinimapComponentPosition('minimap', 'L', 'B', 0.822, -0.725, 0.165, 0.265)
    SetMinimapComponentPosition('minimap_mask', "I", "I", 0.83, -0.725, 0.35, 0.15)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.83, -0.68, 0.226, 0.326)

    SetRadarBigmapEnabled(true, false)
    Wait(500)
    SetRadarBigmapEnabled(false, false)
    SetBlipAlpha(GetNorthRadarBlip(), 0)
    while true do
        Wait(1)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

-- Hitmarker

AddEventHandler('gameEventTriggered', function(name, data)
    print("hello")
    local sure = 0
   if Config.HitMarker then
        if name == "CEventNetworkEntityDamage" then
            if health == nil then 
                health = GetEntityMaxHealth(data[2])
            end
            local sourceEntity = data[1]
            local Player = data[2]

            if Player == PlayerPedId() and sourceEntity ~= Player then
                if Config.ShowNPCDamages then
                    if IsPedAPlayer(Player) and GetEntityType(sourceEntity) == 1 then
                        repeat
                            local damage = math.ceil(health - GetEntityHealth(sourceEntity))

                            if GetEntityHealth(sourceEntity) >= 100 then
                                DrawText3D(GetEntityCoords(sourceEntity), damage, Config.ArmorHitColor.r, Config.ArmorHitColor.g, Config.ArmorHitColor.b)
                            else
                                DrawText3D(GetEntityCoords(sourceEntity), damage, Config.NormalHitColor.r, Config.NormalHitColor.g, Config.NormalHitColor.b)
                            end

                            sure = sure + 1
                            Wait(1)
                        until sure > 50
                        health = GetEntityHealth(sourceEntity)
                    end
                else
                    if IsPedAPlayer(Player) and GetEntityType(sourceEntity) == 1 and IsPedAPlayer(sourceEntity) then
                        repeat
                            local damage = math.ceil(health - GetEntityHealth(sourceEntity))

                            if GetEntityHealth(sourceEntity) >= 100 then
                                DrawText3D(GetEntityCoords(sourceEntity), damage, Config.ArmorHitColor.r, Config.ArmorHitColor.g, Config.ArmorHitColor.b)
                            else
                                DrawText3D(GetEntityCoords(sourceEntity), damage, Config.NormalHitColor.r, Config.NormalHitColor.g, Config.NormalHitColor.b)
                            end

                            sure = sure + 1
                            Wait(1)
                        until sure > 200
                        health = GetEntityHealth(sourceEntity)
                    end
                end
            end
        end
    end
end)

function DrawText3D(coords, text, r, g, b)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)

    if onScreen then
        SetTextOutline(1)
        SetTextScale(0.50, 0.50)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(x, y)
        
    end
end

-- Kill Counter 
Citizen.CreateThread(function()
    local Killer

    while true do
        Citizen.Wait(0)

        if IsEntityDead(PlayerPedId()) then
            Citizen.Wait(500)

            local PedKiller = nil
            local success, error = pcall(function()
                PedKiller = GetPedSourceOfDeath(PlayerPedId())
            end)

            if not success then
                PedKiller = PlayerPedId()
            end 

            local success, error = pcall(function()
                if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
                    Killer = NetworkGetPlayerIndexFromPed(PedKiller)
                elseif IsEntityAVehicle(PedKiller) and
                    IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and
                    IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
                    Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
                end
            end)

            if not success then
                Killer = nil
            end
            TriggerServerEvent('ns-fortnitehud:playerDied', GetPlayerServerId(Killer))
        end

        while IsEntityDead(PlayerPedId()) do
            Citizen.Wait(0)
        end
    end
end)

