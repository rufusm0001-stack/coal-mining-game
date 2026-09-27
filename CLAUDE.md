# Coal Mining Game — Project Instructions

This file is loaded automatically by Claude Code at the start of every session run
from this folder (or a subfolder of it). Both of you should launch Claude Code with
this folder as your project directory so your Claude and your brother's Claude both
see the same rules without either of you re-pasting anything.

**Every session, before doing anything else: read TASKS.md and STATUS.md.**
They tell you who owns what part of the game right now and what changed since you
were last online. See GAME_SPEC.md for the original full design brief this is based on.

---

## Studio access (no Rojo, no Git for game code)

This project is built directly in Roblox Studio via the Studio MCP tools
(`execute_luau`, `multi_edit`, `script_read`, `script_grep`, `search_game_tree`,
`insert_asset`, etc). Both developers work on the SAME live place via Roblox
**Team Create** — there is no file sync step and no merge step, so read TASKS.md's
conflict rules before editing anything, especially shared Instances.

---

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
- Tool progression: 10 pickaxe tiers (Stone → Iron → Gold → Diamond → Plasma/Laser).
  3D models are generated externally via Meshy AI — not something Claude generates.
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
  - Upgrade Menu: clean, modern card-style UI (à la "Find the Needle" / "Where Did I
    Park?") for purchasing pickaxe tiers, swing speed, walk speed, and automation
    helpers.

## Automation Hooks (late-game retention)

Passive helpers that mine nodes without manual clicking:
1. Robotic Excavators — stationary drills mounted to mine walls.
2. Mining Drones — hovering pets that auto-target nearby nodes.
3. Minecarts / Conveyors — automatic transportation lines for mined coal.

## Architecture — shared names (use exactly as written)

These are the contract between your systems and your brother's. A rename here
silently breaks the other person's scripts — don't rename without updating
STATUS.md and telling the other person first.

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
