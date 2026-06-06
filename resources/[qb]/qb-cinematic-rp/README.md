# QB Cinematic RP

Advanced cinematic RP system for FiveM with qb-target integration. Provides a scene director, NPC spawning & management, chair/object interactions, and simple action handlers for cuffing, seating, and combat-like interactions.

This README explains setup, usage, commands, events, exports, and troubleshooting for the `qb-cinematic-rp` resource.

---

## Features

- Scene director with in-game `/scene` command to script simple scenes.
- NPC spawning with roles/factions (gang, police, civilian, etc).
- Chair creation and NPC/player seating scenarios.
- qb-target integration: NPCs and chairs become targetable with Inspect/Cuff/Sit/Punch/Stand actions.
- Client-side action handlers (Seat, Cuff, Punch) with optional exports for other scripts.
- Exports and events so other resources can register entities or trigger cinematic actions.

---

## Requirements

- FiveM server
- qb-target (recommended) — ensure `qb-target` is started before this resource for target registration to work.
- QBCore (optional) — used only for Utils.Notify if available; scripts fall back to console prints when missing.

---

## Installation

1. Place the resource folder at: `resources/[qb]/qb-cinematic-rp/`
2. Ensure `qb-target` is started before `qb-cinematic-rp` in your `server.cfg`:

```
ensure qb-target
ensure qb-cinematic-rp
```

3. Start/restart your server.

---

## Usage (Scene Director)

The resource provides a client-side `/scene` command to control simple scene flows. Example commands (in-game chat):

- Start a scene
  /scene start

- Spawn NPC(s)
  /scene spawn npc <faction> <count>
  Example: `/scene spawn npc gang 5`

- Create a chair at your position
  /scene chair create

- Seat an NPC on a chair
  /scene sit npc <npcIndex> chair <chairIndex>
  Example: `/scene sit npc 1 chair 1`

- Cuff an NPC
  /scene cuff npc <npcIndex>

- Have one NPC punch another
  /scene punch npc <attackerIndex> npc <targetIndex>

- End scene and cleanup
  /scene end

Notes:
- NPC and chair indices are assigned in spawn/create order starting at 1.
- Scene commands are implemented client-side for rapid prototyping. Move critical actions to server-side events for authoritative behavior.

---

## qb-target Integration

When qb-target is available the resource registers:

- NPC entities: Options include Inspect, Cuff, Seat NPC, Punch, Stand/Remove.
- Chair models: Player "Sit" option for sitting on chairs.

The integration passes `data.entity` from qb-target to client event handlers so handlers receive the exact targeted entity.

---

## Client Events

These client events are provided (trigger them with `TriggerEvent`):

- `cinematic:client:npcSpawned(npcData)` — fired when the scene director spawns an NPC (contains `entity`, `faction`, `role`, `index`).
- `cinematic:client:npcDespawned(npcData)` — fired before NPC deletion.
- `cinematic:client:requestCuff(entity)` — cuff (freeze/block) the ped (client-side).
- `cinematic:client:seatNPC(entity)` — seat NPC at nearest chair.
- `cinematic:client:requestPunch(entity)` — trigger punch behavior against entity.
- `cinematic:client:playerSitOnChair(data)` — called when player uses qb-target Sit on a chair (data.entity = chair).

qb-target specific handlers (receive qb-target's `data` table with `data.entity`):
- `cinematic:client:inspectTarget`
- `cinematic:client:cuffTarget`
- `cinematic:client:seatTarget`
- `cinematic:client:punchTarget`
- `cinematic:client:standTarget`

---

## Exports

Exports are available for other client scripts to register entities or call helpers (example names):

- `RegisterNPCWithQbTarget(npcData)` — register an NPC entity with qb-target (npcData should include `.entity`, `.faction`, `.canSit`, etc).
- `UnregisterNPCFromQbTarget(entity)` — unregister entity.
- `RegisterAllSpawnedNPCs()` — scan global `spawnedNPCs` table and register entities.
- `SeatNPCOnNearestChair(entity)` — seat the given NPC.
- `UnseatNPC(entity)` — unseat the NPC.
- `CuffPed(entity)` — cuff ped.
- `UncuffPed(entity)` — uncuff ped.
- `PunchNPC(entity)` — apply punch behavior/damage.

Usage example:

```lua
exports['qb-cinematic-rp']:RegisterNPCWithQbTarget({ entity = ped, faction = 'gang', canSit = true })
```

---

## Configuration

Default settings use `shared/config.lua` in the resource. You can configure NPC models, spawn limits, weapons, locations, and mission definitions there.

---

## Troubleshooting

- "Couldn't find resource qb-cinematic-rp." — Ensure the folder name matches exactly and `fxmanifest.lua` exists at the resource root. The resource name in `server.cfg` must match the folder name.
- qb-target options not appearing — Make sure `qb-target` is started before this resource (`ensure qb-target` before `ensure qb-cinematic-rp`).
- Actions not working on NPCs — Confirm NPCs are registered via the global `spawnedNPCs` table or use the `RegisterNPCWithQbTarget` export.
- Want authoritative server behavior? Move sensitive logic (cuffing, damage, deleting entities) to server-side events and validate permissions.

---

## Extending

- Add role-based behavior (gangster, victim, boss, guard) by supplying `role` in `npcData` and adjusting handlers.
- Add server-side handlers for syncing cuff/punch state and for permission checks.
- Register additional chair models or scene objects in the qb-target registration.

---

## License

MIT — free to use and modify. Include attribution if redistributing.
