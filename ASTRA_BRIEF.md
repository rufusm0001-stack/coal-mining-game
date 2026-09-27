# Coal Mining Game — Full Brief (for GPT "Astra")

This is a combined copy of the 4 project docs (CLAUDE.md, GAME_SPEC.md, TASKS.md,
STATUS.md) from the coal-mining-game repo, for pasting into or uploading as Knowledge
to a custom GPT. If you update the originals later, regenerate this file — it does
not stay in sync automatically.

---

# 1. CLAUDE.md — Project Instructions

This file is loaded automatically by Claude Code at the start of every session run
from this folder (or a subfolder of it). Both of you should launch Claude Code with
this folder as your project directory so your Claude and your brother's Claude both
see the same rules without either of you re-pasting anything.

**Every session, before doing anything else: read TASKS.md and STATUS.md.**
They tell you who owns what part of the game right now and what changed since you
were last online. See GAME_SPEC.md for the original full design brief this is based on.

## Studio access (no Rojo, no Git for game code)

This project is built directly in Roblox Studio via the Studio MCP tools
(`execute_luau`, `multi_edit`, `script_read`, `script_grep`, `search_game_tree`,
`insert_asset`, etc). Both developers work on the SAME live place via Roblox
**Team Create** — there is no file sync step and no merge step, so read TASKS.md's
conflict rules before editing anything, especially shared Instances.

## Game Vision & Theme

- Title / Theme: Mineshaft Search Game — a viral, hyper-casual search-and-mine game
  for studio "Ctrl+C Games", inspired by the completionist loops of "Find the Needle"
  and "Where Did I Park?".
- Aesthetic: underground mineshaft — wooden support pillars, overhead minecart rails,
  lava pits, dark rock caverns.

**HARD CONSTRAINT: Do NOT write code to build or generate the physical map or visual
environment (walls, lava, pillars, terrain). The human developers build the map
manually in Roblox Studio.** Focus exclusively on: backend scripts, system math, data
saving, client UI, tool logic, RemoteEvents, and automation systems.

## Core Mechanics & Numbers

- World pool: ~2,000 active physical resource nodes scaling to represent a total
  collectible pool of ~1,000,000 Coal.
- Node types & rarities:
  - Standard Coal Nodes — large, common, base yield.
  - Gold Coal Nodes — smaller mesh, higher cash/coal yield.
  - Rainbow Coal Nodes — ultra-rare, high payout, special particle effects.
- Tool progression: 10 pickaxe tiers (Stone -> Iron -> Gold -> Diamond -> Plasma/Laser).
  3D models are generated externally via Meshy AI — not something the AI generates.
- Equipment stats:
  - Yield Multiplier (e.g. +1 Coal vs +50 Coal per swing).
  - Swing Speed Multiplier (reduces swing cooldown/animation speed).
  - Walk Speed Multiplier (player movement across the mineshaft).

## Visual Effects, Animations & Dynamic UI

- Tool swing: clicking a node triggers a client-side swing animation, a pickaxe
  impact SFX, and hit particles spawned at the Raycast hit position.
- Floating pop-up text: on striking a node, spawn brief world-space UI text at the
  hit position reading "+[Amount] [Coal Icon]" (e.g. "+2 [Coal]"), drifting upward
  and fading out over 0.8 seconds.
- Persistent HUD:
  - Mined progress counter (e.g. "452,100 / 1,000,000 Coal Collected").
  - Cash balance & inventory capacity UI.
