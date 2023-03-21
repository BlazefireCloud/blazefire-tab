local tabletObj = null

RegisterCommand('openNUI', function()
    if not Config.OpenIfInVehicle then
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            return
        end
    end
    
    if not Config.OpenIfDead then
        if IsPlayerDead(PlayerPedId()) then
            return
        end
    end
    
    TOGGLE_NUI(true)
end)

RegisterNuiCallback('close', function(data, cb)
    TOGGLE_NUI(false)
    STOP_ANIMATION()
    cb('ok')
end)

RegisterKeyMapping('openNUI', '', 'keyboard', Config.Key)


TOGGLE_NUI = function(bool)
    SetNuiFocus(bool, bool)
    if bool then
        SendNUIMessage({
            action = 'open',
            data = Config.URLS,
            horizontal = Config.Horizontal
        })
        PLAY_ANIMATION()
    end
end

PLAY_ANIMATION = function()
    local ped = PlayerPedId()
    local animDict = 'amb@code_human_in_bus_passenger_idles@female@tablet@idle_a'
    local animName = 'idle_a'
    local tabletProp = 'prop_cs_tablet'
    local tabletBone = 28422
    local tabletOffset = vector3(-0.05, 0.0, 0.0)
    local tabletRot = vector3(0.0, 0.0, 0.0)

    tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)
    local tabletBoneIndex = GetPedBoneIndex(ped, tabletBone)

    SetCurrentPedWeapon(ped, 'weapon_unarmed', true)
    AttachEntityToEntity(tabletObj, ped, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x, tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
    SetModelAsNoLongerNeeded(tabletProp)

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0) 
    end

    TaskPlayAnim(ped, animDict, animName, 1.0, 1.0, -1, 51, 1, true, true, true)
end

STOP_ANIMATION = function()
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    DetachEntity(tabletObj, true, false)
    DeleteEntity(tabletObj)
end