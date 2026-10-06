# Original Design Brief (verbatim)

This is the original prompt used to brief an AI on this project's game design.
The distilled, always-loaded version of these rules lives in CLAUDE.md — this file
is kept as the source-of-truth reference in case the two ever drift or you want the
full original framing.

---

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
