# Coal Mining Game — Task Split (MCP + Team Create workflow)

See CLAUDE.md for the game design rules (auto-loaded every session) and GAME_SPEC.md
for the original full brief. This file is just about who's allowed to touch what.

Two people, two separate Claude Code sessions, each controlling its OWN Roblox Studio
instance via the Roblox Studio MCP tools (execute_luau, multi_edit, script_read,
script_grep, insert_asset, etc). No Git, no Rojo for game code — the "shared project"
is the live place itself, kept in sync by Roblox's **Team Create**.

## How this actually works (read this first)

There is no file sync and no shared memory between the two Claude sessions. The only
things that are actually shared are:

1. **The place file**, live, via Team Create — both Studio instances are editing the
   same Instance tree over the network in real time.
2. **This file, STATUS.md, and CLAUDE.md** — these stop two Claudes from grabbing the
   same Script at the same time, and keep both using identical RemoteEvent/Module
   names (see CLAUDE.md's Architecture section).

Requirements for this to work at all:
- The place must be published and both of you join it via **Team Create** (File >
  Open from Roblox / Team Create, not two separate local copies of a .rbxl file).
  Two people editing separate local .rbxl copies with MCP will silently diverge —
  there is no merge step, so this is the one hard requirement.
- Each of you has Roblox Studio open + the Studio MCP plugin connected, and your own
  Claude Code session pointed at your own Studio instance, launched from this project
  folder (so CLAUDE.md auto-loads).
- Studio's own multiplayer locking applies: if your brother has a Script open and is
  editing it, you editing the same Script via MCP at the same moment can conflict.
  The ownership split below exists mainly to avoid that collision, not to avoid
  merge conflicts (there's no merge step — it's live).

## Ownership split (edit this as the game evolves)

Roblox has no folders/files — ownership is by **Instance path in the Explorer tree**.
Agree on paths up front so neither Claude goes rooting around in the other's part
of the hierarchy.

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

Note: neither of you writes map/environment geometry per CLAUDE.md's hard
constraint — that's built manually in Studio by the two of you as humans, not by
either Claude.

### Shared / touch-with-care (either can edit, but MUST log it in STATUS.md first)
- `ReplicatedStorage.RemoteEvents` — `MineNodeEvent`, `SellCoalEvent`,
  `BuyUpgradeEvent`, `UpdateHUDEvent` (exact names — see CLAUDE.md)
- `ReplicatedStorage.Modules.Config` or similar — shared constants (node values,
  total pool target of 1,000,000 Coal, etc.)

Rule: before editing a shared Instance, post in STATUS.md (or just tell each other
directly if you're both online) so the other person's Claude doesn't read a stale
version mid-edit via Team Create.

## Conflict rules

- Never run `execute_luau`/`multi_edit` against an Instance path inside the other
  person's lane. If a task needs a new shared RemoteEvent, add it under the Shared
  section instead of reaching into their tree, and log it.
- Before starting a work session, tell your Claude to `search_game_tree` / inspect
  the relevant Instance path first — Team Create means the other person may have
  changed it since you last looked, and there's no "pull" step to remind you.
- If you and your brother are both online at the same time, say out loud (Discord/
  voice call) what you're about to touch before your Claude runs a big multi_edit —
  cheaper than resolving a live overwrite in Team Create.
- Big structural changes (renaming a shared module, restructuring the Explorer tree)
  should happen with only ONE person's Claude active, to avoid the other Claude
  working off a tree that's being rearranged under it.

## Current milestone

_(Update this section together at the start of each session)_

- [ ] Milestone: e.g. "Vertical slice: mine ore -> sell -> buy pickaxe upgrade"
- Person A working on: _fill in_
- Person B working on: _fill in_
