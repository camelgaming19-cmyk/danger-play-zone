-- ============================================
-- CINEMATIC RP - Animation System
-- ============================================

-- Play dance animation
function PlayDanceAnimation(ped)
    if not DoesEntityExist(ped) then return end
    
    local dance = Utils.RandomTable(Config.Animations.dances)
    RequestAnimDict(dance.dict)
    
    while not HasAnimDictLoaded(dance.dict) do
        Wait(100)
    end
    
    TaskPlayAnim(ped, dance.dict, dance.anim, 8.0, -8.0, -1, 1, 0, false, false, false)
end

-- Play scenario
function PlayScenarioAnimation(ped, scenario)
    if not DoesEntityExist(ped) then return end
    
    TaskStartScenarioInPlace(ped, scenario, 0, true)
end

-- Play combat animation
function PlayCombatAnimation(ped)
    if not DoesEntityExist(ped) then return end
    
    local combat = Utils.RandomTable(Config.Animations.combat)
    RequestAnimDict(combat.dict)
    
    while not HasAnimDictLoaded(combat.dict) do
        Wait(100)
    end
    
    TaskPlayAnim(ped, combat.dict, combat.anim, 8.0, -8.0, 3000, 1, 0, false, false, false)
end

-- Play arrest animation
function PlayArrestAnimation(ped)
    if not DoesEntityExist(ped) then return end
    
    local arrest = Utils.RandomTable(Config.Animations.arrest)
    RequestAnimDict(arrest.dict)
    
    while not HasAnimDictLoaded(arrest.dict) do
        Wait(100)
    end
    
    TaskPlayAnim(ped, arrest.dict, arrest.anim, 8.0, -8.0, 5000, 1, 0, false, false, false)
end

-- Play kidnap animation
function PlayKidnapAnimation(ped)
    if not DoesEntityExist(ped) then return end
    
    local kidnap = Utils.RandomTable(Config.Animations.kidnap)
    RequestAnimDict(kidnap.dict)
    
    while not HasAnimDictLoaded(kidnap.dict) do
        Wait(100)
    end
    
    TaskPlayAnim(ped, kidnap.dict, kidnap.anim, 8.0, -8.0, 3000, 1, 0, false, false, false)
end

-- Stop animation
function StopAnimation(ped)
    if not DoesEntityExist(ped) then return end
    
    ClearPedTasks(ped)
end

-- Make NPC dance
function MakeNPCDance(npcData)
    if not DoesEntityExist(npcData.entity) then return end
    
    PlayDanceAnimation(npcData.entity)
    Utils.Notify('Animation', '💃 NPC is dancing!', 'success')
end

-- Make all NPCs dance
function MakeAllNPCsDance()
    for _, npcData in ipairs(spawnedNPCs) do
        if DoesEntityExist(npcData.entity) then
            PlayDanceAnimation(npcData.entity)
            Wait(200)
        end
    end
    Utils.Notify('Animation', '💃 All NPCs dancing!', 'success')
end

-- Make NPC scenario
function MakeNPCScenario(npcData, scenario)
    if not DoesEntityExist(npcData.entity) then return end
    
    PlayScenarioAnimation(npcData.entity, scenario)
end

print("^2[Cinematic RP] Animation System loaded!^7")
