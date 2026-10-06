# Status Log — Coal Mining Game (MCP + Team Create)

Shared logbook between the two Claude sessions, each driving its own Roblox Studio
via MCP against the same Team Create place. Unlike a git workflow, the place itself
updates LIVE the moment either of you edits it — this file's job is purely to tell
the other person's Claude *what changed and why* and *what's about to change*, since
there's no diff/pull to review before it lands. See CLAUDE.md for game design rules
and TASKS.md for the ownership split.

## How to use this file

**At the start of a session, tell your Claude:**
> "Read STATUS.md before touching anything, so you know what my brother's Claude
> changed since I was last online, and check the relevant part of the Explorer tree
> with search_game_tree/inspect_instance to confirm it matches what's logged."

**Before a big edit, tell your Claude:**
> "Post a STATUS.md entry (or just tell me) saying what Instance paths you're about
> to change, before running multi_edit/execute_luau, in case my brother is online
> right now."

**At the end of a session, tell your Claude:**
> "Add an entry to STATUS.md: what you changed, which Instance paths, any new
> RemoteEvents/shared functions/Config values, and anything that could break the
> other side's scripts."

Keep entries short. Newest entry at the top.

---

## Entry format (copy this template)

```
### [YYYY-MM-DD HH:MM] — Person A/B — short title
Touched (Instance paths): <e.g. ServerScriptService.Mining.OreNode>
Did:
- <what changed, plain English>
Added/changed shared interfaces:
- <new RemoteEvent name, new shared function signature, new Config key, etc —
  anything the OTHER side's code might call or depend on>
Heads up:
- <anything that could break the other person's stuff right now, e.g.
  "renamed Config.OreValues to Config.OreWorth — your shop UI reads the old name">
```

---

## Log

### [2026-10-06] — Rufus's Claude — v2 rebuild, part 1: stud world + full core loop
Rufus decided the v2 design (see GAME_SPEC.md) and handed the whole rebuild to this session.
His brother's Claude should read this entry and GAME_SPEC.md, and play/review rather than edit
until TASKS.md says the lanes are back.

**Archived, not deleted:** everything ChatGPT/Codex built (town, house lobby, 104 coal nodes,
expeditions/parties, pets, eggs, robots, story, journal, all 22 client scripts, its HUD,
lighting and terrain) is in `ServerStorage.Archive_ChatGPT_20261006`, bucketed by the
service it came from.
- Terrain was copied to `Archive_ChatGPT_20261006.TerrainRegion` and then cleared.
- Old CollectionService tags were stripped inside the archive and kept as `ArchivedTag_*`
  attributes, so new systems don't pick up archived instances.

Verified in Play, with no console errors:
- the lift takes you down to the mine
- holding left click mines coal into the cart (25 per hit)
- the cart follows you and fills visibly
- walking into the furnace dumps the cart, and the flames/steam flare
- gas puffs run along the pipes, and standing on a pad collected $75 from 75 coal
- the minimap shows each room's % and outlines the room you're in

**Not tested:** finding the diamond. One coal unit in a million, so it needs a debug
trigger next session.

Touched (Instance paths):
- **World:**
  - `Workspace.Lobby`: grass plateau, path, `SpawnLocation`, `MineLift.LiftPad`
    (LiftTarget = Mine)
  - `Workspace.Mine`, 300 studs below:
    - `Shell` (floor, ceiling, walls, doorways, rugs, glowing pillars, hall lamp)
    - `Rooms` (8 invisible zone parts N, NE, E, SE, S, SW, W, NW, with RoomName / Accent /
      TotalUnits / MinedUnits attributes)
    - `GreatFurnace` (Base, Body, FireMouth with Flames, Chimney1/2 with Steam, FeedZone)
    - `Pipes.Route1/2` (Waypoints attribute)
    - `CollectPads.Pad1/2` (tag `CollectPad`)
    - `CoalBlocks.<room>` (1,006 blocks, tag `CoalBlock`, Units / MaxUnits / Room
      attributes, 1,000,000 units in total)
    - `ArrivalPad` (LiftTarget = Lobby)
  - `Lighting`: sunny (ClockTime 14, Atmosphere, ColorCorrection, Bloom).
    `Workspace.StreamingEnabled = false` (the game is ~1,500 parts and streaming broke the
    HUD/minimap).
