# AI-built Roblox games: how creators make them look good (2025-2026)

Researched 2026-10-07 for "Find The Diamond In The Coal" (placeId 105849041537760).
Builds on `reports/AI Roblox game creation playbook.md` and doesn't repeat it. The playbook covers
the MCP tool list, the verify loop, discovery, the 6-phase map order, the scale-sheet idea, perf
budgets, image-to-3D pricing, import limits, UI anti-slop rules and packaging skills. This file goes
one level down: what creators actually do, step by step, to stop AI output looking like slop, and a
concrete plan for our game.

**Evidence caveat.** YouTube blocked transcript downloads from this machine with HTTP 429 from both
`youtube_transcript_api` and yt-dlp subtitles. Partway through, it also started demanding sign-in
for metadata. So no transcripts were saved in `research_notes/yt/ai/`. Video points below come from
each creator's own **description and chapter list** (tagged *[desc]*). Written sources (GitHub
skills with A/B test logs, articles, Roblox docs) carry most of the how-to detail and are tagged
*[text]*. Treat *[desc]* claims as the creator's summary of the video, not as something I watched.

---

## 1. Best recent sources

| # | Title | Creator | Date | Views | URL | Useful for |
|---|---|---|---|---|---|---|
| S1 | Can AI Make an Entire Roblox Incremental Game? (Art, 3D Models, Code) | SyphoDev | 2026-09-26 | 41k | https://www.youtube.com/watch?v=RNnUqomUaII | Has a chapter titled "Why most AI Roblox games look like slop". Fix: one Claude Code skill per discipline (map, UI, 3D, VFX, animation, code). Also "UI mockups" and "Map design & fixing lighting" chapters |
| S2 | Can AI Make an Entire Roblox Tower Defense Game? (3D Models, VFX, Code) | SyphoDev | 2026-10-01 | 26k | https://www.youtube.com/watch?v=WIYBh_kkKN8 | Same pipeline on Opus 5.5. Lists what broke in playtests (towers that didn't turn to aim, a swatter that fired a beam, an untextured sandwich) and says a VFX skill pass fixed it |
| S3 | How to Make a Roblox Game With AI (Claude Opus 5.5 Full Tutorial) | SyphoDev | 2026-10-04 | 53k | https://www.youtube.com/watch?v=afuKhenJldY | The full setup: skills, the Studio MCP, Flux images, Hi3DGen meshes, Blender to get under the triangle limit, and Open Cloud upload without ever pasting the key into chat |
| S4 | I Made a 3D Asset in Roblox with AI (Cube Tutorial) | PlayUGC | 2026-06-29 | 0.6k | https://www.youtube.com/watch?v=Lcj4vv-bAxA | Over-detailed prompts break Cube. Use a 3/4-view, white-background reference image (a tip from the Roblox team). An agent that plans, builds piece by piece, screenshots and verifies. Accept about 75% fidelity |
| S5 | How I Get Codex to Build GOOD Roblox Maps | azuregpt | 2026-09-18 | 0.6k | https://www.youtube.com/watch?v=RGRu988ovoI | Map method: references, then multiple views, then each building split into passes, with a review after every stage |
| S6 | This AI Makes INSANE Roblox GUIs | DitchyDevelopments | 2026-07-12 | 53k | https://www.youtube.com/watch?v=DBC6FsdvP-M | Publishes the exact prompts: one locked style suffix reused for every button and icon |
| S7 | ForgeGUI review | Nilo (article) | 2026-09-24, upd. 10-03 | n/a | https://nilo.io/articles/forgegui-review-roblox | AI GUI output is a picture, not a working ScreenGui. Creators use it as a spec and rebuild natively. RoBuilder still needed Z-index fixes |
| S8 | What I learned shipping 30 AI-generated game assets to Roblox in a 48-hour jam | Marcus Chen (Meshy), HackerNoon | 2026-06-05 | n/a | https://hackernoon.com/what-i-learned-shipping-30-ai-generated-game-assets-to-roblox-in-a-48-hour-game-jam-using-meshy | A 5-line world bible becomes a locked prompt template (about 80% consistency). Scale chaos, voxel collision walls inside doorways, 20% colour drift, regenerate rather than fix. The Meshy Roblox Bridge |
| S9 | Vibe Coding Roblox Assets: Skip Blender, Ship Fast | Nuno Leiria, Nilo | 2026-04-19, upd. 10-03 | n/a | https://nilo.io/articles/vibe-coding-roblox-assets | Put negatives in the prompt ("no ornamental carvings"). 5k-15k triangles can already hurt mobile. Check for fused details, holes and thin parts |
| S10 | roblox-dev-skills (building-maps, building-3d-objects, retrospective log) | ohzw (GitHub) | 2026-02/03 | n/a | https://github.com/ohzw/roblox-dev-skills | **Real A/B tests** of agent map builds: colour and material quality depends on how precise the brief is; every agent produced wrongly rotated parts; part count is not a quality measure; validation must be a script, not a checklist |
| S11 | roblox-studio skill (SceneSpec, grounding, visual probe) | ShiroKSH (GitHub) | 2026-07-10 | n/a | https://github.com/ShiroKSH/skills | Raycast grounding with a "skirt" support. "Check the route at avatar scale, not only from an exterior camera." Never call a map visually ready from counts or validation alone |
| S12 | How Procedural Models work on Roblox | Roblox Learn | 2026-09-03 | 81k | https://www.youtube.com/watch?v=gu1iPJmyMgA | Building procedural models from "puzzle pieces" (chapters). The docs add that they regenerate when their attributes change |
| S13 | Assistant for Studio guide (generate_mesh, procedural) | Roblox docs | live | n/a | https://create.roblox.com/docs/en-us/assistant/guide | A Part as the mesh bounding box. Lower max triangles gives a more faceted low-poly result. Text **or** image input. Up to 8 parts. 50 procedural models per day |
| S14 | Customize global lighting | Roblox docs | live | n/a | https://create.roblox.com/docs/en-us/tutorials/curriculums/core/building/customize-global-lighting | Exact Lighting and Atmosphere values with the reason for each |
| S15 | How to Make a Roblox Game With AI (Studio Bridge 2026) | Sorceress blog | 2026-09-01 | n/a | https://sorceress.games/blog/how-to-make-a-roblox-game-with-ai-studio-bridge-2026 | Follow-ups name exact numbers ("shorten jump gap from 14 to 10 studs"). One system per patch, 3-7 minute cycles |
| S16 | ChatGPT vs Claude Make A Viral Roblox Game | AI PILLED | 2026-09-28 | 184k | https://www.youtube.com/watch?v=elqpTtfFD40 | Chapters: "Claude Design" for the look before the prototype, then a separate "Create The Map" bake-off between models |
| S17 | I Tested Every Roblox AI | Duckable | 2026-09-12 | 585k | https://www.youtube.com/watch?v=MBRNAqkDEFA | Biggest-reach comparison. Chapters suggest the GUI tools disappointed while Assistant and Claude came out ahead. Context only |
| S18 | figma-to-roblox-ui skill | xtrair | 2026-09-28 | n/a | https://www.skillsdirectory.com/skills/xtrair-figma-to-roblox-ui | Complex art goes in as images and is "never approximated with Frames". A validator script runs after every UI build |

