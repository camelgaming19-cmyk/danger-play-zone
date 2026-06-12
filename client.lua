local spawnedPeds = {}
local spawnedVehicles = {}
local selectedAttacker = nil
local selectedTarget = nil
local selectMode = false
local selectIndex = 1
local mainMenu = nil
local isMenuOpen = false
local convoyDestination = nil

CreateThread(function()
    print("^2[AI-MENU] Loading System...^7")
    mainMenu = CreateAIMenu()
    print("^2[AI-MENU] Loaded Successfully! Press F6^7")
end)

RegisterCommand("ai_menu", function()
    isMenuOpen = not isMenuOpen
end, false)

RegisterKeyMapping("ai_menu", "Open AI Menu", "keyboard", "F6")

CreateThread(function()
    while true do
        Wait(0)

        if isMenuOpen then
            ProcessMenuInput()
            DisplayMenu(mainMenu)
        end
    end
end)

function CreateAIMenu()

    local menu = {
        title = "~b~RP AI SYSTEM",
        subtitle = "~g~Gang • Police • Vehicles",
        items = {},
        selected = 1,
        toplndex = 1
    }

    table.insert(menu.items, {label="~g~[NPC] Guard", model="s_m_y_swat_01", type="spawn"})
    table.insert(menu.items, {label="~g~[NPC] Civilian", model="g_m_y_lost_01", type="spawn"})
    table.insert(menu.items, {label="~r~[GANG] Member", model="g_m_y_ballasout_01", type="spawn"})
    table.insert(menu.items, {label="~b~[POLICE] Officer", model="a_f_o_indian_01", type="spawn"})

    table.insert(menu.items, {label="~y~[VEHICLE] Sultan", vehicle="sultan", type="vehicle"})
    table.insert(menu.items, {label="~y~[VEHICLE] Police Cruiser", vehicle="police", type="vehicle"})
    table.insert(menu.items, {label="~y~[VEHICLE] Gang Car", vehicle="baller", type="vehicle"})
    table.insert(menu.items, {label="~b~[BACKUP] Call Backup Team", type="backupcall"})
    table.insert(menu.items, {label="~y~[ANIM] Namaste", type="namaste"})
    table.insert(menu.items, {label="~b~[VIP] Spawn Bodyguards", type="bodyguards"})
    

    table.insert(menu.items, {label="~y~[NPC] Select Attacker (J/U + ENTER)", type="selectnpc"})


    table.insert(menu.items, {label="~r~[NPC] Select Attacker", type="selectattacker"})

    table.insert(menu.items, {label="~r~[GANG] Helicopter", type="gangheli"})
    table.insert(menu.items, {label="~p~[PLAYER] Helicopter", type="playerheli"})

    table.insert(menu.items, {label="~b~[POLICE] Helicopter", vehicle="polmav", type="vehicle"})

    table.insert(menu.items, {label="~b~[TASK] Follow Me", type="follow"})
    table.insert(menu.items, {label="~g~[PLAYER] God Mode ON/OFF", type="godmode"})
    table.insert(menu.items, {label="~r~[SCENE] Kidnap Convoy",type="kidnapconvoy"})
    

    table.insert(menu.items, {label="~r~[TASK] Stop Follow", type="stopfollow"})
    table.insert(menu.items, {label="~g~[TASK] Guard Position", type="guard"})
    table.insert(menu.items, {label="~r~[TASK] Delete Last NPC", type="delete"})
    table.insert(menu.items, {label="~r~[VEHICLE] Delete Last Vehicle", type="deletevehicle"})

    table.insert(menu.items, {label="~r~[TASK] Attack Target", type="attack"})
    table.insert(menu.items, {label="~y~[TASK] Go To Waypoint", type="waypoint"})

    table.insert(menu.items, {label="~g~[WEAPON] Give Pistol", type="pistol"})
    table.insert(menu.items, {label="~r~[WEAPON] Remove Weapons", type="removeweapons"})
    table.insert(menu.items, {label="~y~[VEHICLE] Enter Vehicle", type="entervehicle"})
    table.insert(menu.items, {label="~r~[VEHICLE] Exit Vehicle", type="exitvehicle"})
    table.insert(menu.items, {label="~y~[VEHICLE] Drive To Waypoint", type="drivetowaypoint"})
    table.insert(menu.items, {label="~b~[VEHICLE] Front Passenger", type="frontpassenger"})
    table.insert(menu.items, {label="~b~[VEHICLE] Rear Left Seat", type="rearleft"})
    table.insert(menu.items, {label="~b~[VEHICLE] Rear Right Seat", type="rearright"})
    table.insert(menu.items, {label="~g~[GROUP] All NPCs Enter Vehicle", type="allentervehicle"})
    table.insert(menu.items, {label="~p~[FUN] Dance", type="dance"})
    table.insert(menu.items, {label="~p~[FUN] Hands Up", type="handsup"})
    table.insert(menu.items, {label="~p~[FUN] Sit Down", type="sitdown"})
    table.insert(menu.items, {label="~p~[FUN] Wave", type="wave"})
    table.insert(menu.items, {label="~c~[CONVOY] Start Convoy", type="convoy"})
    table.insert(menu.items, {label="~y~[VEHICLE] Drive To Waypoint", type="drivetowaypoint"})
    table.insert(menu.items, {label="~p~[FUN] Talk", type="talk"})
    table.insert(menu.items, {label="~r~[GROUP] All NPCs Exit Vehicle", type="allexitvehicle"})
    table.insert(menu.items, {label="~b~[GROUP] Formation", type="formation"})
    table.insert(menu.items, {label="~r~[GROUP] Surround Boss", type="surroundboss"})
    table.insert(menu.items, {label="~y~[SCENE] Mafia Meeting", type="mafiameeting"})
    table.insert(menu.items, {label="~r~[SCENE] Spawn Boss", type="spawnboss"})


    return menu
end

function ProcessMenuInput()

    if IsControlJustPressed(0, 172) then
        mainMenu.selected = mainMenu.selected - 1
        if mainMenu.selected < 1 then
            mainMenu.selected = #mainMenu.items
        end

        if mainMenu.selected < mainMenu.topIndex then
    mainMenu.topIndex = mainMenu.selected
        end
    end

    if IsControlJustPressed(0, 173) then
        mainMenu.selected = mainMenu.selected + 1
        if mainMenu.selected > #mainMenu.items then
            mainMenu.selected = 1
        end

        if mainMenu.selected > mainMenu.topIndex + 8 then
    mainMenu.topIndex = mainMenu.selected - 8
end
    end

    -- ENTER KEY
    if IsControlJustPressed(0, 191) then
        local item = mainMenu.items[mainMenu.selected]
        HandleMenuSelection(item)
    end