- **Shared:**
  - `ReplicatedStorage.RemoteEvents`: MineNodeEvent, BuyUpgradeEvent, UpdateHUDEvent,
    RunEvent, FurnaceEvent
  - `ReplicatedStorage.Modules.Config`: v2 tuning
  - `ReplicatedStorage.Assets.Animations.PickaxeRest` and `PickaxeSwing` (copied from the
    archive)
  - `ReplicatedStorage.Effects.MineImpactSound`
- **Server:**
  - `ServerStorage.Templates.Pickaxe_Wood` (stud-part placeholder tool)
  - `ServerScriptService.Data.PlayerData` (module) and `Data.PlayerServer`
  - `World.LiftServer`
  - `Mining.MiningServer` (blocks, hidden diamond, room stats, run end + regenerate)
  - `Economy.FurnaceServer`
- **Client:** `StarterPlayer.StarterPlayerScripts.MiningClient`, `CoalFeedbackClient`,
  `CartClient`, `FurnaceClient`, `HUDClient`

Shared interfaces:
- `MineNodeEvent:FireServer(block: BasePart)`. The server checks the tag, range (9),
  facing, 0.45 s cooldown, Pickaxe_ tool and cart room.
- `UpdateHUDEvent` (server → client): `{Cart, CartCapacity, Money, PipeMoney, Shards, Power}`.
  The server also mirrors `Cart` / `CartCapacity` onto Player attributes for everyone's cart
  visuals.
- `FurnaceEvent`: `("Dump", player, amount)` to all clients; `("Collected", amount, pad)` to
  the collecting player.
- `RunEvent`: `("DiamondFound", {Finder, Position, ShardsEarned, RegenerateIn})` and
  `("RunStarted")`.
- The diamond's block is held only in MiningServer locals, never in an attribute, so
  clients can't find it early.

Docs and agents added:
- `GAME_SPEC.md` (v2), with v1 moved to `docs/archive/`
- `docs/STYLE_BIBLE.md`, `docs/UI_RULES.md`
- `docs/ui/RESEARCH.md` (30 sourced findings from the ui-researcher agent; its proposed rule
  changes are NOT merged into UI_RULES yet)
- `.claude/agents/ui-researcher.md`, `ui-critic.md`, `asset-artist.md`
- `art/gen_refs.py`, `art/LEDGER.md`, `art/refs/` (style test)

Heads up / next:
- **Art:** Gemini's prepaid credit is empty (HTTP 402). The style test ran on OpenAI
  instead (about $0.02). Cart and furnace references are approved-quality and ready for
  Meshy; the pickaxe needs a re-prompt. Meshy is untouched. Wait for Rufus to approve the
  style before spending.
- **Still placeholders:** pickaxe, cart, furnace, pads. No hard hat yet.
- **Not built yet:** Upgrade Book, Shop, robots, drones, lobby permanent equipment, rare
  finds, DataStore saving (all state is in memory).
- **UI:** the HUD is a first pass and hasn't had a ui-critic review. Merge the research rule
  changes first.
- **Run length:** at 25 coal per hit, one player would take forever. Upgrades and helpers
  are what make an hour realistic; tune once they exist.
- **Polish:** "Mine searched" shows 0.0% for a long time; show two decimals under 1%.

### [2026-09-28] — Person A (Rufus's Claude) — Mining vertical slice
Built the whole first playable loop in one pass, across both lanes (mining/economy AND
UI/effects/animation), so both of you have something working to build on. Verified in Play:
single click = 1 hit, holding LMB = repeated swings, selling empties the bag, walking while
swinging works, no console errors.

Touched (Instance paths):
- `ReplicatedStorage.RemoteEvents` (Folder) + `MineNodeEvent`, `SellCoalEvent`,
  `BuyUpgradeEvent`, `UpdateHUDEvent` (RemoteEvents)