Also found but low value for this question: LanceyPoo's "I Tried Making a Viral Roblox Game With AI"
(356k, iterative tweak passes, no detail), Developer Dank's "Cash Grab in 7 Days" (Claude Code plus
ForgeGUI), Scuppy's Opus 5.5 builds, and the many "how to connect Claude/Codex to Studio" setup
videos. The UI-design tutorials (Kek, Develuper, Kingkade) are already covered in
`UI_TUTORIAL_FINDINGS.md`.

---

## 2. What creators do to make AI-built Roblox games look good

### A. Process: split the jobs and give each its own rules

1. **One skill or agent per discipline, not one chatbot doing everything.** SyphoDev blames slop on
   "asking one AI to be a programmer, 3D modeller, UI designer and level designer all at once". His
   fix is a separate Claude Code skill for map design, UI, 3D, animation, VFX and code
   [S1 desc, S3 desc]. In his second game, a dedicated **VFX skill pass** is what fixed the weak
   visuals [S2 desc]. We already have `ui-critic` and `asset-artist`. We have nothing for the map,
   which is where Rufus's worst complaints are.
2. **The precision of the brief decides colour and material quality; the skill doesn't.** Across
   three A/B builds (skill vs no skill), colour and material quality was "good in all three" and
   tracked the brief. Briefs with explicit RGB values, material names and dimensions prevented spec
   errors whatever skill was used [S10 text, session log 2026-02-28 and 03-01]. Adjectives like
   "spacious" or "cool" count as *vague modifiers*. The map skill refuses to build until scale, gameplay topology and a zone list are
   defined [S10 text].