end

function HandleMenuSelection(item)

    if item.type == "spawn" then
        SpawnPed(item.model)

    elseif item.type == "vehicle" then
        SpawnVehicle(item.vehicle)
    elseif item.type == "backupcall" then
        CallBackup()
    elseif item.type == "namaste" then
        PlayNamasteAnim()
    elseif item.type == "bodyguards" then
        SpawnBodyguards()

    elseif item.type == "selectnpc" then
        StartNPCSelectMode()
    elseif item.type == "selectattacker" then
        SelectAttacker()
    elseif item.type == "policeheli" then
        SpawnPoliceHeli()
    elseif item.type == "gangheli" then
        SpawnGangHeli()
    elseif item.type == "playerheli" then
        SpawnPlayerHeli()

    elseif item.type == "follow" then
        FollowLastPed()
    elseif item.type == "godmode" then
        ToggleGodMode()
    elseif item.type == "kidnapconvoy" then
        KidnapConvoy()

    elseif item.type == "stopfollow" then
        StopFollowLastPed()

    elseif item.type == "guard" then
        GuardLastPed()

    elseif item.type == "delete" then
        DeleteLastPed()
    elseif item.type == "deletevehicle" then
        DeleteLastVehicle()

    elseif item.type == "attack" then
        AttackNearestPed()

    elseif item.type == "waypoint" then
        GoToWaypoint()

    elseif item.type == "pistol" then
        GivePistolToLastPed()

    elseif item.type == "removeweapons" then
        RemoveWeaponsFromLastPed()
    elseif item.type == "entervehicle" then
        EnterLastVehicle()
    elseif item.type == "exitvehicle" then
        ExitVehicle()
    elseif item.type == "drivetowaypoint" then
        DriveToWaypoint()
    elseif item.type == "frontpassenger" then
        FrontPassengerSeat()
    elseif item.type == "rearleft" then
        RearLeftSeat()
    elseif item.type == "rearright" then
        RearRightSeat()
    elseif item.type == "allentervehicle" then
        AllNPCsEnterVehicle()
    elseif item.type == "dance" then
        DanceAllNPCs()
    elseif item.type == "handsup" then
        HandsUpAllNPCs()
    elseif item.type == "sitdown" then
        SitDownAllNPCs()
    elseif item.type == "wave" then
        WaveAllNPCs()
    elseif item.type == "convoy" then
        StartConvoy()
    elseif item.type == "drivetowaypoint" then
        DriveToWaypoint()
    elseif item.type == "talk" then
        TalkAllNPCs()
    elseif item.type == "allexitvehicle" then
        AllNPCsExitVehicle()
    elseif item.type == "formation" then
        FormationNPCs()    
    elseif item.type == "surroundboss" then
        SurroundBoss()
    elseif item.type == "mafiameeting" then
        MafiaMeeting()
    elseif item.type == "spawnboss" then
        SpawnBoss()
    end
end

function GetSafeCoords(x, y, z)

    local found, groundZ = GetGroundZFor_3dCoord(x, y, z + 50.0, false)

    if found then
        return vector3(x, y, groundZ)
    end

    return vector3(x, y, z)
end

function SpawnPed(modelName)

    local model = GetHashKey(modelName)

    RequestModel(model)

    local timeout = 0

    while not HasModelLoaded(model) and timeout < 200 do
        Wait(10)
        timeout = timeout + 1
    end

    if not HasModelLoaded(model) then
        print("^1[AI-MENU] Failed to load model: " .. modelName .. "^7")
        return
    end

    local player = PlayerPedId()
    local coords = GetEntityCoords(player)

    local safeCoords = GetSafeCoords(coords.x + 2.0, coords.y + 2.0, coords.z)

    local ped = CreatePed(
        4,
        model,
        safeCoords.x,
        safeCoords.y,
        safeCoords.z,
        GetEntityHeading(player),
        true,
        true
    )

    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanRagdoll(ped, false)
    --SetPedAsGroupMember(ped, GetPedGroupIndex(player))
    SetPedRelationshipGroupHash(ped, GetHashKey("HATES_PLAYER"))

    SetPedCombatAttributes(ped, 46, true)
    SetPedCombatAttributes(ped, 5, true)

    SetPedCombatAbility(ped, 2)
    SetPedCombatMovement(ped, 2)
    SetPedCombatRange(ped, 2)

    SetPedFleeAttributes(ped, 0, false)
    SetBlockingOfNonTemporaryEvents(ped, true)

    SetPedSeeingRange(ped, 100.0)
    SetPedHearingRange(ped, 100.0)

    table.insert(spawnedPeds, ped)

    print("^2[AI-MENU] Spawned NPC: " .. modelName .. "^7")

    SetModelAsNoLongerNeeded(model)
end

function SpawnVehicle(modelName)

    local model = GetHashKey(modelName)

    RequestModel(model)

    local timeout = 0

    while not HasModelLoaded(model) and timeout < 200 do
        Wait(10)
        timeout = timeout + 1
    end

    if not HasModelLoaded(model) then
        print("^1[AI-MENU] Failed to load vehicle: " .. modelName .. "^7")
        return
    end

    local player = PlayerPedId()
    local coords = GetEntityCoords(player)

    local safeCoords = GetSafeCoords(coords.x + 5.0, coords.y + 5.0, coords.z)

    local veh = CreateVehicle(
        model,
        safeCoords.x,
        safeCoords.y,
        safeCoords.z,
        GetEntityHeading(player),
        true,
        false
    )

    SetVehicleOnGroundProperly(veh)
    SetEntityAsMissionEntity(veh, true, true)

    table.insert(spawnedVehicles, veh)

    print("^2[AI-MENU] Spawned Vehicle: " .. modelName .. "^7")

    SetModelAsNoLongerNeeded(model)
end