- `ReplicatedStorage.Modules.Config`, `.PickaxeData`, `.UpgradeData`, `.AutomationData`
- `ReplicatedStorage.Assets.Animations.PickaxeRest`, `.PickaxeSwing` (KeyframeSequences)
- `ReplicatedStorage.Effects.MineImpactSound` (free Creator Store SFX 9118617342)
- `ServerStorage.Templates.Pickaxe_Amethyst` (Tool, from the Meshy amethyst pickaxe)
- `ServerStorage.Templates.Backpack_GildedGem` (Model, from the Meshy gem backpack)
- `ServerScriptService.Data.PlayerDataModule` (ModuleScript), `.PlayerDataServer` (Script)
- `ServerScriptService.Mining.MiningServer` (Script)
- `ServerScriptService.Economy.EconomyServer` (Script)
- `ServerScriptService.Automation` (empty Folder, Person B)
- `StarterPlayer.StarterPlayerScripts.MiningClient`, `.CoalNodeFeedbackClient`, `.HUDClient`
- `Workspace.CoalNodes.CoalNode_1` (Meshy obsidian coal + invisible `Hitbox`, tag `CoalNode`)
- `Workspace.FloorCoalDecor`, `Workspace.SpawnLocation`, `Workspace.SellStand`,
  `Workspace.Shopkeeper`
- Removed: the three raw `Workspace.Meshy_AI_*` imports (converted into the above), and a
  first-draft `StarterGui.MiningHUD` top panel.

Did:
- Players' own avatar animation packs are reset to Roblox defaults on spawn
  (`PlayerDataServer`), then they get the gem backpack welded to their back and the
  amethyst pickaxe auto-equipped.
- Pickaxe animations are real animation tracks, upper-body only, so legs keep walking:
  `PickaxeRest` (loop, Action priority) rests the pickaxe over the right shoulder with a
  slight lean back; `PickaxeSwing` (0.58s, Action2) goes wind-up → strike → recover, with a
  `Contact` marker at 0.30s.
- Left click swings, holding keeps swinging. The client picks the nearest coal in range
  and in front of you, turns to face it, and at the `Contact` marker fires `MineNodeEvent`.
- `MiningServer` validates each hit: player holds a `Pickaxe_*` tool, node exists and
  isn't depleted, distance ≤ `Config.MineRange` (7), facing, 0.45s cooldown, bag not full.
  Awards `min(42, node remaining, bag room)`.
- Each node holds 1,000 coal (`Remaining` / `MaxCoal` attributes). Label above it counts
  down (1,000 → 958 → ...). Each hit flashes it white and shakes it. At 0 it hides and
  respawns after 15s. Duplicated nodes get a fresh unique `NodeId` automatically.
- Local feedback at contact: "+42 Coal" floating text, rock impact sound, dust particles.
  "Bag full! Sell your coal" in red if full.
- Bag counter ("42 / 1,000 Coal") floats above your own backpack, red "FULL" when full.
- Sell: walk to `SellStand` and hold E (ProximityPrompt), or fire `SellCoalEvent`.
  Coal → cash 1:1 for now.

Added/changed shared interfaces:
- `MineNodeEvent` (client → server): `FireServer(nodeId: string)`
- `SellCoalEvent` (client → server): `FireServer()`
- `BuyUpgradeEvent` (client → server): `FireServer(upgradeType: string, level: number)`
  — only `"BagCapacity"` handled so far.
- `UpdateHUDEvent` (server → client): `{ Coal, Cash, BagCapacity }`. Fired on join, on
  spawn, and after every hit / sell / purchase. Both `HUDClient` and `MiningClient` listen.
- Coal node attributes: `NodeId`, `MaxCoal`, `Remaining`, `Depleted` (server-owned).
- `Config` additions: `MineRange`, `MineFacingDotThreshold`, `SwingDuration`,
  `MineCooldown`, `TestPickaxeYield`, `TestBagCapacity`, `NodeCoalCapacity`,
  `NodeRespawnSeconds`, `Animations.RestId`, `Animations.SwingId`.

Heads up / still to do:
- **Animations must be published before going live.** Right now they only play in
  Studio. In Explorer, right-click `ReplicatedStorage.Assets.Animations.PickaxeRest` →
  Save to Roblox, copy the asset id into `Config.Animations.RestId`; same for
  `PickaxeSwing` → `SwingId`.