3. **Design first, then build.** AI PILLED runs a design step ("Claude Design") before the prototype
   [S16 desc]. SyphoDev generates **UI mockups** and 3D models only after a placeholder playtest
   [S1 desc, chapters "First playtest (placeholders)" then "Generating 3D models & UI mockups"].
4. **Fix one thing per prompt, with numbers.** "Shorten jump gap from 14 to 10 studs in config
   module". Single-system patches cycle in 3-7 minutes; multi-system rewrites tangle [S15 text].
5. **Part count is not quality.** The no-skill agent placed 2.5 times the parts (3,209 vs 1,188)
   and still lost on the user's visual rating [S10 text]. Don't judge a pass by "added 400 props".

### B. Maps: avoiding floating, wrong-scale and generic builds

6. **References, then multiple views, then passes, with a review after each stage** [S5 desc].
   Each building is split into passes. The agent builds and a person (or critic) reviews every
   stage before the next one. This is the same idea as the ohzw phases, but with a reference image
   driving each pass.
7. **Ground everything by raycast, and add a "skirt" where the ground slopes.** ShiroKSH's SceneSpec
   uses `grounding: {mode: "raycast", clearance: 0.05, support: "skirt"}` [S11 text]. "Skirt"
   means a support block filled down to the ground under an object on uneven ground, so nothing
   hangs over a drop. This is a better fix than just "drop it until it touches". On stepped stud
   terrain, a one-point drop leaves one corner floating.
8. **Every agent gets orientation wrong.** In ohzw's large farm-map test, all three agents produced
   wrongly rotated parts, and auditing every part's orientation at map scale was impractical. Their
   open idea is to **spot-check landmarks only** [S10 text]. For us: an "is it upright?" check on
   each placed Model's UpVector is cheap and catches tipped props.
9. **Build relative to an anchor, with named dimensions on a grid.** Use a "geometric manifest"
   (all sizes as named variables, no magic numbers), anchor-relative CFrames, and dimensions snapped
   to 0.25/0.5/1 [S10 text, spatial-patterns.md]. Their countermeasures report says named variables
   plus an integer grid plus a geometry summary header solve three LLM spatial failures at once:
   drift, coordinate precision, and losing track over long scripts [S10 text, countermeasures
   report].
10. **Re-acquire state on every call.** Each `execute_luau` call is a blank slate. Start each one by
    finding the map root and printing real CFrames before computing offsets. "If you lose track of
    where a zone is, DO NOT GUESS" [S10 text].
11. **Layout rules agents keep breaking:**
    - paths narrower than 6 studs force single file; main routes should be 10+ studs;
    - zones must differ in primary material, accent colour or landmark silhouette ("avoid identical zones");
    - every map needs an obvious destination [S10 text, S11 text].
12. **Check at avatar scale, not only from above.** "Check the route at avatar scale, not only from
    an exterior camera." Never declare a map visually ready from object counts or validation alone
    [S11 text]. A visual probe raycasts a grid from the viewport to report what is actually visible
    [S11 text].
13. **Use structured yes/no questions, not "does this look good?".** ohzw's countermeasures report
    cites CADCodeVerify: a vision model is more reliable answering **structured verification
    questions** ("is there a hole in the centre?") than giving a free-form critique [S10 text].
    Apply this to our screenshots, for example "is any prop's base visibly above the ground?" or
    "is the room's accent colour visible?".
14. **Fix lighting as its own pass.** SyphoDev has a dedicated "Map design & fixing lighting"
    chapter [S1 desc]. Roblox's lighting tutorial gives a worked set of values:
    - Ambient (16,16,16) for shaded interiors;
    - OutdoorAmbient (134,158,190);
    - ColorShift_Top (196,222,255);
    - ClockTime 9 for long, directional shadows;
    - ShadowSoftness 0 for crisp edges;
    - Atmosphere Density 0.375 and Offset 0.17 to blend the distance [S14 text].
    These are the tutorial's values for its own scene. Treat them as a starting point to tune for
    ours, not as our palette.

### C. 3D models: avoiding the lumpy look

