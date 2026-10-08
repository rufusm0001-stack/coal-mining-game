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

### [2026-10-08, later] — Rufus's Claude — Meshy models swapped into the game
Rufus imported the 12 Meshy v2 models. They landed in the universe inventory under the group
"CTRL + V GAMES", each one uploaded twice, and weren't placed in the game.

I inserted one copy of each into `ServerStorage.MeshyImports`. Each is a single textured
MeshPart, and they came in at random scales (around 190 studs, two at about 1 stud).

Swapped in:
- **Buildings and pads.** A scaled `MeshyVisual` MeshPart was added inside each of
  `MineSystems.GreatFurnace`, `MineSystems.CollectPad`, `BlockyTownFountain`, `PickaxeShop`
  and `Workshop`.
  - The old brick parts are hidden (Transparency 1, CanCollide off), with copies in
    `ServerStorage.Backup_BrickProps_20261008`.
  - The functional parts are kept: FeedZone, FireGlow, GlassPipeMain, ChimCapTop,
    CollectZone and LinkPipe.
- **Coal.** All 104 `CoalNodes.*.Rock` are now the Meshy coal mesh. The name is still `Rock`,
  so the shake and flash feedback work. The old unions are in the backup.
- **Scenery.** In `VoxelScenery`, 9 oaks, 13 pines, 73 bushes and 79 rocks are Meshy meshes
  now. The original unions are in the backup; flowers are unchanged.
- **Pickaxe.** `Templates.Pickaxe_Stone.Handle` is the Meshy pickaxe, 4.6 studs tall, with Grip
  y −1.5.
- **Cart.** Kept the brick CartTemplate, because the Meshy cart has its coal baked in and
  couldn't show the fill layers.

Verified in Play with no console errors: the town screenshot, the pickaxe resting pose, and
mining a Meshy coal rock (150 coal into the cart, remaining label counting down).

Still open:
- Furnace hall framing hasn't been reviewed; the furnace mesh is about 28 studs wide.
- The two old ChatGPT CartMesh carts on MineCartLine are still realistic meshes.
- No YouTube connector exists yet. vidIQ was suggested to Rufus; it does YouTube research
  and may not provide transcripts.

### [2026-10-08] — Rufus's Claude — Tutorial-based UI kit, map QA, zone colours, diamond celebration
Built on top of Codex's 2026-10-07 upgrade book (entry at the bottom of this file); none of its
logic was changed.

Verified in Play with no console errors:
- the new HUD and hotbar
- the cart walking beside the player
- the forced diamond find: burst, rising diamond, camera swing, beam visible from the town
  plaza, banner, +50 shards

Done:
- **UI kit** (from 17 YouTube UI tutorials, see `research_notes/yt/UI_TUTORIAL_FINDINGS.md`
  and the rewritten `docs/UI_RULES.md`):
  - `ReplicatedStorage.Modules.ToyUI` provides block, button, label, bar, icon and root.
  - Every element is built the same way: a darker outlined slab, a raised face with a gradient
    and an inner rim, a stud tile, and text with a stroke plus a hard shadow.
  - The root scale is 1280x720 based, ×1.7 on phones, capped at 1.
  - HUDClient and HotbarClient were rebuilt on the kit at the tutorial size budget.
  - Stud tile image: `Icons.StudTile`.
- **Cart:** it now follows beside the player (offset 4, 0, 1.5), smaller, and its parts have
  CanQuery off. It was blocking the camera when it followed directly behind.
- **Map QA:** `studio/map_qa.luau` (run it with execute_luau after fetching it from
  localhost). Ran it and fixed:
  - 113 floating props lowered onto the ground
  - 37 bushes and rocks left floating 80–140 studs up (on mountains that no longer exist)
    removed
  - 64 props hanging over cliff edges removed
  - 78 props on stud steps given a ground-coloured ledge block (`Skirt`)
  - Removed props are in `ServerStorage.Removed_OldTown.CliffEdgeScenery`.
- **Not fixed (intentionally):** the 26 "tipped" props are angled wall crystals and hanging
  chandeliers.
- **Colour:** each cave zone's interior blocks have their own palette, recorded in a
  `CaveZone` attribute:
  - Ember Hills red, Deep Pit purple, Junction teal, Coal Quarry ochre, Deep Tunnel blue.
  - Tunnels are wood-brown, and the furnace hall is warm.
  - Surface lighting: ClockTime 10, haze tinted to the sky, saturation 0.12.