function CallBackup()

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local spawnPos = GetOffsetFromEntityInWorldCoords(
        playerPed,
        math.random(80,120),
        math.random(-40,40),
        0.0
    )

    local foundGround, groundZ = GetGroundZFor_3dCoord(
        spawnPos.x,
        spawnPos.y,
        spawnPos.z + 100.0,
        false
    )

    if foundGround then
        spawnPos = vector3(
            spawnPos.x,
            spawnPos.y,
            groundZ
        )
    end

    local vehModel = GetHashKey("sultan")

    RequestModel(vehModel)

    while not HasModelLoaded(vehModel) do
        Wait(10)
    end

    local veh = CreateVehicle(
        vehModel,
        spawnPos.x,
        spawnPos.y,
        spawnPos.z,
        GetEntityHeading(playerPed),
        true,
        true
    )

    SetEntityAsMissionEntity(veh,true,true)

    SetVehicleOnGroundProperly(veh)

    SetEntityInvincible(veh,true)

    table.insert(spawnedVehicles,veh)

    local pedModel = GetHashKey("s_m_y_swat_01")

    RequestModel(pedModel)

    while not HasModelLoaded(pedModel) do
        Wait(10)
    end

    local driver = CreatePedInsideVehicle(
        veh,
        4,
        pedModel,
        -1,
        true,
        false
    )

    local bodyguard = CreatePedInsideVehicle(
        veh,
        4,
        pedModel,
        0,
        true,
        false
    )

    SetEntityInvincible(driver,true)
    SetEntityInvincible(bodyguard,true)

    SetEntityHealth(driver,1000)
    SetEntityHealth(bodyguard,1000)

    GiveWeaponToPed(
        driver,
        GetHashKey("WEAPON_CARBINERIFLE"),
        9999,
        false,
        true
    )

    GiveWeaponToPed(
        bodyguard,
        GetHashKey("WEAPON_CARBINERIFLE"),
        9999,
        false,
        true
    )

    SetCurrentPedWeapon(
        driver,
        GetHashKey("WEAPON_CARBINERIFLE"),
        true
    )

    SetCurrentPedWeapon(
        bodyguard,
        GetHashKey("WEAPON_CARBINERIFLE"),
        true
    )

    SetPedCombatAbility(driver,2)
    SetPedCombatAbility(bodyguard,2)

    SetPedCombatMovement(driver,2)
    SetPedCombatMovement(bodyguard,2)

    SetPedCombatRange(driver,2)
    SetPedCombatRange(bodyguard,2)

    table.insert(spawnedPeds,driver)
    table.insert(spawnedPeds,bodyguard)

    TaskVehicleDriveToCoord(
        driver,
        veh,
        playerCoords.x,
        playerCoords.y,
        playerCoords.z,
        40.0,
        0,
        GetEntityModel(veh),
        786603,
        5.0,
        true
    )

    CreateThread(function()

        while DoesEntityExist(veh) do

            Wait(1000)

            local dist =
                #(GetEntityCoords(veh) - GetEntityCoords(playerPed))

            if dist <= 12.0 then

                TaskVehicleTempAction(
                    driver,
                    veh,
                    27,
                    2000
                )

                Wait(1500)

                TaskLeaveVehicle(
                    bodyguard,
                    veh,
                    0
                )

                Wait(2000)

                TaskCombatHatedTargetsAroundPed(
                    bodyguard,
                    200.0,
                    0
                )

                break
            end
        end
    end)

    print("^2[AI-MENU] Backup Team En Route^7")

end

function PlayNamasteAnim()

    local ped = spawnedPeds[1] -- ONLY FIRST SPAWNED NPC

    if not ped or not DoesEntityExist(ped) then
        print("^1[AI-MENU] First NPC Not Found^7")
        return
    end

    local playerPed = PlayerPedId()

    ClearPedTasksImmediately(ped)

    TaskTurnPedToFaceEntity(
        ped,
        playerPed,
        1000
    )

    Wait(1000)

    RequestAnimDict("anim@heists@ornate_bank@hostages@ped_c@")

    while not HasAnimDictLoaded("anim@heists@ornate_bank@hostages@ped_c@") do
        Wait(10)
    end

    TaskPlayAnim(
        ped,
        "anim@heists@ornate_bank@hostages@ped_c@",
        "flinch_loop",
        8.0,
        -8.0,
        -1,
        1,
        0,
        false,
        false,
        false
    )

    print("^2[AI-MENU] Namaste/Plead Animation Started^7")
end

function SpawnBodyguards()

    local playerPed = PlayerPedId()

    local model = GetHashKey("s_m_m_security_01")

    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(10)
    end

    for i = 1, 3 do

        local coords = GetOffsetFromEntityInWorldCoords(
            playerPed,
            i * 1.5,
            -2.0,
            0.0
        )

        local ped = CreatePed(
            4,
            model,
            coords.x,
            coords.y,
            coords.z,
            GetEntityHeading(playerPed),
            true,
            true
        )

        SetEntityAsMissionEntity(ped, true, true)

        GiveWeaponToPed(
            ped,
            GetHashKey("WEAPON_CARBINERIFLE"),
            9999,
            false,
            true
        )

        SetCurrentPedWeapon(
            ped,
            GetHashKey("WEAPON_CARBINERIFLE"),
            true
        )

        SetPedCombatAttributes(ped, 46, true)
        SetPedCombatAbility(ped, 2)
        SetPedCombatMovement(ped, 2)
        SetPedCombatRange(ped, 2)

        SetBlockingOfNonTemporaryEvents(ped, true)

        table.insert(spawnedPeds, ped)

        -- Follow Player
        TaskFollowToOffsetOfEntity(
            ped,
            playerPed,
            (i - 2) * 2.0,
            -2.0,
            0.0,
            5.0,
            -1,
            2.0,
            true
        )

        -- Protection Thread
        CreateThread(function()

            while DoesEntityExist(ped) do

                Wait(500)

                if HasEntityBeenDamagedByAnyPed(playerPed) then

                    local attacker =
                        GetPedSourceOfDamage(playerPed)

                    if attacker and attacker ~= 0 then

                        TaskCombatPed(
                            ped,
                            attacker,
                            0,
                            16
                        )

                    end
                end
            end
        end)
    end

    SetModelAsNoLongerNeeded(model)

    print("^2[AI-MENU] 3 Bodyguards Spawned^7")
end

    selectMode = true
    selectIndex = 1

    print("^2[AI-MENU] Selection Mode Started (J/U + ENTER)^7")

    CreateThread(function()

        while selectMode do
            Wait(0)

            -- J KEY (NEXT NPC)
            if IsControlJustPressed(0, 311) then -- J
                selectIndex = selectIndex + 1
                if selectIndex > #spawnedPeds then
                    selectIndex = 1
                end
            end

            -- U KEY (PREVIOUS NPC)
            if IsControlJustPressed(0, 303) then -- U
                selectIndex = selectIndex - 1
                if selectIndex < 1 then
                    selectIndex = #spawnedPeds
                end
            end

            local ped = spawnedPeds[selectIndex]

            -- DRAW MARKER ON HEAD
            if ped and DoesEntityExist(ped) then

                local coords = GetPedBoneCoords(ped, 0x796e, 0.0, 0.0, 0.3)

                DrawMarker(
                    0,
                    coords.x, coords.y, coords.z + 0.2,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    0.2, 0.2, 0.2,
                    0, 255, 0, 200,
                    false, true, 2, nil, nil, false
                )
            end

            -- ENTER KEY (CONFIRM)
            if IsControlJustPressed(0, 191) then

                local ped = spawnedPeds[selectIndex]

                if ped and DoesEntityExist(ped) then

                    selectedAttacker = ped

                    selectMode = false

                    print("^2[AI-MENU] Attacker Selected^7")
            end
        end
    end
end)