15. **Short prompts.** "Over-detailing your prompt breaks Cube … too much specificity destroys the
    output." Assistant gives "ugly results when given too much detail" [S4 desc].
16. **Use a reference image for shape: 3/4 view on a white background.** The Roblox team's own tip
    [S4 desc]. Note that `/generate_mesh` takes text **or** an image, never both [S13 text]. Our
    STYLE_BIBLE template already asks for 3/4 view on light grey, which is close enough.
17. **Build a complex object from logical pieces.** PlayUGC calls breaking an object into pieces
    "the production-grade workflow", with an agent that "plans, builds piece by piece, screenshots,
    and verifies" [S4 desc]. The MCP `generate_mesh` tool supports this directly: `segmentation:
    "explicit"` plus `partNames` (up to 8), a `size` bounding box, and `maxTriangles` (12-20,000)
    [live tool schema; S13 text].
18. **Lower the triangle cap for a faceted, low-poly look.** "Lower values result in more faceted
    and low-poly generations" [S13 text]. Lumpy meshes come from smooth, high-poly organic output
    being decimated. For a blocky style, ask for the low-poly result directly instead of decimating
    a smooth one. (Our STATUS log: Meshy scenery "melted at low poly".)
19. **Pass a bounding box to fix scale at generation time.** Select a Part (or pass `size`) and the
    mesh fits that volume [S13 text]. Without it, assets come back at wildly different sizes, and
    Chen had to rescale every one against the player [S8 text].
20. **Compress the world bible into a locked prompt template.** Chen wrote 5 lines (materials,
    signature detail, palette, geometry style), then fixed a template with only two slots,
    `[OBJECT]` and `[USE CONTEXT]`. That gave about 80% consistency over 30 assets [S8 text].
    Ditchy does the same for UI art: the suffix "thick black outline, front-page simulator style,
    transparent background" is reused for every element [S6 desc].
21. **Name what you don't want.** "Clean surfaces, no ornamental carvings, mobile-friendly" [S9
    text]. Chen's outliers were extra filigree and the wrong hue [S8 text].
22. **Regenerate rather than repair, and fix colour in Studio.** Chen regenerated 6 of 30 assets
    (about 90 s each) and corrected hue in Studio (about 30 s each) instead of re-editing the
    geometry [S8 text]. Accept about 75% fidelity and iterate only on what matters [S4 desc].
23. **Hidden collision traps.** The default voxel or convex-hull collision put invisible walls
    inside walkable doorways [S8 text]. Set decor to Box, and set walk-through props to
    CanCollide false.
24. **Check every mesh for fused details, holes and thin parts** before it ships [S9 text].
25. **Upload route that avoids the 403 problem.** The Meshy Roblox Bridge desktop app sent GLBs
    straight into the Creator Hub inventory within seconds [S8 text]. (`ingame/MeshyRobloxBridge.exe`
    is already on this PC. Rufus must decide whether to run it.) SyphoDev uses Open Cloud with the
    key kept outside the chat [S3 desc].

### D. UI: avoiding the generic, too-big look

26. **Generate a mockup image as the spec, then rebuild natively.** ForgeGUI-style output "does not
    export a working ScreenGui". Creators "rebuild the interface in Roblox Studio" from the mockup
    [S7 text]. SyphoDev's pipeline also makes "UI mockups" first [S1 desc]. The mockup decides
    composition, hierarchy and focal point, which are the things agents get wrong. Our ToyUI kit
    then turns it into real parts.
27. **One locked style suffix for every UI element** (the Ditchy prompts) [S6 desc]. Change only
    the object and colour words.
28. **Real art stays an image.** "Detailed art and non-standard shapes are exported … as images …
    never approximated with Frames", and a validator runs after every build [S18 text]. Our ToyUI
    keeps frames for the brick stack and uses images for icons, which fits.
29. **Imported or AI UI needs a hierarchy and Z-index cleanup pass** [S7 text, quoting RoBuilder].

---

## 3. Implementation plan for Find The Diamond In The Coal

Ordered by how much each fixes Rufus's complaints (floating, wrong scale, generic maps; generic or
too-big UI; lumpy models), then the diamond moment. Every step follows CLAUDE.md:
- stop Play before editing;
- post a STATUS.md claim before touching shared Instances;
- never enter Play while a generation job runs;
- log every art spend.

**Shared verification kit (build this once, in step 1):**
- `ServerStorage.DevTools.Shots`: a ModuleScript listing about 12 named camera bookmarks, each a
  `camera_position` and `look_at_position`. Cover:
  - spawn
  - the plaza
  - the shop front
  - the mine entrance
  - each cave room from its doorway
  - the Furnace Hall
  - the collect pad
  - one avatar-height shot (camera Y = ground + 5) in each area
- Each check runs `screen_capture` with `capture_id` `<pass>_<shot>_before/after`.
- **R15 ScaleRef dummy.** Put a 5.2-stud R15 dummy at the look-at point while capturing, then remove
  it, so every screenshot has a human for scale [S8, S11].
- **Structured yes/no questions per shot [S10 #13].** Every answer must be "no" (or "yes" for the
  last two) before a pass counts as done:
  1. Is any object's base visibly above the ground?
  2. Is anything tipped or rotated wrongly?
  3. Is anything taller or shorter than expected next to the dummy?
  4. Is the zone's accent colour visible?
  5. Is there one clear focal object?

### 1. Write a precise look brief per zone, and get Rufus's sign-off before any rebuild

*Why:* brief precision decides colour and material quality [S10 #2]. "Generic" is a brief problem
first.

*How:*
1. `execute_luau` lists the cave zone keys from `ReplicatedStorage.MineProgress` (`ZoneName_<key>`)
   and each zone's bounding box from `Workspace.CoalNodes` by `Zone` attribute.
2. Write `docs/ZONE_BRIEFS.md`. Per zone, give:
   - primary material and colour as STYLE_BIBLE hex codes;
   - one accent (lava orange, crystal purple, crystal teal, lantern wood, gold-vein yellow);
   - the landmark silhouette and its size in studs;
   - floor, wall and ceiling heights;
   - the route width (10+ studs main, at least 6 side) [S10 #11].
3. Do the same for the surface: plaza, shop row, mine mouth.
4. Generate one reference image per zone with `art/gen_refs.py`, using a locked suffix [S8 #20].
5. Rufus approves the briefs and images.

*Verify:* the "before" contact sheet of all Shots, saved to `research_notes/shots/` or posted in
STATUS. That is the baseline every later pass is compared against.

### 2. Add a `map-critic` agent and a `map-qa` script

*Why:* the map is the one discipline without its own skill or critic [S1 #1]. Validation must be a
script [S10].

*How:*
1. Add `.claude/agents/map-critic.md`, modelled on `ui-critic`. Its inputs are the Shots captures
   plus the ZONE_BRIEFS entry. Its output is the yes/no answers from the shared kit, plus a ranked
   punch list.
2. Save `studio/map_qa.luau` in the repo, run through `execute_luau`. It reports:
   - floating gap > 0.25 studs (see step 3);
   - buried > 50% of height;
   - not upright (`UpVector.Y < 0.97` on a Model's pivot) [S10 #8];
   - unanchored decor;
   - off-palette colours (nearest STYLE_BIBLE hex distance > threshold);
   - non-Plastic materials;
   - doorways or tunnels narrower than 6 studs, using a clearance box sweep along the route.

*Verify:* the script prints a count per category. The pass target is 0 errors. Paste the output in
STATUS.

### 3. Fix floating props with raycast grounding plus skirts

*Why:* this is Rufus's top complaint. One-point drops leave corners hanging on stud steps [S11 #7].

*How:*
1. For every Model or Part in `VoxelScenery`, `CaveDecor`, `MineSystems`, town props and plaza
   tiles, get `GetBoundingBox()`.
2. Cast 5 rays straight down: 4 bottom corners inset 0.2, plus the centre. Exclude the object
   itself and its siblings in the same prop.
3. `gap = min(hit distance)`. Lower the object by `gap - 0.05`.
4. After lowering, if any corner's distance is still > 0.6 studs, build a skirt:
   - add a Plastic block under that corner in the ZONE_BRIEFS ground colour;
   - make it 2-stud grid sized;
   - parent it to the prop and name it `Skirt`.
   This replaces the old "Settled: dropped onto the ground" pass.
5. Re-run `map_qa.luau`.

*Verify:*
- the floating count is 0;
- screenshot the 10 objects with the largest original gap, at avatar height, before and after;
- the critic answers "no" to Q1 for every Shot.

### 4. Scale pass against an R15 dummy

*Why:* "wrong scale" [S8 #19, S11 #12].

*How:*
1. `execute_luau` measures, against 5.2 studs:
   - the height of each tree, rock and bush kit piece;
   - the shop doorways;
   - the furnace;
   - the cart;
   - coal node sizes;
   - cave tunnel widths and ceilings.
2. Write the numbers into a scale table in ZONE_BRIEFS, then fix the outliers. Resize props in
   whole-stud steps only, so stud tiles never land on a half stud. That rule is my inference from
   our 12 px / 1-stud grid, not something a source said.
3. Tunnels the cart follows through need 10+ studs [S10 #11].

*Verify:* an avatar-height Shot in each area with the ScaleRef dummy, the critic's Q3 answered
"no", and `character_navigation` (Client, in Play) walking from spawn to each zone and the furnace
without snagging.

### 5. Replace the lumpy models: kit pieces for scenery, segmented low-poly meshes for heroes

*Why:* the lumpy, melted look comes from decimating smooth AI meshes. Detailed prompts make it
worse [S4 #15, S13 #18].

*How:*
1. **Scenery** stays part-built, from the `PropLibrary` unions, because blocks are the style.
   Rebuild kit pieces with a geometric manifest (named dimensions, 2-stud grid) [S10 #9] so they
   can't come out lumpy.
2. **Hero props** (cart tiers, pickaxe tiers, the furnace details):
   - call `generate_mesh` with a **short** prompt in the locked template [S4, S8];
   - set `size` to the target bounding box from the scale table [S13];
   - set `maxTriangles` low: about 1,500 for a pickaxe, 3,000 for a cart, matching STYLE_BIBLE [S13 #18];
   - use `segmentation: "explicit"`, for example `partNames: "body, wheels, coal tray"` [S4 #17].
3. Generate 2-3 variants with `async: true`, keep the best, and recolour in Studio to palette hex
   rather than regenerating for hue [S8 #22].
4. Set CollisionFidelity to Box on all decor meshes [S8 #23].
5. If a Meshy route is still wanted, ask Rufus whether to use the Meshy Roblox Bridge app he
   already downloaded instead of the 403-blocked Open Cloud key [S8 #25].

*Verify:*
- a close-up turntable for each hero prop: 4 `screen_capture`s around it at 8 studs, with ScaleRef;
- the critic checks for fused details, holes and thin parts [S9 #24];
- log the triangle count via `execute_luau`;
- log every spend in `art/LEDGER.md`.

### 6. Make every cave room different, with one landmark visible from its doorway

*Why:* "generic" maps and identical zones [S10 #11]. References plus passes per area [S5 #6].

*How:* work one zone per pass, in the ohzw phase order (shell, landmark, fill, environment). For each
zone:
1. Recolour the shell to its brief.
2. Build one landmark from kit pieces, for example:
   - a lava fall with a glow PointLight;
   - a giant purple crystal cluster;
   - a teal crystal arch;
   - a timber mine-shaft headframe with lanterns.
3. Place fill props only along the walls, keeping the 10-stud route clear.
4. Add a chunky stud sign at the doorway with the zone name.
5. Review each pass with the critic before starting the next zone.

*Verify:* the doorway Shot for each zone shows its accent and landmark. The critic's Q4 and Q5 are
"yes". A side-by-side contact sheet of all zones should show no two rooms that read the same.

### 7. Lighting pass: sunny surface, glowing cave, never black

*Why:* lighting is its own pass for SyphoDev [S1 #14]. The STYLE_BIBLE says the cave is "never
pitch black".

*How:* stop Play, post a STATUS claim on `Lighting`, then:
1. **Surface.** Use the Roblox tutorial values as a starting point [S14]:
   - ClockTime about 9-10;
   - Atmosphere Density about 0.3, Offset about 0.17, sky-tinted to `#6EC6FF`;
   - Soft LightingStyle, which suits the toy look (see the playbook).
