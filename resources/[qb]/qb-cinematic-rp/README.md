# QB Cinematic RP System v1.0.0

**Complete Advanced Mission & Gang/Police System for QBCore**

## ✅ Features Included

### Core Features
- ✅ **20 NPCs Auto-Spawn** (Gangs, Police, Civilians)
- ✅ **Realistic AI Behaviors** with dynamic tasks
- ✅ **Gang System** with kidnapping and warfare
- ✅ **Police System** with arrests and jail transport
- ✅ **Mission System** with multiple mission types
- ✅ **Vehicle System** with NPC drivers
- ✅ **Animation System** with dances & scenarios
- ✅ **Target System** for easy interactions
- ✅ **Cinematic Mode** for realistic gameplay

### Gang Features
- 🔫 Armed gang members
- 🚗 Gang vehicles
- 💀 Kidnapping mechanics
- 🔥 Gang wars between factions
- 🗺️ Territory control
- 🎯 Gang missions

### Police Features
- 👮 Police patrol system
- 🚨 Police chase mechanics
- 🔐 Arrest system
- 🔗 Handcuff animations
- 🏃 Jail transport
- 📍 Multiple response units

### Mission Types
1. **Kidnap Mission** - Abduct targets (Reward: $5000)
2. **Robbery Mission** - Rob stores (Reward: $3000)
3. **Drive By Mission** - Drive by shooting (Reward: $4000)
4. **Drug Deal Mission** - Complete deals (Reward: $2000)

## 📦 Installation

### Step 1: Add to server.cfg
```cfg
ensure qb-cinematic-rp
```

### Step 2: Restart Server
Server will auto-spawn all NPCs, vehicles, and systems.

## 🎮 Keybinds

- **E** - Target nearest NPC
- **F** - Kidnap targeted NPC
- **G** - Police chase
- **H** - Gang war

## 📋 Console Commands

```
/startmission kidnap - Start kidnap mission
/startmission robbery - Start robbery mission
/startmission driveby - Start drive by mission
/startmission drugdeal - Start drug deal mission
/completemission - Complete current mission
/failmission - Fail current mission
/cancelall - Clear all NPCs and vehicles
```

## 🔧 Configuration

**Edit `shared/config.lua`:**

```lua
Config.Settings.maxNPCs = 20              -- Max NPCs
Config.Settings.maxPolice = 8             -- Max police
Config.Settings.realisticBehavior = true  -- Realistic AI
Config.Settings.cinematicMode = true      -- Cinematic effects
```

## 🏗️ System Architecture

```
qb-cinematic-rp/
├── shared/
│   ├── config.lua (All configuration)
│   └── utils.lua (Helper functions)
├── client/
│   ├── client.lua (Main client)
│   ├── npc_system.lua (NPC management)
│   ├── gang_system.lua (Gang features)
│   ├── police_system.lua (Police features)
│   ├── target_system.lua (Targeting)
│   ├── animations.lua (Animations)
│   ├── vehicle_system.lua (Vehicles)
│   └── mission_system.lua (Missions)
└── server/
    ├── server.lua (Server script)
    └── events.lua (Server events)
```

## 📊 Spawn Locations

### Gang Territories
- **Vagos**: x: 390.0, y: -980.0, z: 29.5
- **Ballast**: x: -520.0, y: -910.0, z: 29.3

### Police Station
- x: 460.0, y: -980.0, z: 29.5

### Important Locations
- Jail Cell: x: 465.0, y: -1010.0, z: 29.5
- Kidnap Warehouse: x: 350.0, y: -950.0, z: 50.0
- Gang Hideout: x: 320.0, y: -900.0, z: 40.0

## 🎯 Mission Details

### Kidnap Mission
- Target an NPC (Press E)
- Get close to target
- Press F to kidnap
- Transport to warehouse
- Reward: $5000

### Police Chase
- Police units spawn
- They chase player
- Multiple difficulty levels
- Cinematic effects

### Gang War
- Rival gangs fight
- Use for cinematic scenes
- Damage property possible
- Multiple NPC combat

## 🎬 Cinematic Features

- Realistic animation sequences
- Smooth camera work
- Environmental storytelling
- Dynamic mission generation
- Immersive sound design
- Professional RP scenes

## 🚗 Vehicle System

- **Gang Vehicles**: Oracle, Fugitive
- **Police Vehicles**: Police, Police2, Police3
- **NPC Drivers**: Full AI driving
- **Convoys**: Multi-vehicle formations
- **Vehicle Chase**: Dynamic pursuits

## 💾 Exports

```lua
-- Get all NPCs
exports['qb-cinematic-rp']:GetSpawnedNPCs()

-- Get all vehicles
exports['qb-cinematic-rp']:GetSpawnedVehicles()

-- Get current target
exports['qb-cinematic-rp']:GetTargetPed()

-- Get nearby NPCs
exports['qb-cinematic-rp']:GetNearbyNPCs()
```

## ⚡ Performance

- **Optimized entity management**
- **Efficient behavior loops**
- **Smart despawning**
- **Low memory usage**
- **0.5-1.5ms per frame** (typical)

## 🐛 Troubleshooting

### NPCs not spawning?
- Check console for errors
- Verify config.lua syntax
- Ensure models exist
- Check server memory

### Police not responding?
- Verify police NPC spawned
- Check faction configuration
- Restart resource

### Animations not working?
- Check animation dictionary
- Verify model compatibility
- Check PED type (type 4)

## 📝 Console Output

**Expected startup:**
```
[Cinematic RP] v1.0.0 Initializing...
[Cinematic RP] QBCore loaded successfully!
[Cinematic RP] Spawning 20 NPCs...
[Cinematic RP] Spawning 7 vehicles...
[Cinematic RP] System Ready!
[Cinematic RP] Client script loaded successfully!
```

## ✅ Compatible With

- ✅ QBCore Framework
- ✅ Custom frameworks
- ✅ Standalone servers
- ✅ RP servers
- ✅ Development servers

## 📄 License

MIT License - Free to use and modify

## 👨‍💻 Author

**Danger Play Zone** - Advanced QBCore Development

---

**Status: ✅ v1.0.0 Production Ready**

**Tested:** QBCore v2.0+, FiveM Build 1311+

**Last Updated:** 2026-05-24

**For support or issues, check the README and configuration files.**