function SelectAttacker()

    -- safety check
    if not spawnedPeds or #spawnedPeds == 0 then
        print("^1[AI-MENU] No NPC spawned^7")
        return
    end

    local ped = spawnedPeds[#spawnedPeds]

    if ped and DoesEntityExist(ped) then

        selectedAttacker = ped

        -- SAFE highlight method (NO crash)
        SetPedAsGroupMember(ped, GetPedGroupIndex(PlayerPedId()))

        SetBlockingOfNonTemporaryEvents(ped, true)

        ClearPedTasksImmediately(ped)

        TaskStandStill(ped, 1000)

        print("^2[AI-MENU] Attacker Selected Safe^7")

    else
        print("^1[AI-MENU] Invalid NPC^7")
    end
end

function SpawnPoliceHeli()

    local model = GetHashKey("polmav")

    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(10)
    end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    local heli = CreateVehicle(
        model,
        coords.x + 10.0,
        coords.y + 10.0,
        coords.z + 2.0,
        GetEntityHeading(playerPed),
        true,
        true
    )

    SetVehicleOnGroundProperly(heli)
    SetEntityAsMissionEntity(heli, true, true)

    table.insert(spawnedVehicles, heli)

    print("^2[AI-MENU] Police Helicopter Spawned^7")

    SetModelAsNoLongerNeeded(model)

end

function SpawnGangHeli()

    local model = GetHashKey("frogger") -- stable gang heli

    RequestModel(model)

    local timeout = 0
    while not HasModelLoaded(model) and timeout < 200 do
        Wait(10)
        timeout = timeout + 1
    end

    if not HasModelLoaded(model) then
        print("^1[AI-MENU] Failed to load Gang Helicopter^7")
        return
    end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    local heli = CreateVehicle(
        model,
        coords.x + 12.0,
        coords.y + 12.0,
        coords.z + 2.0,
        GetEntityHeading(playerPed),
        true,
        true
    )

    -- =========================
    -- BASIC SETUP
    -- =========================

    SetVehicleOnGroundProperly(heli)
    SetEntityAsMissionEntity(heli, true, true)

    -- =========================
    -- INVINCIBLE / BULLETPROOF
    -- =========================

    SetEntityInvincible(heli, true)
    SetEntityProofs(
        heli,
        true, true, true,
        true, true, true,
        true, true
    )

    SetVehicleEngineOn(heli, true, true, false)
    SetVehicleHasBeenOwnedByPlayer(heli, true)
    SetHeliBladesFullSpeed(heli)

    SetVehicleTyresCanBurst(heli, false)
    SetVehicleCanBreak(heli, false)

    SetVehicleEngineHealth(heli, 999999.0)
    SetVehicleBodyHealth(heli, 999999.0)
    SetVehiclePetrolTankHealth(heli, 999999.0)

    FreezeEntityPosition(heli, false)

    -- =========================
    -- GANG COLOR (BLACK STYLE)
    -- =========================

    SetVehicleColours(heli, 0, 0)

    -- =========================
    -- SAVE VEHICLE
    -- =========================

    table.insert(spawnedVehicles, heli)

    print("^1[AI-MENU] Gang Helicopter Spawned Successfully^7")

    SetModelAsNoLongerNeeded(model)

end

function SpawnPlayerHeli()

    local model = GetHashKey("swift")

    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(10)
    end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    local heli = CreateVehicle(
        model,
        coords.x + 15.0,
        coords.y + 15.0,
        coords.z + 2.0,
        GetEntityHeading(playerPed),
        true,
        true
    )

    SetVehicleOnGroundProperly(heli)

    SetEntityAsMissionEntity(heli, true, true)

    -- Unlimited Health
    SetEntityInvincible(heli, true)

    SetVehicleTyresCanBurst(heli, false)

    SetVehicleCanBreak(heli, false)

    SetVehicleEngineHealth(heli, 999999.0)

    SetVehicleBodyHealth(heli, 999999.0)

    SetVehiclePetrolTankHealth(heli, 999999.0)

    SetEntityProofs(
        heli,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true
    )

    table.insert(spawnedVehicles, heli)

    print("^2[AI-MENU] Invincible Player Helicopter Spawned^7")

    SetModelAsNoLongerNeeded(model)

end

function FollowLastPed()

    local ped = spawnedPeds[#spawnedPeds]

    if ped and DoesEntityExist(ped) then

        TaskFollowToOffsetOfEntity(
            ped,
            PlayerPedId(),
            0.0,
            -2.0,
            0.0,
            5.0,
            -1,
            2.0,
            true
        )

        print("^2[AI-MENU] NPC Follow Started^7")
    end
end

function ToggleGodMode()

    godModeEnabled = not godModeEnabled

    local playerPed = PlayerPedId()

    if godModeEnabled then

        SetEntityInvincible(playerPed, true)
        SetPedCanRagdoll(playerPed, false)
        SetEntityProofs(playerPed, true, true, true, true, true, true, true, true)

        CreateThread(function()
            while godModeEnabled do
                Wait(500)
                SetEntityHealth(playerPed, 200)
                ClearPedBloodDamage(playerPed)
            end
        end)

        print("^2[AI-MENU] GOD MODE ENABLED^7")

    else

        SetEntityInvincible(playerPed, false)
        SetPedCanRagdoll(playerPed, true)
        SetEntityProofs(playerPed, false, false, false, false, false, false, false, false)

        print("^1[AI-MENU] GOD MODE DISABLED^7")
    end
end

function KidnapConvoy()

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local vehicles = {}
    local peds = {}

    local vehicleModels = {
        "baller",
        "granger",
        "dubsta",
        "xls",
        "patriot2"
    }

    local gunPeds = {
        "g_m_y_ballaorig_01",
        "g_m_y_famca_01",
        "g_m_y_mexgoon_01"
    }

    local batPeds = {
        "g_m_y_lost_01"
    }

    print("^2[AI] Kidnap Convoy Started^7")

    -- =========================
    -- SPAWN CONVOY VEHICLES (100m behind road)
    -- =========================

    for i = 1, 5 do

        local vehModel = GetHashKey(vehicleModels[math.random(#vehicleModels)])

        RequestModel(vehModel)
        while not HasModelLoaded(vehModel) do Wait(10) end

        local spawnPos = GetOffsetFromEntityInWorldCoords(
            playerPed,
            math.random(-20, 20),
            80.0 + (i * 8),
            0.0
        )

        local veh = CreateVehicle(
            vehModel,
            spawnPos.x,
            spawnPos.y,
            spawnPos.z,
            GetEntityHeading(playerPed),
            true,
            true
        )

        SetVehicleOnGroundProperly(veh)
        SetEntityAsMissionEntity(veh, true, true)

        vehicles[#vehicles+1] = veh

        -- =========================
        -- DRIVER SPAWN
        -- =========================

        local driverModel = GetHashKey("g_m_y_ballaorig_01")
        RequestModel(driverModel)
        while not HasModelLoaded(driverModel) do Wait(10) end

        local driver = CreatePed(4, driverModel, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, true)

        SetPedIntoVehicle(driver, veh, -1)
        SetBlockingOfNonTemporaryEvents(driver, true)
        SetPedKeepTask(driver, true)

        TaskVehicleDriveToCoord(driver, veh,
            playerCoords.x,
            playerCoords.y,
            playerCoords.z,
            25.0,
            0,
            GetEntityModel(veh),
            786603,
            5.0,
            true
        )

        peds[#peds+1] = driver

        -- =========================
        -- GUN + BAT NPCs INSIDE VEHICLE
        -- =========================

        for seat = 0, 2 do

            local model

            if seat <= 1 then
                model = GetHashKey(gunPeds[math.random(#gunPeds)])
            else
                model = GetHashKey(batPeds[1])
            end

            RequestModel(model)
            while not HasModelLoaded(model) do Wait(10) end

            local ped = CreatePed(4, model, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, true)

            SetEntityAsMissionEntity(ped, true, true)
            SetBlockingOfNonTemporaryEvents(ped, true)

            SetPedIntoVehicle(ped, veh, seat)

            if seat <= 1 then
                GiveWeaponToPed(ped, GetHashKey("WEAPON_CARBINERIFLE"), 250, false, true)
                SetCurrentPedWeapon(ped, GetHashKey("WEAPON_CARBINERIFLE"), true)
            else
                GiveWeaponToPed(ped, GetHashKey("WEAPON_BAT"), 1, false, true)
                SetCurrentPedWeapon(ped, GetHashKey("WEAPON_BAT"), true)
            end

            peds[#peds+1] = ped
        end
    end

    -- =========================
    -- APPROACH LOOP
    -- =========================

    CreateThread(function()

        local triggered = false

        while not triggered do
            Wait(1000)

            local dist = #(GetEntityCoords(playerPed) - playerCoords)

            for _, veh in ipairs(vehicles) do

                if DoesEntityExist(veh) then

                    local d = #(GetEntityCoords(veh) - playerCoords)

                    if d < 18.0 then

                        triggered = true

                        local driver = GetPedInVehicleSeat(veh, -1)

                        if driver ~= 0 then
                            TaskVehicleTempAction(driver, veh, 27, 3000)
                        end

                        Wait(1500)

                        -- =========================
                        -- ALL NPC EXIT + ACTIONS
                        -- =========================

                        for _, ped in ipairs(peds) do

                            if DoesEntityExist(ped) then

                                TaskLeaveVehicle(ped, GetVehiclePedIsIn(ped, false), 0)
                                Wait(200)

                                ClearPedTasksImmediately(ped)

                                local weapon = GetSelectedPedWeapon(ped)

                                if weapon == GetHashKey("WEAPON_BAT") then
                                    TaskGoToEntity(ped, playerPed, -1, 1.2, 2.0, 0, 0)
                                    Wait(500)
                                    TaskCombatPed(ped, playerPed, 0, 16)

                                else
                                    TaskAimGunAtEntity(ped, playerPed, -1, true)
                                end
                            end
                        end

                        -- =========================
                        -- PLAYER HANDS UP
                        -- =========================

                        RequestAnimDict("missminuteman_1ig_2")
                        while not HasAnimDictLoaded("missminuteman_1ig_2") do Wait(10) end

                        TaskPlayAnim(playerPed,
                            "missminuteman_1ig_2",
                            "handsup_base",
                            8.0, -8.0, -1, 49, 0, false, false, false
                        )

                        print("^2[AI] Kidnap Scene Triggered^7")

                        break
                    end
                end
            end
        end
    end)

    -- =========================
    -- ESCAPE SYSTEM (WAYPOINT TAKEOVER)
    -- =========================

    CreateThread(function()

        while true do
            Wait(0)

            if IsControlJustPressed(0, 322) then -- ESC

                local blip = GetFirstBlipInfoId(8)

                if DoesBlipExist(blip) then

                    local coords = GetBlipInfoIdCoord(blip)

                    for _, veh in ipairs(vehicles) do

                        local driver = GetPedInVehicleSeat(veh, -1)

                        if driver ~= 0 then

                            TaskVehicleDriveToCoord(driver, veh,
                                coords.x, coords.y, coords.z,
                                30.0, 0,
                                GetEntityModel(veh),
                                786603,
                                5.0,
                                true
                            )
                        end
                    end

                    print("^3[AI] Convoy Moving to Escape Location^7")
                end
            end
        end
    end)

end

function DisplayMenu(menu)

    if not menu.topIndex then
    menu.topIndex = 1
end

    local x = 0.01
    local y = 0.15

    DrawRect(x + 0.12, y, 0.25, 0.05, 0, 0, 0, 200)
    DrawText(menu.title, x + 0.005, y - 0.015, 0.45, 0.45)

    y = y + 0.08

    for i = menu.topIndex, math.min(menu.topIndex + 8, #menu.items) do

    local item = menu.items[i]
    local iy = y + ((i - menu.topIndex) * 0.035)

        if i == menu.selected then
            DrawRect(x + 0.12, iy, 0.25, 0.03, 255, 100, 0, 200)
        else
            DrawRect(x + 0.12, iy, 0.25, 0.03, 0, 0, 0, 150)
        end

        DrawText(item.label, x + 0.005, iy - 0.01, 0.30, 0.30)
    end
end

function DrawText(text, x, y, sx, sy)
    SetTextFont(4)
    SetTextScale(sx, sy)
    SetTextColour(255,255,255,255)
    SetTextCentre(false)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end

function StopFollowLastPed()

    local ped = spawnedPeds[#spawnedPeds]

    if ped and DoesEntityExist(ped) then
        ClearPedTasks(ped)
        print("^3[AI-MENU] NPC Follow Stopped^7")
    end
end

function GuardLastPed()

    local ped = spawnedPeds[#spawnedPeds]

    if ped and DoesEntityExist(ped) then

        local coords = GetEntityCoords(ped)

        TaskStandGuard(
            ped,
            coords.x,
            coords.y,
            coords.z,
            GetEntityHeading(ped),
            "WORLD_HUMAN_GUARD_STAND",
            true
        )

        print("^2[AI-MENU] NPC Guarding Position^7")
    end
end

function DeleteLastPed()

    local ped = spawnedPeds[#spawnedPeds]

    if ped and DoesEntityExist(ped) then

        DeleteEntity(ped)

        table.remove(spawnedPeds, #spawnedPeds)

        print("^1[AI-MENU] NPC Deleted^7")
    end
end

function DeleteLastVehicle()

    local veh = spawnedVehicles[#spawnedVehicles]

    if veh and DoesEntityExist(veh) then

        DeleteEntity(veh)

        table.remove(spawnedVehicles, #spawnedVehicles)

        print("^1[AI-MENU] Vehicle Deleted^7")

    else

        print("^1[AI-MENU] No Vehicle Found^7")

    end
end

function AttackNearestPed()

    for _, ped in ipairs(spawnedPeds) do

    if DoesEntityExist(ped) then

        SetPedCombatAttributes(ped, 46, true)
        SetPedCombatAbility(ped, 2)
        SetPedCombatMovement(ped, 2)
        SetPedCombatRange(ped, 2)

        GiveWeaponToPed(
            ped,
            GetHashKey("WEAPON_PISTOL"),
            250,
            false,
            true
        )

        SetCurrentPedWeapon(
            ped,
            GetHashKey("WEAPON_PISTOL"),
            true
        )

        TaskCombatPed(
            ped,
            PlayerPedId(),
            0,
            16
        )

        print("^1[AI-MENU] Attack Started^7")
        end
    end
end   

function GoToWaypoint()

    local ped = spawnedPeds[#spawnedPeds]

    if not ped or not DoesEntityExist(ped) then
        return
    end

    local blip = GetFirstBlipInfoId(8)

    if DoesBlipExist(blip) then

        local coords = GetBlipInfoIdCoord(blip)

        TaskGoStraightToCoord(
            ped,
            coords.x,
            coords.y,
            coords.z,
            3.0,
            -1,
            0.0,
            0.0
        )

        print("^2[AI-MENU] Going To Waypoint^7")
    else
        print("^1[AI-MENU] No Waypoint Set^7")
    end
end

function GivePistolToLastPed()

    local ped = spawnedPeds[#spawnedPeds]

    if ped and DoesEntityExist(ped) then

        GiveWeaponToPed(
            ped,
            GetHashKey("WEAPON_PISTOL"),
            250,
            false,
            true
        )

        SetCurrentPedWeapon(
            ped,
            GetHashKey("WEAPON_PISTOL"),
            true
        )

        print("^2[AI-MENU] Pistol Given^7")
    end
end

function RemoveWeaponsFromLastPed()

    local ped = spawnedPeds[#spawnedPeds]

    if ped and DoesEntityExist(ped) then
        RemoveAllPedWeapons(ped, true)
        print("^1[AI-MENU] Weapons Removed^7")
    end
end

function EnterLastVehicle()

    local ped = spawnedPeds[#spawnedPeds]
    local veh = spawnedVehicles[#spawnedVehicles]

    if ped and veh and DoesEntityExist(ped) and DoesEntityExist(veh) then

        TaskEnterVehicle(
            ped,
            veh,
            -1,
            -1,
            2.0,
            1,
            0
        )

        print("^2[AI-MENU] NPC Entering Vehicle^7")
    end
end

function ExitVehicle()

    local ped = spawnedPeds[#spawnedPeds]

    if ped and DoesEntityExist(ped) then

        TaskLeaveVehicle(
            ped,
            GetVehiclePedIsIn(ped, false),
            0
        )

        print("^3[AI-MENU] NPC Exiting Vehicle^7")
    end
end

function DriveToWaypoint()

    local blip = GetFirstBlipInfoId(8)

    if not DoesBlipExist(blip) then
        print("^1[AI-MENU] No Waypoint Set^7")
        return
    end

    local coords = GetBlipInfoIdCoord(blip)

    for _, veh in ipairs(spawnedVehicles) do

        if DoesEntityExist(veh) then

            local ped = GetPedInVehicleSeat(veh, -1)

            if ped and ped ~= 0 then

                TaskVehicleDriveToCoord(
                    ped,
                    veh,
                    coords.x,
                    coords.y,
                    coords.z,
                    25.0,
                    0,
                    GetEntityModel(veh),
                    786603,
                    5.0,
                    true
                )
            end
        end
    end

    print("^2[AI-MENU] All Vehicles Driving To Waypoint^7")
end

function FrontPassengerSeat()

    local ped = spawnedPeds[#spawnedPeds]
    local veh = spawnedVehicles[#spawnedVehicles]

    if ped and veh and DoesEntityExist(ped) and DoesEntityExist(veh) then

          TaskEnterVehicle(
            ped,
            veh,
            -1,
             0,
             2.0,
             1,
             0
)

        print("^2[AI-MENU] NPC Entering Front Passenger Seat^7")
    end
end

function RearLeftSeat()

    local ped = spawnedPeds[#spawnedPeds]
    local veh = spawnedVehicles[#spawnedVehicles]

    if ped and veh and DoesEntityExist(ped) and DoesEntityExist(veh) then

        TaskEnterVehicle(
            ped,
            veh,
            -1,
            1,
            2.0,
            1,
            0
        )

        print("^2[AI-MENU] NPC Entering Rear Left Seat^7")
    end
end

function RearRightSeat()

    local ped = spawnedPeds[#spawnedPeds]
    local veh = spawnedVehicles[#spawnedVehicles]

    if ped and veh and DoesEntityExist(ped) and DoesEntityExist(veh) then

        TaskEnterVehicle(
            ped,
            veh,
            -1,
            2,
            2.0,
            1,
            0
        )

        print("^2[AI-MENU] NPC Entering Rear Right Seat^7")
    end
end

function AllNPCsEnterVehicle()

    local pedIndex = 1

    for _, veh in ipairs(spawnedVehicles) do

        if DoesEntityExist(veh) then

            local seats = {
                -1,
                0,
                1,
                2
            }

            for _, seat in ipairs(seats) do

                local ped = spawnedPeds[pedIndex]

                if ped and DoesEntityExist(ped) then

                    TaskEnterVehicle(
                        ped,
                        veh,
                        -1,
                        seat,
                        2.0,
                        1,
                        0
                    )

                    pedIndex = pedIndex + 1
                end
            end
        end
    end

    print("^2[AI-MENU] All NPCs Entering All Vehicles^7")
end

function DanceAllNPCs()

    for _, ped in ipairs(spawnedPeds) do

        if DoesEntityExist(ped) then

            ClearPedTasksImmediately(ped)

            TaskStartScenarioInPlace(
                ped,
                "WORLD_HUMAN_PARTYING",
                0,
                true
            )
        end
    end

    print("^2[AI-MENU] All NPCs Dancing^7")
end

function HandsUpAllNPCs()

    for _, ped in ipairs(spawnedPeds) do

        if DoesEntityExist(ped) then

            ClearPedTasksImmediately(ped)

            RequestAnimDict("missminuteman_1ig_2")

            while not HasAnimDictLoaded("missminuteman_1ig_2") do
                Wait(10)
            end

            TaskPlayAnim(
                ped,
                "missminuteman_1ig_2",
                "handsup_base",
                8.0,
                -8.0,
                -1,
                1,
                0,
                false,
                false,
                false
            )
        end
    end

    print("^2[AI-MENU] All NPCs Hands Up^7")
end

local convoyActive = false

function StartConvoy()

    local blip = GetFirstBlipInfoId(8)

    if not DoesBlipExist(blip) then
        print("^1[AI-MENU] No Waypoint Set^7")
        return
    end

    local coords = GetBlipInfoIdCoord(blip)

    convoyActive = true

    -- Leader Vehicle
    local leaderVeh = spawnedVehicles[1]

    if leaderVeh and DoesEntityExist(leaderVeh) then

        local leaderPed = GetPedInVehicleSeat(leaderVeh, -1)

        if leaderPed and leaderPed ~= 0 then

            TaskVehicleDriveToCoord(
                leaderPed,
                leaderVeh,
                coords.x,
                coords.y,
                coords.z,
                30.0,
                0,
                GetEntityModel(leaderVeh),
                786603,
                10.0,
                true
            )
        end
    end

    print("^2[AI-MENU] Convoy Started^7")
end

function DriveToWaypoint()

    local blip = GetFirstBlipInfoId(8)

    if not DoesBlipExist(blip) then
        print("^1[AI-MENU] No Waypoint Set^7")
        return
    end

    local coords = GetBlipInfoIdCoord(blip)

    convoyDestination = coords

    for _, veh in ipairs(spawnedVehicles) do

        if DoesEntityExist(veh) then

            local ped = GetPedInVehicleSeat(veh, -1)

            if ped and ped ~= 0 then

                ClearPedTasksImmediately(ped)

                TaskVehicleDriveToCoord(
                    ped,
                    veh,
                    coords.x,
                    coords.y,
                    coords.z,
                    35.0,
                    0,
                    GetEntityModel(veh),
                    786603,
                    10.0,
                    true
                )
            end
        end
    end

    print("^2[AI-MENU] All Vehicles Driving To Waypoint^7")
end

CreateThread(function()

    while true do
        Wait(2000)

        if convoyDestination then

            for _, veh in ipairs(spawnedVehicles) do

                if DoesEntityExist(veh) then

                    local vehCoords = GetEntityCoords(veh)

                    local dist = #(vehCoords - convoyDestination)

                    if dist < 20.0 then

                        local ped = GetPedInVehicleSeat(veh, -1)

                        if ped and ped ~= 0 then

                            TaskVehicleTempAction(
                                ped,
                                veh,
                                27,
                                3000
                            )

                            Wait(1000)

                            TaskLeaveVehicle(
                                ped,
                                veh,
                                0
                            )

                            local sidePos =
                                GetOffsetFromEntityInWorldCoords(
                                    veh,
                                    3.0,
                                    0.0,
                                    0.0
                                )

                            TaskGoStraightToCoord(
                                ped,
                                sidePos.x,
                                sidePos.y,
                                sidePos.z,
                                1.0,
                                -1,
                                0.0,
                                0.0
                            )
                        end
                    end
                end
            end

            convoyDestination = nil
        end
    end
end)

function TalkAllNPCs()

    if #spawnedPeds < 2 then
        return
    end

    local talkDict = "misscarsteal4@actor"
    local talkAnim = "actor_berating_loop"

    RequestAnimDict(talkDict)

    while not HasAnimDictLoaded(talkDict) do
        Wait(10)
    end

    CreateThread(function()

        while true do

            for i = 1, #spawnedPeds - 1, 2 do

                local ped1 = spawnedPeds[i]
                local ped2 = spawnedPeds[i + 1]

                if DoesEntityExist(ped1) and DoesEntityExist(ped2) then

                    TaskTurnPedToFaceEntity(ped1, ped2, 1000)
                    TaskTurnPedToFaceEntity(ped2, ped1, 1000)

                    Wait(1000)

                    -- Ped1 talks
                    TaskPlayAnim(
                        ped1,
                        talkDict,
                        talkAnim,
                        8.0,
                        -8.0,
                        4000,
                        1,
                        0,
                        false,
                        false,
                        false
                    )

                    TaskStandStill(
                        ped2,
                        4000
                    )

                    Wait(4500)

                    -- Ped2 talks
                    TaskPlayAnim(
                        ped2,
                        talkDict,
                        talkAnim,
                        8.0,
                        -8.0,
                        4000,
                        1,
                        0,
                        false,
                        false,
                        false
                    )

                    TaskStandStill(
                        ped1,
                        4000
                    )

                    Wait(4500)

                end
            end
        end
    end)

    print("^2[AI-MENU] NPC Conversation Started^7")
end

function AllNPCsExitVehicle()

    for _, ped in ipairs(spawnedPeds) do

        if DoesEntityExist(ped) then

            local veh = GetVehiclePedIsIn(ped, false)

            if veh ~= 0 then
                TaskLeaveVehicle(ped, veh, 0)
            end
        end
    end

    print("^2[AI-MENU] All NPCs Exiting Vehicles^7")
end

function FormationNPCs()

    local boss = spawnedPeds[1]

    if not boss or not DoesEntityExist(boss) then
        return
    end

    local bossCoords = GetEntityCoords(boss)
    local bossHeading = GetEntityHeading(boss)

    for i = 2, #spawnedPeds do

        local ped = spawnedPeds[i]

        if DoesEntityExist(ped) then

            local row = math.floor((i - 2) / 2)
            local side = ((i - 2) % 2 == 0) and -2.0 or 2.0

            local target = GetOffsetFromEntityInWorldCoords(
                boss,
                side,
                3.0 + (row * 2.0),
                0.0
            )

            TaskGoStraightToCoord(
                ped,
                target.x,
                target.y,
                target.z,
                1.0,
                -1,
                bossHeading,
                0.0
            )

            TaskTurnPedToFaceEntity(
                ped,
                boss,
                -1
            )
        end
    end

    print("^2[AI-MENU] Formation Created^7")
end

function SurroundBoss()

local boss = spawnedPeds[1]

if not boss or not DoesEntityExist(boss) then
    return
end

local bossUnderAttack = false

GiveWeaponToPed(
    boss,
    GetHashKey("WEAPON_CARBINERIFLE"),
    500,
    false,
    true
)

SetCurrentPedWeapon(
    boss,
    GetHashKey("WEAPON_CARBINERIFLE"),
    true
)

local radius = 4.0
local count = #spawnedPeds - 1

for i = 2, #spawnedPeds do

    local ped = spawnedPeds[i]

    if DoesEntityExist(ped) then

        ClearPedTasksImmediately(ped)

        GiveWeaponToPed(
            ped,
            GetHashKey("WEAPON_CARBINERIFLE"),
            500,
            false,
            true
        )

        SetCurrentPedWeapon(
            ped,
            GetHashKey("WEAPON_CARBINERIFLE"),
            true
        )

        local angle = ((i - 2) * (360.0 / count))
        local rad = math.rad(angle)

        local bossCoords = GetEntityCoords(boss)

        local x = bossCoords.x + math.cos(rad) * radius
        local y = bossCoords.y + math.sin(rad) * radius
        local z = bossCoords.z

        TaskGoStraightToCoord(
            ped,
            x,
            y,
            z,
            2.0,
            -1,
            0.0,
            0.0
        )

        SetPedCombatAttributes(ped, 46, true)
        SetPedCombatAttributes(ped, 5, true)
        SetPedCombatAbility(ped, 2)
        SetPedCombatMovement(ped, 2)
        SetPedCombatRange(ped, 2)

        CreateThread(function()

            Wait(4000)

            while DoesEntityExist(ped) and DoesEntityExist(boss) do

                if bossUnderAttack then
                    Wait(1000)
                else

                    local bCoords = GetEntityCoords(boss)

                    local patrolX = bCoords.x + math.random(-5, 5)
                    local patrolY = bCoords.y + math.random(-5, 5)

                    TaskGoToCoordAnyMeans(
                        ped,
                        patrolX,
                        patrolY,
                        bCoords.z,
                        1.0,
                        0,
                        0,
                        786603,
                        0.0
                    )

                    Wait(8000)
                end
            end
        end)
    end
end

CreateThread(function()

    while DoesEntityExist(boss) do

        Wait(250)

        if HasEntityBeenDamagedByAnyPed(boss) then

            bossUnderAttack = true

            for i = 2, #spawnedPeds do

                local ped = spawnedPeds[i]

                if DoesEntityExist(ped) then

                    ClearPedTasksImmediately(ped)

                    TaskCombatPed(
                        ped,
                        PlayerPedId(),
                        0,
                        16
                    )
                end
            end

            break
        end
    end
end)

print("^2[AI-MENU] Boss Protection Activated^7")

end

function MafiaMeeting()

    local mafiaBoss = spawnedPeds[1]
    local gangBoss = spawnedPeds[2]

    if not mafiaBoss or not gangBoss then
        return
    end

    if not DoesEntityExist(mafiaBoss) or not DoesEntityExist(gangBoss) then
        return
    end

    ClearPedTasksImmediately(mafiaBoss)
    ClearPedTasksImmediately(gangBoss)

    local bossCoords = GetEntityCoords(mafiaBoss)

    local meetPos = GetOffsetFromEntityInWorldCoords(
        mafiaBoss,
        0.0,
        2.0,
        0.0
    )

    TaskGoStraightToCoord(
        gangBoss,
        meetPos.x,
        meetPos.y,
        meetPos.z,
        1.0,
        -1,
        0.0,
        0.0
    )

    CreateThread(function()

        Wait(5000)

        TaskTurnPedToFaceEntity(
            mafiaBoss,
            gangBoss,
            -1
        )

        TaskTurnPedToFaceEntity(
            gangBoss,
            mafiaBoss,
            -1
        )

        while DoesEntityExist(mafiaBoss)
        and DoesEntityExist(gangBoss) do

            RequestAnimDict("missheistdockssetup1ig_5@base")

            while not HasAnimDictLoaded("missheistdockssetup1ig_5@base") do
                Wait(10)
            end

            TaskPlayAnim(
                mafiaBoss,
                "missheistdockssetup1ig_5@base",
                "workers_talking_base_dockworker1",
                8.0,
                -8.0,
                4000,
                1,
                0,
                false,
                false,
                false
            )

            Wait(4500)

            TaskPlayAnim(
                gangBoss,
                "missheistdockssetup1ig_5@base",
                "workers_talking_base_dockworker2",
                8.0,
                -8.0,
                4000,
                1,
                0,
                false,
                false,
                false
            )

            Wait(4500)
        end
    end)

    for i = 3, #spawnedPeds do

        local ped = spawnedPeds[i]

        if DoesEntityExist(ped) then

            GiveWeaponToPed(
                ped,
                GetHashKey("WEAPON_CARBINERIFLE"),
                500,
                false,
                true
            )

            SetCurrentPedWeapon(
                ped,
                GetHashKey("WEAPON_CARBINERIFLE"),
                true
            )

            local angle = ((i - 3) * 45)
            local rad = math.rad(angle)

            local x = bossCoords.x + math.cos(rad) * 6.0
            local y = bossCoords.y + math.sin(rad) * 6.0

            TaskGoStraightToCoord(
                ped,
                x,
                y,
                bossCoords.z,
                1.5,
                -1,
                0.0,
                0.0
            )
        end
    end

    print("^2[AI-MENU] Mafia Meeting Started^7")
end

function SpawnBoss()

    local modelName

    if not bossSpawnToggle then
        modelName = "g_m_m_armboss_01" -- Mafia Boss
        bossSpawnToggle = true
    else
        modelName = "g_m_y_ballasout_01" -- Gang Boss
        bossSpawnToggle = false
    end

    local model = GetHashKey(modelName)

    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(10)
    end

    local player = PlayerPedId()
    local coords = GetEntityCoords(player)

    local ped = CreatePed(
        4,
        model,
        coords.x + 2.0,
        coords.y + 2.0,
        coords.z,
        GetEntityHeading(player),
        true,
        true
    )

    SetEntityAsMissionEntity(ped, true, true)

    table.insert(spawnedPeds, ped)

    print("^2[AI-MENU] Boss Spawned: "..modelName.."^7")

    SetModelAsNoLongerNeeded(model)
end