-- ============================================
-- CINEMATIC RP SYSTEM - Shared Configuration
-- Complete Gang, Police & Mission System
-- ============================================

Config = {}

-- ==================== CORE SETTINGS ====================
Config.Settings = {
    debugMode = false,
    maxNPCs = 20,
    maxPolice = 8,
    maxGangMembers = 12,
    spawnRadius = 200.0,
    despawnDistance = 300.0,
    updateInterval = 100,
    realisticBehavior = true,
    cinematicMode = true,
}

-- ==================== NPC SPAWN LOCATIONS ====================
Config.NPCSpawns = {
    -- Gang Territory 1 (Vagos)
    {x = 380.5, y = -980.2, z = 29.5, heading = 180.0, faction = 'gang', gang = 'vagos', type = 'member', armed = true},
    {x = 390.2, y = -975.8, z = 29.5, heading = 180.0, faction = 'gang', gang = 'vagos', type = 'member', armed = true},
    {x = 400.8, y = -982.5, z = 29.5, heading = 180.0, faction = 'gang', gang = 'vagos', type = 'leader', armed = true},
    {x = 370.1, y = -990.3, z = 29.5, heading = 180.0, faction = 'gang', gang = 'vagos', type = 'member', armed = false},
    {x = 410.5, y = -970.8, z = 29.5, heading = 180.0, faction = 'gang', gang = 'vagos', type = 'member', armed = true},
    {x = 420.2, y = -985.2, z = 29.5, heading = 180.0, faction = 'gang', gang = 'vagos', type = 'member', armed = false},
    
    -- Gang Territory 2 (Ballast)
    {x = -520.5, y = -900.8, z = 29.3, heading = 90.0, faction = 'gang', gang = 'ballast', type = 'member', armed = true},
    {x = -510.2, y = -910.5, z = 29.3, heading = 90.0, faction = 'gang', gang = 'ballast', type = 'leader', armed = true},
    {x = -530.8, y = -920.2, z = 29.3, heading = 90.0, faction = 'gang', gang = 'ballast', type = 'member', armed = true},
    {x = -540.5, y = -905.8, z = 29.3, heading = 90.0, faction = 'gang', gang = 'ballast', type = 'member', armed = false},
    
    -- Police Station Spawns
    {x = 450.8, y = -980.5, z = 29.5, heading = 0.0, faction = 'police', job = 'police', rank = 'officer', armed = true},
    {x = 460.2, y = -975.8, z = 29.5, heading = 0.0, faction = 'police', job = 'police', rank = 'officer', armed = true},
    {x = 470.5, y = -985.2, z = 29.5, heading = 0.0, faction = 'police', job = 'police', rank = 'sergeant', armed = true},
    {x = 440.2, y = -990.8, z = 29.5, heading = 0.0, faction = 'police', job = 'police', rank = 'officer', armed = true},
    {x = 480.8, y = -970.5, z = 29.5, heading = 0.0, faction = 'police', job = 'police', rank = 'officer', armed = true},
    
    -- Civilian Spawns
    {x = 300.5, y = -850.2, z = 29.5, heading = 45.0, faction = 'civilian', type = 'civilian', armed = false},
    {x = 310.2, y = -860.5, z = 29.5, heading = 45.0, faction = 'civilian', type = 'civilian', armed = false},
    {x = 320.8, y = -870.2, z = 29.5, heading = 45.0, faction = 'civilian', type = 'civilian', armed = false},
}

-- ==================== VEHICLE SPAWNS ====================
Config.VehicleSpawns = {
    -- Gang Vehicles
    {x = 385.5, y = -1005.8, z = 29.4, heading = 180.0, model = 'oracle', faction = 'gang', gang = 'vagos'},
    {x = 395.2, y = -1000.2, z = 29.4, heading = 180.0, model = 'oracle', faction = 'gang', gang = 'vagos'},
    {x = -525.5, y = -930.2, z = 29.3, heading = 90.0, model = 'oracle', faction = 'gang', gang = 'ballast'},
    {x = -515.2, y = -925.8, z = 29.3, heading = 90.0, model = 'oracle', faction = 'gang', gang = 'ballast'},
    
    -- Police Vehicles
    {x = 455.5, y = -1000.8, z = 29.5, heading = 0.0, model = 'police', faction = 'police', job = 'police'},
    {x = 465.2, y = -1005.2, z = 29.5, heading = 0.0, model = 'police', faction = 'police', job = 'police'},
    {x = 475.8, y = -1010.5, z = 29.5, heading = 0.0, model = 'police', faction = 'police', job = 'police'},
}