- **R15 only.** Set Game Settings → Avatar → Avatar Type to R15, or R6 players won't pose.
- Coal/cash are in memory only — no DataStore yet, everything resets when the server
  restarts.
- Cash isn't shown anywhere yet (only the bag counter). Shop UI not built;
  `Shopkeeper`'s prompt says "coming soon" and does nothing.
- `SellStand` and `Shopkeeper` are plain-part placeholders, not Meshy/Gemini art.
- Only one coal node exists. Add more by duplicating `Workspace.CoalNodes.CoalNode_1`.
- Pose/grip tuning lives in the KeyframeSequences and `Pickaxe_Amethyst.Grip`. The resting
  pickaxe head slightly overlaps the backpack.
- If Team Create has Collaborative Editing on, these script edits may sit as drafts until
  committed (View → Drafts) — your brother won't see them until then.


### [2026-09-28 00:46] — Astra — Bag and boot upgrade references
Touched (Instance paths): none; local assets only in `bag images/` and `boots/`.
Did:
- Generated and reviewed 15 bag upgrade PNGs and 15 boot-pair upgrade PNGs with Gemini, all 2048 x 2048.
- Used consecutive image references for a consistent coal-miner equipment family, progressing from practical starter gear to reinforced metal and crystal accents.
Added/changed shared interfaces:
- None; no Roblox scripts, Instances, UI or animation changes.
Heads up:
- Images are Meshy Image-to-3D references, not meshes or equipped accessories. Boots show both matching feet per image.
- Tier names are visual proposals only; economy and capacity values are not assigned.
- Sell stand and additional hammers have not been generated in this batch.


### [2026-09-27 23:56] — Astra — Meshy reference images
Touched (Instance paths): none; local image assets only in `photoos for 3d/`.
Did:
- Generated and visually reviewed 14 individual 2048 x 2048 PNG references using Gemini: 10 related pickaxe tiers and 4 coal shapes (3 large formations, 1 dedicated small chunk).
- Kept a consistent metal-handle pickaxe progression; later tiers add crystal and four-point heads. No futuristic tools.
- Corrected the initial coal shape and final two pickaxe tiers before delivery.
Added/changed shared interfaces:
- None. No Roblox Studio Instances or scripts changed.
Heads up:
- Images are references for Meshy Image-to-3D, not finished meshes; no import has been performed.
- Tier filenames describe proposed visuals, not changes to progression data.


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
- This whole folder needs to exist on BOTH machines for CLAUDE.md to auto-load for
  both of you — see the note below on sharing it.

### [2026-10-06] Codex - visual polish in progress
User authorized visual improvements to Find The Diamond In the Coal (105849041537760). Do not touch Idle Medieval. Working on HUDClient, GoalHUDClient and existing town decoration colours. Egg/pet decision pending user. No shared interfaces or economy changes planned. Recoverable backup will be stored in ServerStorage.VisualBackup_20261006.

Visual pass completed: recoloured existing GeneralStore/SupplyStore/SellStand/ValleyDecor/TownSquare; removed 51 balloon/cash decoration parts; originals in ServerStorage.VisualBackup_20261006. Updated HUDClient (screen bag bar and modal visibility), GoalHUDClient (readable progress/narrow layout), ShopClient (palette/font/centred cards/narrow cash layout), MenuClient, StoryClient, TipsClient (palette/fonts). Six original script copies also in that backup. No shared data interfaces/economy edits. Egg yard and pet systems unchanged pending user decision. Playtested shop opening, pickaxe page, settings, HUD hiding/restoration. No script errors observed; DataStore API disabled in Studio. Mobile layout code added but device-emulator testing remains. Studio returned to Edit mode. Did not publish or touch Idle Medieval.

### [2026-10-06] House lobby rebuild - Codex
User explicitly requested house/road/mailbox environment, no eggs, party creation, intro cutscene, mining journal UI and cave revamp. This supersedes older no-environment-generation constraint for this task. Adding RemoteEvents.ExpeditionEvent and ExpeditionState attributes, LobbyServer and JournalClient; replacing old HUD/shop/menu/story presentation. Existing progression retained pending user answer. Back up touched scripts and world before edits. Do not edit Idle Medieval.
