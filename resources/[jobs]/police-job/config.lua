Config = {}

-- Police Station Location
Config.PoliceDutyLocation = {
    coords = vector3(425.5, -986.5, 29.4),
    heading = 0.0,
    radius = 2.0
}

-- Police Station Wardrobe
Config.PoliceWardrobe = {
    coords = vector3(425.5, -986.5, 29.4),
    heading = 0.0,
    radius = 2.0
}

-- Jail Location
Config.JailLocation = {
    coords = vector3(461.5, -988.5, 25.7),
    heading = 0.0
}

-- Salary Config
Config.Salary = {
    minimum = 30000,
    maximum = 35000,
    bonusPerHour = 1500,
    dutyBonus = 10000  -- Bonus for completing duty shift
}

-- Police Uniforms
Config.Uniforms = {
    duty = {
        male = {
            torso_1 = 98, torso_2 = 0,
            tshirt_1 = 15, tshirt_2 = 0,
            decals_1 = 0, decals_2 = 0,
            arms = 10, arms_2 = 0,
            pants_1 = 32, pants_2 = 0,
            shoes_1 = 25, shoes_2 = 0,
            mask_1 = 0, mask_2 = 0,
            bproof_1 = 14, bproof_2 = 1,
            chain_1 = 0, chain_2 = 0,
            helmet_1 = -1, helmet_2 = 0,
            glasses_1 = 0, glasses_2 = 0,
            watch_1 = -1, watch_2 = 0,
            bracelets_1 = -1, bracelets_2 = 0,
            bag_1 = 0, bag_2 = 0
        },
        female = {
            torso_1 = 98, torso_2 = 1,
            tshirt_1 = 15, tshirt_2 = 0,
            decals_1 = 0, decals_2 = 0,
            arms = 14, arms_2 = 0,
            pants_1 = 32, pants_2 = 0,
            shoes_1 = 25, shoes_2 = 0,
            mask_1 = 0, mask_2 = 0,
            bproof_1 = 14, bproof_2 = 1,
            chain_1 = 0, chain_2 = 0,
            helmet_1 = -1, helmet_2 = 0,
            glasses_1 = 0, glasses_2 = 0,
            watch_1 = -1, watch_2 = 0,
            bracelets_1 = -1, bracelets_2 = 0,
            bag_1 = 0, bag_2 = 0
        }
    }
}

-- Arrest Fine Amounts
Config.ArrestFines = {
    assault = 5000,
    theft = 8000,
    drug_dealing = 15000,
    reckless_driving = 3000,
    fleeing_police = 10000,
    trespassing = 2000
}

-- Jail Time (in minutes)
Config.JailTime = {
    assault = 10,
    theft = 15,
    drug_dealing = 30,
    reckless_driving = 5,
    fleeing_police = 20,
    trespassing = 5
}

-- Weapons on Duty
Config.DutyWeapons = {
    'weapon_pistol',
    'weapon_flashlight',
    'weapon_nightstick'
}

-- Blip Config
Config.Blip = {
    sprite = 227,
    display = 4,
    scale = 0.7,
    color = 3
}