- Sell area & shop UI:
  - Sell Zone: a physical prompt/hopper in the hub converting collected coal to Cash.
  - Upgrade Menu: clean, modern card-style UI (a la "Find the Needle" / "Where Did I
    Park?") for purchasing pickaxe tiers, swing speed, walk speed, and automation
    helpers.

## Automation Hooks (late-game retention)

Passive helpers that mine nodes without manual clicking:
1. Robotic Excavators — stationary drills mounted to mine walls.
2. Mining Drones — hovering pets that auto-target nearby nodes.
3. Minecarts / Conveyors — automatic transportation lines for mined coal.

## Architecture — shared names (use exactly as written)

These are the contract between both people's systems. A rename here silently breaks
the other person's scripts — don't rename without updating STATUS.md and telling the
other person first.

RemoteEvents (ReplicatedStorage):
- `MineNodeEvent`
- `SellCoalEvent`
- `BuyUpgradeEvent`
- `UpdateHUDEvent`

ModuleScripts (ReplicatedStorage.Modules):
- `PickaxeData` — names, costs, multipliers
- `UpgradeData` — prices, caps
- `AutomationData`

## Workflow rules

- Read TASKS.md and STATUS.md before editing anything.
- Only touch Instance paths inside your own lane (see TASKS.md's ownership split).
- Before finishing a session, log what you changed in STATUS.md — especially
  anything touching the shared RemoteEvents/ModuleScripts above.

---

# 2. GAME_SPEC.md — Original Design Brief (verbatim)

You are acting as an expert Roblox Luau game developer and systems architect working
on a viral, hyper-casual search-and-mine game for our studio "Ctrl+C Games".

## GAME VISION & THEME

- Title / Theme: Mineshaft Search Game (inspired by the viral completionist loops of
  "Find the Needle" and "Where Did I Park?").
- Aesthetic Environment: Underground mineshaft with wooden support pillars, overhead
  minecart rails, lava pits, and dark rock caverns.
- HARD CONSTRAINT: DO NOT write code to build or generate the physical map or visual
  environment (walls, lava, pillars). The human developers will build the map
  manually in Roblox Studio. Focus EXCLUSIVELY on backend scripts, system math, data
  saving, client UI, tool logic, RemoteEvents, and automation systems.

## CORE MECHANICS & NUMBERS

1. World Pool: The mine contains ~2,000 active physical resource nodes that scale to
   represent a total collectible pool of ~1,000,000 Coal.
2. Node Types & Rarities:
   - Standard Coal Nodes (large, common, base yield).
   - Gold Coal Nodes (smaller mesh size, higher cash/coal yield).
   - Rainbow Coal Nodes (ultra-rare, high payout, special particle effects).
3. Tool Progression & Pickaxes:
   - 10 Pickaxe Tiers (Stone Pickaxe -> Iron -> Gold -> Diamond -> Plasma/Laser
     Pickaxes). 3D models are generated via Meshy AI.
   - Equipment Stats:
     - Yield Multiplier (e.g., +1 Coal vs +50 Coal per swing).
     - Swing Speed Multiplier (reduces swing cooldown/animation speed).
     - Walk Speed Multiplier (player movement across the mineshaft).

## VISUAL EFFECTS, ANIMATIONS & DYNAMIC UI

1. Tool Swing Mechanics: When a player clicks a node, trigger a client-side swing
   animation, play a pickaxe impact SFX, and spawn hit particles at the Raycast hit
   position.
2. World-Space Floating Text (Pop-Up UI): Upon striking a node, spawn a brief
   floating UI text at the hit position displaying "+[Amount] [Coal Icon]" (e.g.,
   "+2 [Coal]"). The text drifts upward and fades out over 0.8 seconds.
3. Persistent HUD UI:
   - Mined Progress Counter: A clean UI bar/text showing total coal collected out of
     the target (e.g., "452,100 / 1,000,000 Coal Collected").
   - Cash Balance & Inventory Capacity UI.
4. Sell Area & Shop UI:
   - Sell Zone: A designated physical prompt/hopper in the hub that converts
     collected coal into Cash.
   - Upgrade Menu: Clean, modern card-style UI (inspired by "Find the Needle" and
     "Where Did I Park?") for purchasing Pickaxe tiers, Swing Speed, Walk Speed, and
     Automation Helpers.

## AUTOMATION HOOKS (LATE-GAME RETENTION)

Players can unlock automated helpers that mine nodes passively without manual clicking:
1. Robotic Excavators: Mounted stationary drills attached to mine walls.
2. Mining Drones: Hovering pets that target nearby nodes automatically.
3. Minecarts / Conveyors: Automatic transportation lines for mined coal.

## ARCHITECTURE & REMOTEEVENTS (ReplicatedStorage)

All scripts must communicate cleanly using modular Luau standards:
- RemoteEvents: `MineNodeEvent`, `SellCoalEvent`, `BuyUpgradeEvent`, `UpdateHUDEvent`
- ModuleScripts: `PickaxeData` (names, costs, multipliers), `UpgradeData` (prices,
  caps), `AutomationData`.

---

# 3. TASKS.md — Task Split (MCP + Team Create workflow)

Two people, two separate Claude Code sessions, each controlling its OWN Roblox Studio
instance via the Roblox Studio MCP tools (execute_luau, multi_edit, script_read,
script_grep, insert_asset, etc). No Git, no Rojo for game code — the "shared project"
is the live place itself, kept in sync by Roblox's **Team Create**.

## How this actually works

There is no file sync and no shared memory between the two Claude sessions. The only
things that are actually shared are:

1. The place file, live, via Team Create — both Studio instances are editing the
   same Instance tree over the network in real time.
2. TASKS.md, STATUS.md, and CLAUDE.md — these stop two Claudes from grabbing the
   same Script at the same time, and keep both using identical RemoteEvent/Module
   names.

Requirements for this to work at all:
- The place must be published and both of you join it via Team Create (not two
  separate local copies of a .rbxl file). Two people editing separate local .rbxl
  copies with MCP will silently diverge — there is no merge step.
- Each of you has Roblox Studio open + the Studio MCP plugin connected, and your own
  Claude Code session pointed at your own Studio instance.
- Studio's own multiplayer locking applies: if your brother has a Script open and is
  editing it, you editing the same Script via MCP at the same moment can conflict.

## Ownership split (edit this as the game evolves)

Roblox has no folders/files — ownership is by Instance path in the Explorer tree.

### Person A — Rufus
Owns: Player systems, mining/economy, save data
- `ServerScriptService.Mining.*` — pickaxe tools, ore nodes, mining logic
- `ServerScriptService.Economy.*` — coins/cash, shop, upgrades
- `ServerScriptService.Data.*` — DataStore save/load, player profiles
- `ReplicatedStorage.Modules.PickaxeData`, `UpgradeData`

### Person B — Brother
Owns: World, UI, visuals, automation
- `StarterGui.*` — GUIs, HUD, shop UI, inventory UI, floating pop-up text
- `ReplicatedStorage.Effects.*` — particles, sounds, animation modules
- `ServerScriptService.Automation.*` — excavators, drones, minecarts/conveyors
- `ReplicatedStorage.Modules.AutomationData`

Note: neither person writes map/environment geometry per the hard constraint —
that's built manually in Studio by the two humans, not by AI.

### Shared / touch-with-care (either can edit, but MUST log it in STATUS.md first)
- `ReplicatedStorage.RemoteEvents` — `MineNodeEvent`, `SellCoalEvent`,
  `BuyUpgradeEvent`, `UpdateHUDEvent`
- `ReplicatedStorage.Modules.Config` or similar — shared constants (node values,
  total pool target of 1,000,000 Coal, etc.)

## Conflict rules

- Never edit an Instance path inside the other person's lane. If a task needs a new
  shared RemoteEvent, add it under the Shared section instead of reaching into their
  tree, and log it.
- Before starting a work session, inspect the relevant Instance path first — Team
  Create means the other person may have changed it since you last looked.
- If both online at the same time, say out loud what you're about to touch before
  a big multi_edit.
- Big structural changes (renaming a shared module, restructuring the Explorer tree)
  should happen with only one person active.

## Current milestone

_(Update this section together at the start of each session)_

- Milestone: e.g. "Vertical slice: mine ore -> sell -> buy pickaxe upgrade"
- Person A working on: _fill in_
- Person B working on: _fill in_

---

# 4. STATUS.md — Status Log

Shared logbook between the two sessions. The place itself updates LIVE the moment
either person edits it — this file's job is to tell the other person's AI *what
changed and why* and *what's about to change*, since there's no diff/pull step.

## Entry format

```
### [YYYY-MM-DD HH:MM] — Person A/B — short title
Touched (Instance paths): <e.g. ServerScriptService.Mining.OreNode>
Did:
- <what changed, plain English>
Added/changed shared interfaces:
- <new RemoteEvent name, new shared function signature, new Config key, etc>
Heads up:
- <anything that could break the other person's stuff right now>
```

## Log

### [2026-09-27 00:00] — Setup — initial structure
Touched (Instance paths): none yet — docs only
Did:
- Set up CLAUDE.md (auto-loaded game design rules + hard constraints + shared
  RemoteEvent/ModuleScript names), GAME_SPEC.md (original brief), TASKS.md
  (ownership split by Instance path), STATUS.md (this file).
Added/changed shared interfaces:
- Defined in CLAUDE.md: RemoteEvents MineNodeEvent, SellCoalEvent, BuyUpgradeEvent,
  UpdateHUDEvent; ModuleScripts PickaxeData, UpgradeData, AutomationData.
Heads up:
- Team Create must be enabled on the place before both of you can work "at the
  same time" — otherwise you'd be editing two local copies that can't merge.
