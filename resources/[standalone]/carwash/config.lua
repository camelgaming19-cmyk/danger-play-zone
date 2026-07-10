Config = {}

-- Car Wash Locations
Config.CarWashLocations = {
    {
        name = 'Downtown Car Wash',
        coords = vector3(25.45, -1391.69, 29.5),
        heading = 0.0,
        radius = 15.0,
        npcCoords = vector3(25.45, -1391.69, 29.5),
        npcHeading = 0.0,
        npcModel = 'a_m_m_business_1'
    },
    {
        name = 'Airport Car Wash',
        coords = vector3(-1200.5, -1564.2, 4.6),
        heading = 0.0,
        radius = 15.0,
        npcCoords = vector3(-1200.5, -1564.2, 4.6),
        npcHeading = 0.0,
        npcModel = 'a_m_m_business_1'
    },
    {
        name = 'Pillbox Car Wash',
        coords = vector3(158.42, -1754.33, 26.7),
        heading = 0.0,
        radius = 15.0,
        npcCoords = vector3(158.42, -1754.33, 26.7),
        npcHeading = 0.0,
        npcModel = 'a_m_m_business_1'
    }
}

-- Car Wash Price
Config.WashPrice = 50

-- Car Wash Duration (seconds)
Config.WashDuration = 30

-- Blip Config
Config.Blip = {
    sprite = 100,
    display = 4,
    scale = 0.7,
    color = 3
}

-- NPC Config
Config.NPCAnimDict = 'anim@amb@clubhouse@interior@ba_lounge@bunks@base'
Config.NPCAnimName = 'ba_lounge_s_player_sleeping'

-- Cleaning Animations
Config.CleaningAnims = {
    dict = 'move_cleaning',
    anims = {'walk_0', 'walk_1', 'idle'}
}

-- Water Effects
Config.WaterEffects = {
    model = 'spl_water_splash_01_water',
    scale = 1.0
}

-- Motor Sound
Config.MotorSound = 'CONFIRM_BEEP',
Config.MotorSoundBank = 'CONFIRM_BEEPS'

-- Vehicle Condition Increase
Config.CleanConditionIncrease = 100
