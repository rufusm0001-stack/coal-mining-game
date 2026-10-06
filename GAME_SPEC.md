# Find The Diamond In The Coal — Game Design v2

Decided with Rufus on 2026-10-06. Replaces the v1 brief (kept in `docs/archive/GAME_SPEC_v1.md`).
ChatGPT/Codex's build (expeditions, parties, pets, eggs, robots v1, story, journal, dark town)
is archived in `ServerStorage.Archive_ChatGPT_20261006` and is NOT part of this design.

## The pitch

One diamond is hidden somewhere among about a million pieces of coal. Everyone on the server
digs through the mine together to find it. A run takes about an hour. Along the way you find
rarer stuff (gold coal, platinum, rainbow coal) that pays out more.

Not a competition: the whole server is a team.

## Look

Colourful stud-voxel world, like Prehistoric Farm: chunky cubes, stud tile texture, saturated
colours, low poly. Sunny surface town as the lobby; underground is colourful and glowing
(orange lava, purple/teal crystals, warm lanterns), never pitch black. Coal stays dark so it
pops against that. Full rules: `docs/STYLE_BIBLE.md`.

Players keep their own Roblox avatar, plus a stud-style miner hard hat with a lamp.

## Core loop

1. **Mine.** Left click swings the pickaxe (hold to keep swinging). Each hit knocks coal off a
   coal block into your cart.
2. **Cart.** A little cart follows you like a pet (no collisions, so it never snags), and you
   can see coal piling up in it. When it's full you can't mine more.
3. **Furnace.** The Great Furnace sits in the middle of the mine. Walk up to it and your cart
   tips its coal in: flames flare, steam blasts out of the chimneys.
4. **Pipes → money.** Burning coal makes money. Gas puffs travel along pipes out of the back of
   the furnace to collect pads. Stand on a pad to collect your money. Pipes are shared; the
   money you collect is what your own coal earned.
5. **Upgrade.** Spend money in the Upgrade Book (UI) and the Shop (NPC). See below.
6. **Search.** The minimap shows every room and how much of it has been cleared, so the team
   knows where is still unsearched.
7. **Find the diamond.** It's hidden inside one random coal unit. Whoever's hit releases it
   triggers a server-wide celebration and the run ends: everyone gets rewards based on what
   they contributed, then returns to the lobby and the mine regenerates.

## Progression inside a run (resets each run)

- **Pickaxes:** the best way to mine, all the way to the top tiers late in the run. Each
  pickaxe has three upgrade tracks: Power (coal per hit), Speed (swing rate), Reach.
- **Cart:** Capacity and Pull Speed. Visible tiers: wheelbarrow → wooden minecart → iron ore
  wagon → crystal hauler.
- **Robots:** ground helpers that walk to coal and mine automatically. Good because they're
  automatic, weaker than pickaxes.
- **Drones:** fly to coal, mine until full (capacity bar over their head), fly back to the
  furnace, dump, repeat.
- Pickaxes and robots/drones are bought at the Shop; their upgrade tracks live in the
  Upgrade Book.

## Between runs (permanent, no rebirth)

The sunny surface town is the lobby. Run rewards buy permanent equipment that gives boosts in
every future run (e.g. bigger starting cart, faster swing, brighter hat lamp, lucky finds).
Nothing you buy here is ever reset.

## UI references

- Upgrade Book: Rufus's reference screenshot (hay game). Open-book layout, one page per tool,
  three upgrade tracks each with icon + price + level pips, locked tools shown as "???" slots
  with padlocks, "your money" footer. We restyle it in stud-toy style.
- Prehistoric Farm: left rail of round icon buttons with labels, bottom hotbar, quest tracker.
- Rules: `docs/UI_RULES.md`. Research notes: `docs/ui/RESEARCH.md`.

## Later, not now

Harder cave layers, mobs, swords/crafting (a bit like 99 Nights in the Forest), more cart/drone
variety. Don't build these until Rufus asks.

## Numbers (starting point, tune in playtests)

- Coal pool per run: ~1,000,000 units across all rooms. Diamond = one random unit.
- Target run length: ~60 minutes for ~4 players.
- Rare finds: gold coal, platinum, rainbow coal; exact rates TBD.