-- ==================== IMPORTANT LOCATIONS ====================
Config.Locations = {
    vagos_territory = {x = 390.0, y = -980.0, z = 29.5, heading = 180.0},
    ballast_territory = {x = -520.0, y = -910.0, z = 29.3, heading = 90.0},
    police_station = {x = 460.0, y = -980.0, z = 29.5, heading = 0.0},
    jail_cell = {x = 465.0, y = -1010.0, z = 29.5, heading = 180.0},
    hospital = {x = 300.0, y = -600.0, z = 43.3, heading = 0.0},
    kidnap_warehouse = {x = 350.0, y = -950.0, z = 50.0, heading = 180.0},
    gang_hideout = {x = 320.0, y = -900.0, z = 40.0, heading = 180.0},
}

-- ==================== NPC MODELS ====================
Config.NPCModels = {
    'a_m_m_business_01',
    'a_m_m_business_02',
    'a_m_m_business_03',
    'a_m_m_business_04',
    'a_f_m_business_02',
    'a_m_m_security_01',
    'a_m_m_security_02',
    'a_f_y_business_01',
}

-- ==================== ANIMATIONS ====================
Config.Animations = {
    dances = {
        {dict = 'dancing', anim = 'dancing_loop_a', name = 'Dance 1'},
        {dict = 'dancing', anim = 'dancing_loop_b', name = 'Dance 2'},
        {dict = 'dancing', anim = 'dancing_loop_c', name = 'Dance 3'},
        {dict = 'dancing', anim = 'dancing_loop_d', name = 'Dance 4'},
    },
    scenarios = {
        'WORLD_HUMAN_STUPOR',
        'WORLD_HUMAN_SMOKING',
        'WORLD_HUMAN_DRINKING',
        'WORLD_HUMAN_MOBILE_FILM_SHOCKING',
        'WORLD_HUMAN_MOBILE_SWIPE',
        'WORLD_HUMAN_LEANING',
    },
    combat = {
        {dict = 'combat@damage@rb_writhe', anim = 'rb_writhe_loop'},
        {dict = 'nonmission@rowdy', anim = 'kid_throw_person'},
        {dict = 'nonmission_rowdy', anim = 'kid_kick_floor'},
    },
    arrest = {
        {dict = 'move_m@_armed', anim = 'idle'},
        {dict = 'nonmission_rowdy', anim = 'kid_throw_person'},
    },
    kidnap = {
        {dict = 'nonmission_rowdy', anim = 'kid_throw_person'},
        {dict = 'combat@damage@rb_writhe', anim = 'rb_writhe_loop'},
    },
}

-- ==================== WEAPONS ====================
Config.Weapons = {
    'weapon_pistol',
    'weapon_combatpistol',
    'weapon_appistol',
    'weapon_smg',
    'weapon_assaultrifle',
}

-- ==================== MISSION TYPES ====================
Config.Missions = {
    kidnap = {
        name = 'Kidnapping Mission',
        description = 'Kidnap a target and transport to location',
        reward = 5000,
        difficulty = 'hard',
    },
    robbery = {
        name = 'Store Robbery',
        description = 'Rob a store with gang members',
        reward = 3000,
        difficulty = 'medium',
    },
    drive_by = {
        name = 'Drive By',
        description = 'Drive by shooting',
        reward = 4000,
        difficulty = 'hard',
    },
    drug_deal = {
        name = 'Drug Deal',
        description = 'Conduct a drug deal',
        reward = 2000,
        difficulty = 'easy',
    },
}

-- ==================== GANG CONFIG ====================
Config.Gangs = {
    vagos = {
        name = 'Vagos',
        color = {255, 200, 0},
        territory = {x = 390.0, y = -980.0, z = 29.5},
        mainWeapon = 'weapon_pistol',
        vehicles = {'oracle', 'fugitive'},
    },
    ballast = {
        name = 'Ballast',
        color = {0, 100, 200},
        territory = {x = -520.0, y = -910.0, z = 29.3},
        mainWeapon = 'weapon_pistol',
        vehicles = {'oracle', 'fugitive'},
    },
}

-- ==================== POLICE CONFIG ====================
Config.Police = {
    precinct = {
        name = 'Police Department',
        location = {x = 460.0, y = -980.0, z = 29.5},
        mainWeapon = 'weapon_combatpistol',
        vehicles = {'police', 'police2', 'police3'},
    },
}

print("^2[Cinematic RP] Config loaded successfully!^7")
