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