2. **Cave.** Use coloured PointLights on landmarks and lanterns (the 72 existing lights at 40-70%
   brightness), a warm ColorCorrection, and coloured (not black) fog.
3. Keep coal at `#3A3A4A` so it pops.

*Verify:* the same Shots before and after, in edit mode and in Play. Note "test on phone" for Rufus,
because Studio lighting can differ on device (playbook).

### 8. UI size audit as a script, before any restyle

*Why:* "too big" is measurable. Run a validator after every UI build [S18 #28].

*How:*
1. In Play (Client DataModel), use `execute_luau` to walk `PlayerGui`.
2. Divide each named element's `AbsoluteSize` by the root UIScale factor to get the size at
   1280x720.
3. Compare against the UI_RULES size table: rail button 48, money pill 192x48, cart bar 312x36,
   hotbar slot 60, and so on. Flag anything more than 10% over, any text under 14, and anything in
   the bottom corners.
4. Fix the values in the ToyUI or screen code.

*Verify:* the script reports 0 oversize elements. Take `screen_capture`s at 1920x1080 and at a
phone viewport, then run `ui-critic`.

### 9. Mockup-first UI for the HUD and the Upgrade Book

*Why:* agents make generic composition. A mockup used as a spec, then a native rebuild, fixes it
[S7 #26, S1].

*How:*
1. Generate one mockup per screen with `art/gen_refs.py`. Prompt with the stud-toy UI description,
   a locked suffix in the Ditchy pattern [S6 #27] adapted to our palette, and Rufus's hay-game
   Upgrade Book reference as the layout. No text in the image.
2. Rufus picks one.
3. The agent rebuilds it only through `ReplicatedStorage.Modules.ToyUI`, then does a
   hierarchy and Z-index cleanup [S7 #29].
4. Generate the icon set as one sheet with the same suffix and the existing background-removal
   pipeline.

*Verify:* a side-by-side of the mockup and an in-game `screen_capture`, the size audit from step 8,
then `ui-critic`.

### 10. Make the diamond find a real event

*Why:* it is the climax of a 60-minute run, and STATUS says the diamond-found flow is untested and
needs a debug trigger.

*How:* stop Play, add a `ServerStorage.DevTools.ForceDiamond` debug trigger (Studio only), then
build the sequence:
1. **Hit:** the coal shell bursts into stud debris.
2. **The diamond (`#7FE8FF`) rises:** a slowly spinning, hovering crystal, as in PlayUGC's crystal
   animation [S4]. Add a PointLight and a sparkle ParticleEmitter.
3. **A light beam** shoots up out of the mine and can be seen from the surface town.
4. **A server-wide banner** with the finder's name, built in ToyUI.
5. **A short camera pan** to the finder for everyone.
6. **The reward screen.**

Do a VFX-only pass after the logic works, as SyphoDev does [S2 #1].

*Verify:*
- in Play, fire ForceDiamond;
- `get_console_output` shows no errors;
- take screenshots at each beat: the burst, the hovering diamond, the beam from the plaza Shot, the banner;
- run with 2 clients if possible to confirm everyone sees it.

### 11. Telegraph the rare coal so the search feels alive

*Why:* a run is mostly searching. Rare finds (gold, platinum, rainbow) need to read instantly.
That follows from STYLE_BIBLE ("higher tiers glow") and the brief-precision rule [S10 #2].

*How:*
1. Rare units get a visible fleck colour (gold `#F5B800`, platinum `#D6E3F0`, rainbow cycling)
   and a faint sparkle emitter.
2. Each tier gets its own hit sound and pop.
3. Show a small toast in the shared ToyUI style.
4. Cleared rooms switch their doorway sign lantern from warm to green, so the team can see
   searched rooms in the world as well as on the minimap.

*Verify:* in Play, mine a forced rare unit and screenshot it. The critic checks it reads at 20
studs.

### 12. Close every pass the same way

*Why:* creators review after every stage [S5, S4].

*How:* each pass ends with:
- `map_qa.luau` at 0 errors;
- the Shots contact sheet before and after;
- critic answers;
- `get_console_output` clean in Play;
- a STATUS entry listing the exact Instance paths.

Don't report a pass as "added N props". Report the critic answers [S10 #5].

---

### Notes and open questions

- None of these sources covers a stud-voxel toy style built with AI specifically. The kit-plus-
  grid approach in steps 3-6 comes from the general map-skill evidence [S10, S11], applied to our
  STYLE_BIBLE.
- The `screen_capture` tool is described as "edit-time". Confirm it captures during Play before
  relying on it for steps 8 and 10. If it doesn't, use the `screen_capture` subagent type the live
  server lists.
- Procedural models regenerate when their attributes change [S12 docs]. That fits with STATUS's
  rule to convert them to plain Models before restyling.