- **Diamond moment:** new `StarterPlayer.StarterPlayerScripts.DiamondClient`:
  - debris burst, then the diamond rises toward the finder and spins with sparkles
  - a 12-wide neon beam shoots up out of the mountain
  - a 4 s camera orbit that won't clip through walls
- **MiningServer changes:**
  - the DiamondFound payload adds a `FinderPosition` field
  - a Studio-only `ServerStorage.DevTools.ForceDiamond` (BindableFunction, Invoke(player))
    finds the diamond in the rock nearest that player
- **Versioning:** every touched script is saved in `studio/*.lua`.
  `studio/_receiver.py` (port 8793) lets Studio POST script sources into the repo.
  To load from the repo, serve `studio/` on port 8792 and turn HttpEnabled on temporarily
  (it's off by default; I turned it back off).

Research:
- `reports/AI Roblox game creation playbook.md`
- `research_notes/yt/AI_GUIDES_FINDINGS.md`: 2025–26 AI-Roblox guides, with a 12-step plan.
  Steps 2, 3, 7 and 10 are done. Steps 1, 4, 5, 6, 8, 9 and 11 are still open.
- The YouTube map-tutorial transcripts are still IP-blocked.

Still open:
- Meshy v2 models: 12 in `art/models/`, not in the game. Uploading through the API key still
  returns 403. Rufus can import them with the Meshy Roblox Bridge or File → Import 3D.
- Zone landmarks and per-zone look briefs (plan steps 1 and 6).
- Rare-coal tells (plan step 11).
- Phone viewport check.

### [2026-10-06, night] — Rufus's Claude — Brick props, new furnace, mining back in the cave, hotbar + HUD
Rufus's feedback:
- The trees, rocks, shop and fountain looked weird.
- The furnace had a face; he wants a generic one with one big steam pipe at the side and a
  glass pipe out the back where smoke shows, connected to a miner-themed collect button.
- The cart and pickaxe looked bad.
- Things floated (roads).
- There was no UI, and the pickaxe showed the raw name "Pickaxe_Wood".

All addressed. Verified in Play with no console errors: mine a coal rock in the cave
(+50 per hit), cart fills, dump at the furnace, glass pipe smokes, collect $200 at the pad.

**How models are made now** (no Roblox upload key needed):
- Reference image (OpenAI gpt-image-2, `art/gen_refs.py`).
- Studio's `generate_procedural_model` builds it from real parts.
- Restyle to Plastic with top-only studs.
- Repeated props are merged with `GeometryService:UnionAsync` into one multi-colour
  UnionOperation and cloned (`ServerStorage.PropLibrary`). The original generated models
  are parked in `ServerStorage.GeneratedSources`.
- ProceduralModels must be converted to plain Models: they rebuild themselves in Play and
  undo any restyle (done for every placed one).
- Don't enter Play while a generation job is running. Jobs that finish during Play land in
  the Play session and are lost.

Studs: buildings and props now have studs on top faces only (sides smooth). Terrain keeps
studs on its sides.

Touched:
- **Scenery:** `Workspace.VoxelScenery` holds clones of OakUnion, PineUnion, RockUnion and
  BushUnion (268 props) plus the small flower clusters.
- **Town:**
  - `Workspace.BlockyTownFountain` replaces the old fountain.
  - `Workspace.PickaxeShop` replaces GeneralStore.
  - `Workspace.Workshop` (robot workshop) replaces SupplyStore.
  - Plaza re-laid as `PlazaTile` checker with a ring.
  - Old pieces are in `ServerStorage.Removed_OldTown`.
- **Settled:** 179 objects dropped onto the stud ground (roads no longer float).
- **Cave:**
  - Interior recoloured to warm brown stone.
  - Cave lights at 70% of their originals.
  - `Workspace.CoalNodes`: all 104 nodes rebuilt with a `Rock` (CoalUnion clone) plus the
    old `Hitbox` as PrimaryPart, tagged `CoalNode`, attributes Zone / MaxUnits / Units
    (9,615 each, 1,000,000 total). ChatGPT labels and attributes removed.
- **`Workspace.MineSystems`** (Furnace Hall, in the old Robot Room — the only tall open room):
  - `GreatFurnace`: FeedZone in front of the door, FireGlow with FurnaceLight,
    GlassPipeMain with PipeSmoke, ChimCapTop with Steam.
  - `CollectPad`: CollectZone tagged `CollectPad`, LinkPipe joining it to the glass pipe,
    PuffPath attribute.
- **Pickaxe:** `ServerStorage.Templates.Pickaxe_Stone` (PickaxeUnion handle, DisplayName
  "Stone Pickaxe", Tier 1, TextureId set). Pickaxe_Wood removed; PlayerServer gives
  Pickaxe_Stone.
- **Cart:** `ReplicatedStorage.Assets.CartTemplate` (Body, 4 spinning wheels, 4 coal layers,
  Offset attributes). CartClient rewritten to use it.
- **Icons:** uploaded through Studio's upload_image from localhost (no API key). Ids are in
  `ReplicatedStorage.Modules.Icons`; sources in `art/icons/ui`.
- **Scripts:**
  - Rewritten for the old cave: MiningServer, FurnaceServer, MiningClient,
    CoalFeedbackClient, FurnaceClient, HUDClient.
  - New: HotbarClient (custom hotbar; the default backpack bar is disabled).
  - LiftServer deleted (you walk into the cave now).
- **Config:** StartPower 50, MineRange 6 (measured to the rock's edge).

Shared interfaces (changed):
- `MineNodeEvent:FireServer(node: Model)`. The node must be tagged CoalNode and inside
  Workspace.CoalNodes.
- `ReplicatedStorage.MineProgress` (Configuration) attributes:
  - Total, Mined, DiamondFound
  - ZoneName_<key>, Z_<key>_Total, Z_<key>_Mined
- `CollectPad` tag is on the CollectZone part.
- `GreatFurnace` has a Burning attribute.

Known gaps / next:
- The Upgrade Book and shop UI aren't built. PickaxeShop and Workshop are only scenery so
  far.
- Robots and drones aren't built yet.
- Lobby permanent equipment isn't built yet.
- No saving to DataStore yet.
- Pacing: about 192 hits to clear one rock at 50 power. Tune once upgrades exist.
- StudTerrain is still ~26,500 parts. It needs vertical merging for phones.
- The cave's 4 old Minecart decor models and MineCartLine's 2 CartMesh carts are still
  realistic meshes.
- The diamond-found flow hasn't been tested in Play (it needs a debug trigger).
- The HUD hasn't had a ui-critic pass yet.

### [2026-10-06, later] — Rufus's Claude — Old world restored and turned into stud blocks
Rufus rejected the grey-box rebuild below: "my old game looked 10x better, it just needed
legoing". So the old world is back as the base, and the grey box (Workspace.Lobby /
Workspace.Mine) is deleted. Old mechanics (journal pages, story, expeditions) stay archived.

What changed in Studio:
- **Restored** from the archive into Workspace: ValleyDecor, Scenery, CoalNodes, CaveDecor,
  SupplyStore, GeneralStore, MineCartLine, SellStand, TownSquare, Baseplate, AdaCamp,
  DiamondLeaderboard, SpawnLocation, HouseLobby, CaveWayfinding. Terrain was pasted back,
  then converted (see below).
- **Backup:** a copy of the restored world before any restyling is at
  `ServerStorage.Backup_OldWorld_PreStud`. The original terrain is still in
  `Archive_ChatGPT_20261006.TerrainRegion`.
- **Parts:** 3,465 parts switched to Plastic with Studs surfaces (Inlet on the bottom) and
  their colours pushed brighter and more saturated. Neon, Glass, ForceField and invisible
  parts were left alone.
- **Terrain → studs:** `ServerStorage.DevTools.TerrainToStuds` rebuilt all solid terrain as
  surface-only stud blocks, greedily merged per layer, in `Workspace.StudTerrain`
  (~26,500 parts). Solid terrain was then cleared; 156 cells remain.
  - Cave interior blocks (anything with stud rock overhead) are recoloured purple and carry
    a `CaveInterior` attribute.
  - Paved ground east of the plaza was turned into grass (`WasPaved` attribute).
- **Scenery:** `ServerStorage.DevTools.VoxelProps` replaced the 433 realistic scenery meshes
  (165 flower patches, 123 rocks, 104 bushes, 21 pines, 20 oaks) with studded cube builds in
  `Workspace.VoxelScenery`.
- **Lighting:** the 72 cave lights are dimmed to 40% (originals kept in an
  `OriginalBrightness` attribute). Colour saturation boost lowered to 0.1.
- **Paused** (Enabled = false) until they're moved into the old cave: LiftServer,
  MiningServer, FurnaceServer, FurnaceClient, HUDClient, CoalFeedbackClient. PlayerServer,
  MiningClient and CartClient still run (pickaxe pose and swing, following cart).

Art:
- Meshy spend: 270 credits for 9 models (balance 3,570).
- The furnace, minecart and pickaxe models are good, in `art/models/`.
- The scenery models melted at low poly, so they're not used (part-built props instead).
- The coal node lost its gold studs and probably needs a redo at a higher poly count.

**Blocked:** the Roblox Open Cloud key in api.txt returns 403 "User not authenticated" for
asset uploads. Rufus needs to add Assets read + write to the key (and allow IP
0.0.0.0/0), or import the FBX files by hand with File → Import 3D.

Next:
- Put the furnace, cart and pickaxe models in.
- Re-home mining onto the old cave's 104 CoalNodes, using the new coal model.
- Re-enable the paused scripts: furnace in the cave, collect pads, HUD and minimap over the
  old cave zones.
- Slim down StudTerrain (vertical merging) for phones.
- Remove ChatGPT's old "1000 / 1000" billboards from the coal nodes.

### [2026-10-06] — Rufus's Claude — v2 rebuild, part 1: stud world + full core loop
**Superseded by the entry above.** The grey-box world described here was deleted; the
scripts were kept and are partly paused.
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

## 2026-10-07 — Codex upgrade book in progress
User requested continued improvements to current v2. Editing PlayerData, MiningServer, MiningClient, FurnaceServer; adding Modules.UpgradeData, Economy.UpgradeServer, StarterPlayerScripts.UpgradeBookClient and RemoteEvents.UpgradeEvent. Existing cart/furnace gameplay retained. Backups before edits.

## 2026-10-07 — Upgrade book implemented (Codex)
- Added ReplicatedStorage.Modules.UpgradeData; RemoteEvents.UpgradeEvent; ServerScriptService.Economy.UpgradeServer; StarterPlayer.StarterPlayerScripts.UpgradeBookClient.
- Updated ServerScriptService.Data.PlayerData, ServerScriptService.Mining.MiningServer and StarterPlayer.StarterPlayerScripts.MiningClient. FurnaceServer unchanged: existing profile-identity check already invalidates old delayed credits.
- Shared HUD payload adds UpgradeLevels, SwingSpeed, Reach. Money mirrored as Player attribute. UpgradeEvent client sends track key + expected level (or Sync); server returns key, success, reason. Prices and effects calculated server-side; expected level prevents duplicate charges.
- Five levels each for Power (50->330), Speed (1->1.8x), Reach (6->12 studs), Capacity (250->4000). Initial prices 200/300/150/200 coins. These are initial tuning values, not a validated hour-long economy.
- New mine replaces run profile, clears run money/cart/upgrades/contribution, retains shards. Old in-flight furnace earnings cannot cross runs.
- ToyUI upgrade book: desktop illustration, responsive phone layout, level pips, before/after stats, coin purchase effect, insufficient-funds shake, B shortcut, prevents new mining swings while open.
- QA passed: all four purchase tracks, five-level caps, stale duplicate request, invalid type/key/NaN, insufficient funds, reset and shard retention. Live remote purchases spent exactly 850 from a 2000 test balance; actual mining awarded 75 into a 500 cart at upgraded reach. Test fixtures/wallet only existed in Play and were discarded on stop.
- Visual review: 1920x1080 over mine and 375px portrait; footer crowding fixed. Reviewed against ui-critic checklist directly; separate critic agent not run. Landscape scrolling implemented but not device-tested. No runtime console errors in final Play test.
- Backup: ServerStorage.Backup_UpgradeBook_20261007. Versioned source copies in studio/*.lua. Studio left in Edit. No live publish performed.
- Existing gaps: no DataStore persistence; published animation IDs still missing. Upgrade purchase sound and dedicated per-track icon artwork still to add. This does not implement robots, permanent gear, lobby matchmaking, or cutscene changes.
