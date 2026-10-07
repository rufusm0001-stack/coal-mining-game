# Building Great-Looking, Performant Roblox Maps/Worlds (with AI Help)

Research date: 2026-10-07. Dates are given where sources show them. Each fact has a source link. Anything without a source is in "Inferences" or "Gaps".

## Level design principles (hub layout, sightlines, landmarks, guiding players, spawn, zone progression, density)

### Takeaway
I found no official Roblox level-design doc with numbers. Community and agent-skill sources agree on the simulator pattern: a central spawn hub with shops, display pedestals and clearly coloured paths, tall landmarks and sightlines that point to the next goal, natural boundaries such as hills and trees instead of invisible walls, and no empty dead space. Agent skills build maps in this order: layout, ground, zone shells, landmarks, fill, environment.

### Cited Findings
- Simulator map rules: players should always see something interesting, never empty walls or dead space. Use landmarks to navigate (tall buildings, unique structures, coloured areas), and use sightlines to guide players toward objectives. — [taozhuo map-design skill (playbooks.com)](https://playbooks.com/skills/taozhuo/game-dev-skills/map-design); [vibeindex mirror](https://www.vibeindex.ai/skills/taozhuo/game-dev-skills/map-design)
- Typical simulator hub layout: a central spawn platform (often stone or marble), shop stalls with striped awnings, display pedestals for pets and items, and clear paths in a different colour or material from the grass. Surrounding hills with trees act as visual boundaries, with several NPC vendors. — [taozhuo map-design skill](https://playbooks.com/skills/taozhuo/game-dev-skills/map-design)
- A good simulator area should be easy to understand quickly, with clear paths, separate sections, strong readability and open gameplay spaces. — same source (summarised by search; the full text did not render on [skills.sh](https://skills.sh/taozhuo/game-dev-skills/map-design))
- Phased agent build order for maps, arenas and lobbies via MCP: "Layout → Ground → Zone Shells → Landmarks → Fill → Environment". It uses an origin-relative coordinate system "to prevent floating-point drift", a folder hierarchy in Workspace, Lighting, Atmosphere and SpawnLocation setup, and a post-build validation script. — [ohzw/roblox-dev-skills (GitHub)](https://github.com/ohzw/roblox-dev-skills); [vibeindex listing](https://www.vibeindex.ai/skills/ohzw/roblox-dev-skills/building-maps)
- Zone-based culling for performance also shapes layout. Hide whole zones behind walls on the client (`Part.Parent = nil` per zone) and hide small details beyond about 300 studs using a spatial grid. — [MrChickenRocket, "Real world building and scripting optimization for Roblox", DevForum, 2024-08-20](https://devforum.roblox.com/t/3127146)
- Marketplace lobby and map kits sold for Roblox (for example "Stylized Tropical Spawn & Lobby Island", "Low-Poly Mining Camp Map") show that the commercial norm is a self-contained island or valley lobby. — [BuiltByBit tropical lobby](https://builtbybit.com/resources/stylized-tropical-spawn-lobby-island.114326/); [BuiltByBit mining camp](https://builtbybit.com/resources/low-poly-mining-camp-map-roblox.110053/)

### Inferences
- Combine these into a rule set for an agent:
  - Spawn faces the main progression direction.
  - The first upgrade, sell point or shop is visible from spawn without turning the camera.
  - One tall landmark per zone, visible from the hub.
  - Paths use a contrasting material.
  - Boundaries are natural (hills, cliffs, water, fences), never bare invisible walls.
  - Each new zone is gated (door, price wall, portal) and visible from the previous zone, so players can see what they are working toward.
- Designing in zones and walls (occlusion) helps both readability and performance, because it enables per-zone client culling and streaming.
- For a mining game: the hub sits on the surface, mine shafts are zones gated by depth, and caves are naturally occluded, which suits zone culling.

### Gaps
- I found no Roblox-official or RDC/GDC source with numeric rules for hub size, path widths or landmark spacing. The DevForum "How to Make a Simulator Map" and Ruski map-layout tutorials are referenced, but I did not fetch them.
- I found no published teardowns of how Pet Simulator 99 or Grow a Garden lay out their hubs.

## Character scale: R15 size vs props, doors and roads; scale reference table

### Takeaway
A default R15 character is about 5 to 5.2 studs tall. 1 stud is officially about 0.28 m, but builders often treat it as roughly 1 ft. Roblox characters are wide and blocky, so real-world proportions give rooms that feel too cramped. Size everything against a placed R15 dummy, not against real-world metres.

### Cited Findings
- R15 height is about 5.12 studs at idle and about 5.22 studs while moving. — [DevForum "Measurement Conversion"](https://devforum.roblox.com/t/measurement-conversion/137419) (via search summary)
- 1 stud = 0.28 m (about 11 in). Many developers still use 1 stud = 1 ft. With 1 stud = 1 ft, characters become "4 feet wide behemoths", so builders scale environments up. — [DevForum "Measurement Conversion"](https://devforum.roblox.com/t/measurement-conversion/137419); [cyberpost](https://cyberpost.co/how-tall-is-1-stud-in-roblox/)
- R15 body scaling ranges: height 95% to 105%, width 75% to 100% (wiki figure; may be outdated now that avatars can be much more varied). — [Roblox Wiki R15](https://roblox.fandom.com/wiki/R15)
- A common Studio move/snap grid is 0.5 studs. — search summary of [cyberpost](https://cyberpost.co/how-tall-is-1-stud-in-roblox/) (low-authority source)

### Inferences (practitioner conventions; NOT sourced. Verify in Studio with a dummy)

| Element | Suggested size (studs) | Reasoning |
|---|---|---|
| R15 character | ~5.2 H × ~2 W (shoulders) | sourced height; width approximate |
| Door opening | 4–5 W × 8–9 H | about 1.6 to 1.8 × character height; leaves room for hats and the camera |
| Ceiling / storey height | 10–14 | third-person camera needs room; real-world 3 m (about 10.7 studs) feels tight |
| Corridor / mine tunnel width | 8–12 | 2 players side by side plus camera; 6 is the minimum for one player |
| Stair step | 1 rise × 1.5–2 run | ordinary Humanoids step up about 2 studs, so 1 is safe |
| Footpath | 8–12 | readable from the top-down camera |
| Road (2-lane) | 24–30 | vehicles are typically 7–9 wide |
| Table / counter | 3–3.5 H | about waist height on R15 |
| Tree (stylised) | 15–40 H | chunky trunks of 2–4 studs read well |
| Pickup / ore node | 2–4 | must read on a phone screen |

- Common AI and novice scale mistakes: building to real metres (cramped interiors), doors at exactly character height, tiny props that disappear on mobile, and mixing assets from different kits that use different scales.
- QA rule: spawn a default R15 rig at each doorway or tunnel and run a Shapecast or GetPartBoundsInBox check that a 4×6×2 box fits through. Then playtest with automated `character_navigation`.

### Gaps
- I found no official Roblox doc giving door, ceiling or road dimensions. The table above is a convention, not a sourced fact.
- I could not confirm the modular-kit grid that Roblox uses in its environmental-art curriculum (the URL returned 404).

## Art-style consistency (style bible, stylised vs realistic, part-built look, materials, MaterialVariants, palettes)

### Takeaway
Consistency comes from a small fixed set of materials and MaterialVariants with consistent names, a locked colour palette, one LightingStyle, and reusing a single modular kit. Top simulators use a "Soft" (classic, diffuse) stylised look made from simple parts and low-poly meshes. I found no authoritative breakdowns of exactly how Bee Swarm, Pet Simulator or Grow a Garden achieve their look.

### Cited Findings
- Custom materials are MaterialVariant instances inside MaterialService. A part's MaterialVariant property stores the variant's *name*. "Set as Override" in Material Manager replaces a base material everywhere it is used, on parts and terrain. StudsPerTile and Pattern control tiling. — [Roblox Docs: Materials](https://create.roblox.com/docs/parts/materials)
- Recommended naming: PascalCase with the base material first, for example GrassWet, GrassDry, GrassBurned. Material collections that share names can be swapped as a whole ("adaptive materials"). — [Roblox Docs: Materials](https://create.roblox.com/docs/parts/materials)
- Square textures work best. PBR maps are ColorMap, Normal, Metalness and Roughness. — [Roblox Docs: Materials](https://create.roblox.com/docs/parts/materials)
- Texture size: 512×512 maximum unless the texture covers a large part of the screen; minor images should be under 256×256. Memory depends on pixel dimensions, not file size. — [Roblox Docs: Improve performance](https://create.roblox.com/docs/performance-optimization/improve)
- LightingStyle "Soft" is the "flatter-looking lighting with diffused shadows" (classic Roblox look). "Realistic" gives high-fidelity detailed shadows. Choose one as part of the style bible. — [DevForum: Unified Lighting is Fully Live, 2025-01-21](https://devforum.roblox.com/t/let-there-be-unified-light-unified-lighting-is-fully-live/3401512)
- Under Future (now Realistic), local lights give proper specular highlights, "so the material choice is more important than ever". — [DevForum Future is Bright Phase 3](https://devforum.roblox.com/t/future-is-bright-phase-3-released/878634) (via search summary)
- Reusing the same mesh with the same material batches into one draw call, even with different colour, rotation and scale. MrChickenRocket recommends making "your own general purpose reusable meshes for building with". This is both a style tool (one kit) and a performance tool. — [MrChickenRocket, DevForum 2024](https://devforum.roblox.com/t/3127146)
- Bee Swarm Simulator is by solo developer Onett and launched March 2018. Sources describe it only as "colourful". — [rowatcher](https://rowatcher.com/games/601130232) / search summary; no art breakdown found.

### Inferences
- A minimal style bible for an AI agent should contain:
  1. A palette of 8 to 12 hex colours, each with a role (ground, path, accent, interactable, danger).
  2. An allowed-materials list (for example SmoothPlastic, Grass, Slate, Wood, WoodPlanks, Neon only for interactables), plus named MaterialVariants.
  3. One modular kit with fixed grid and snap sizes.
  4. Bevel and roundness rules (all rocks chunky low-poly, no realistic meshes).
  5. Fixed values for LightingStyle, Atmosphere and ColorCorrection.
  6. "Never" rules: no Creator Store models with mismatched texel density, no realistic PBR next to flat SmoothPlastic.
- The flat-colour, simple-shape simulator look is mostly saturated SmoothPlastic or Grass parts, chunky low-poly meshes, a Soft LightingStyle, bright Atmosphere haze and mild ColorCorrection saturation. This comes from general observation, not a source.
- Agent check: list every distinct Material, MaterialVariant and BrickColor/Color3 used in the map, and flag anything outside the palette or allow-list.

### Gaps
- I found no reliable sourced breakdowns of the Bee Swarm, Pet Simulator 99, Grow a Garden or Prehistoric Farm art pipelines. Search results were SEO spam.

## Lighting (Future vs ShadowMap, now Unified Lighting; Atmosphere, ColorCorrection, Bloom; indoor and cave; day/night)

### Takeaway
As of January 2025, Roblox's **Unified Lighting** replaced the Technology dropdown with two settings:
- **LightingStyle**: Realistic or Soft.
- **PrioritizeLightingQuality**: on or off.

Old settings map across: Future becomes Realistic with quality on, ShadowMap becomes Soft with quality on, and Voxel becomes Soft with quality off. Advice telling you to "pick ShadowMap for mobile" is therefore dated. Use Soft for a stylised or cheaper look and Realistic for dramatic caves and local-light shadows.

### Cited Findings
- **Dated change (2025-01-21):** Unified Lighting is fully live. LightingStyle Realistic gives "High-fidelity lighting with detailed shadows and shading"; Soft gives "Flatter-looking lighting with diffused shadows". PrioritizeLightingQuality Enabled keeps lighting quality and cuts other things such as draw distance; Disabled cuts lighting quality first. The mapping is Future → Realistic + Enabled, ShadowMap → Soft + Enabled, Voxel → Soft + Disabled. — [DevForum announcement](https://devforum.roblox.com/t/let-there-be-unified-light-unified-lighting-is-fully-live/3401512)
- The old Technology options are no longer directly selectable in the Lighting service. Developers reported games looking darker after ShadowMap and Compatibility disappeared. — [DevForum thread](https://devforum.roblox.com/t/games-became-darker-since-shadowmap-and-compatibility-are-gone-for-unknown-reason/3847914?page=2); [DevForum Q](https://devforum.roblox.com/t/were-the-shadow-map-voxel-future-and-compability-lightning-types-deprecated/3516247); [Technology enum](https://create.roblox.com/docs/reference/engine/enums/Technology)
- How the engine works: Future added shadow-mapped per-pixel lighting for nearby lights on top of the voxel light grid. The per-pixel distance depends on the quality level, and unsupported devices fell back to ShadowMap, then to Voxel. — [DevForum Future is Bright Phase 3](https://devforum.roblox.com/t/future-is-bright-phase-3-released/878634) (pre-Unified; behaviour likely carried into Realistic)
- Performance: ShadowMap (now Soft) costs less than Future (now Realistic). Avoid shadow-casting lights on moving geometry. — [MrChickenRocket, DevForum 2024](https://devforum.roblox.com/t/3127146)
- Turn off CastShadow on small parts where shadows are unlikely to be seen, especially far from the camera. — [Roblox Docs: Improve performance](https://create.roblox.com/docs/performance-optimization/improve)
- The Lighting service groups its properties into Color, Intensity, Shadows, Appearance and Environment (Brightness, ShadowSoftness, LightingStyle, ClockTime, GeographicLatitude). — [Roblox Docs: Lighting](https://create.roblox.com/docs/environment/lighting)
- Known issue: ShadowSoftness is hidden when LightingStyle = Soft (Unified Lighting beta bug report). — [DevForum bug](https://devforum.roblox.com/t/unified-lighting-beta-shadowsoftness-lighting-property-does-not-appear-when-lightingstyle-is-set-to-soft/3509181)
- Lighting can look fine in Studio but bad in a live game, because of quality level and device differences. Test on a device. — [DevForum solved thread](https://devforum.roblox.com/t/my-lighting-works-well-in-studio-but-is-terrible-in-game-solved/3620334)

### Inferences
- Stylised simulator preset: LightingStyle Soft, a strong Ambient/OutdoorAmbient fill (so shadows are not black on phones), an Atmosphere with low Density and a light Haze in a tinted palette colour, ColorCorrection with saturation slightly up, and a subtle Bloom (low intensity, high threshold), so Neon interactables glow without washing out the scene.
- Caves and mines: Realistic gives shadows from local PointLight/SpotLight sources (lanterns, helmet lamps), which matters most in caves. Keep the number of shadow-casting local lights in view small, and set Shadows=false on decorative lanterns. Raise Ambient in caves using a local zone script, or use a ColorCorrection preset per zone, so mobile players can still see.
- Day/night: tween ClockTime. If Atmosphere and ColorCorrection presets change per time band, interpolate them too.

### Gaps
- I found no official mobile cost numbers comparing Realistic and Soft after Unified Lighting.
- The create.roblox.com "lighting technologies" page URL now returns 404, likely restructured after Unified Lighting.
- I did not fetch the official Atmosphere, Bloom or ColorCorrection doc numbers.

## Terrain vs parts; procedural generation; greedy meshing; snapping props to ground; validating "no floating objects"

### Takeaway
Use Smooth Terrain for organic ground and caves, and parts or meshes for built structures and stylised blocky worlds. Part-voxel worlds must use greedy meshing to merge adjacent same-material blocks, or part counts explode. Snap props with downward `Workspace:Raycast` calls (maximum length 15,000 studs), filtering out the prop itself, and validate programmatically after every AI build.

### Cited Findings
- Greedy meshing merges adjacent identical faces or blocks into larger boxes. A scene of about 10,000 parts can drop to a few hundred merged pieces. — [creation.dev explainer](https://www.creation.dev/learn/what-is-greedy-meshing-roblox-voxel-optimization) (secondary source); DevForum tutorials: ["How to make a Greedy Mesher"](https://devforum.roblox.com/t/how-to-make-a-greedy-mesher/474436), ["Consume everything - how greedy meshing works"](https://devforum.roblox.com/t/-/452717)
- Part-based terrain is generated in chunks and vertical slices, with greedy meshing to minimise parts. — [DevForum "Optimizing chunked terrain made of parts"](https://devforum.roblox.com/t/optimizing-chunked-terrain-made-of-parts/3730494)
- `Terrain:WriteVoxels` is the bulk API for procedural terrain; developers compare it with `FillRegion`/`FillBlock`. — [DevForum Region3 & Terrain](https://devforum.roblox.com/t/region3-terrain-questions/607467) (via search summary)
- Some developers complain that Smooth Terrain performance needs improving. — [DevForum "Optimize Smooth Terrain Better"](https://devforum.roblox.com/t/optimize-smooth-terrain-better/3781706)
- Raycast API: RaycastParams with FilterType (Exclude/Include), FilterDescendantsInstances, IgnoreWater and CollisionGroup. A RaycastResult has Instance, Position, Distance, Material and Normal. Maximum ray length is 15,000 studs. Parts with `CanQuery = false` are not hit. — [Roblox Docs: Raycasting](https://create.roblox.com/docs/workspace/raycasting)

### Inferences (agent snap/QA recipe; API facts from the Raycasting doc, algorithm not sourced)
- **Snap to ground:** for each prop, cast from `pivot + (0, 50, 0)` down 200 studs, excluding the prop itself and other props. Pivot so that the bounding-box bottom sits at `result.Position`. Optionally align up to `result.Normal` for rocks but not for buildings. Reject the placement if `result.Material` is Water or the Normal's Y is below about 0.7 (too steep).
- **Floating-object validator** (run after every build): for each anchored BasePart or Model in the map folder that is not tagged `AllowFloat`, cast down from the bottom-centre and from the 4 bottom corners of its bounding box. Flag it if the hit distance is more than about 0.25 studs. Also flag parts with no hit at all, which means they are over the void.
- **Buried/overlap check:** use `Workspace:GetPartBoundsInBox` per prop, flagging props that are mostly inside terrain or other props. This API is real but was not covered on the fetched page.
- **Other checks:** NaN or huge positions, parts below FallenPartsDestroyHeight, unanchored decor, duplicate overlapping parts (z-fighting: same CFrame and size), and spawns obstructed (raycast up 10 studs from each SpawnLocation).
- Terrain vs parts for a coal mine: Terrain gives organic cave walls and digging via `FillBall` with Air. A part-voxel mine needs greedy meshing and chunked streaming.

### Gaps
- I did not verify official docs for `Shapecast`/`Blockcast`/`GetPartBoundsInBox` (they were not on the fetched page).
- I found no source with official Terrain memory or performance numbers per voxel region.

## Performance budgets (parts, triangles, draw calls, StreamingEnabled, instance counts, MicroProfiler, unions vs meshes)

### Takeaway
Budget before you build. The official guideline is <1,000 draw calls and <1M triangles on a baseline device, with a 16.67 ms frame at 60 FPS. A respected community engineer targets **≤500 draw calls, ≤500k triangles in view, <1.3 GB client memory** for 60 FPS on 90%+ of phones. Reuse identical meshes so they instance into one draw call. Prefer Blender MeshParts over unions. Enable StreamingEnabled with Opportunistic stream-out.

### Cited Findings
- Official: example budget "stay below 1,000 draw calls and 1,000,000 triangles" on the baseline device. A 60 FPS frame budget is 16.67 ms. Choose and test on a "baseline" device throughout development. Roblox does not get all of a device's memory. — [Roblox Docs: Design for performance](https://create.roblox.com/docs/performance-optimization/design)
- Search summary of the same area: a stricter example is about 600 draw calls and 650k triangles in cluttered areas. Roblox has said 90% of devices can render 1M triangles at 60 FPS. — [Roblox Docs: Design for performance](https://create.roblox.com/docs/performance-optimization/design) / [DevForum "Best Triangle Count For Map"](https://devforum.roblox.com/t/best-triangle-count-for-map/3117069) (I did not verify which page each number came from)
- Community budget (MrChickenRocket, 2024-08-20) for 60 FPS on 90%+ of phones at Quality 10: **500k triangles and 500 draw calls in scene**, under 50 KB/s receive bandwidth (about 40 to 60 physics assemblies), **client memory <1.3 GB** (to support 2 GB phones). — [DevForum 3127146](https://devforum.roblox.com/t/3127146)
- Per-asset guide: about 250 to 2,000 triangles per object mesh. NPCs get about 50% to 75% of a player character's triangle count. — [DevForum "Best Triangle Count For Map"](https://devforum.roblox.com/t/best-triangle-count-for-map/3117069) (via search summary)
- Instancing: identical meshes sharing MeshContent and SurfaceAppearance collapse into one draw call. "Only upload each mesh in a map once and then duplicate them in Studio" rather than importing a whole map as one file. — [Roblox Docs: Improve performance](https://create.roblox.com/docs/performance-optimization/improve)
- Parts with the same mesh ID and material batch together despite different colours, rotations and scales. You can bake multi-part assemblies into one mesh with Export Selection. — [MrChickenRocket DevForum](https://devforum.roblox.com/t/3127146)
- CollisionFidelity: Box has the lowest memory and suits small or non-interactive objects. Hull is recommended for small and medium objects. Default and Precise use much more memory. Use invisible simple parts as custom colliders. — [Roblox Docs: Improve performance](https://create.roblox.com/docs/performance-optimization/improve)
- Overlapping partly transparent objects cause overdraw. Too many parts in one Model can trigger rebuilds. Set Model.LevelOfDetail to SLIM (StreamingMesh) for distant imposters. — [Roblox Docs: Improve performance](https://create.roblox.com/docs/performance-optimization/improve)
- Streaming defaults: StreamingTargetRadius 1024 and StreamingMinRadius 64 (keep 64 for low-end devices). ModelStreamingMode can be Nonatomic (default), Atomic, Persistent or PersistentPerPlayer. StreamOutBehavior: LowMemory (default) or **Opportunistic (recommended, "significantly reduce memory usage and help prevent out-of-memory crashes")**. Pitfall: client scripts must `WaitForChild` because Nonatomic parts may not have arrived yet; Atomic and Persistent guarantee descendants arrive together. — [Roblox Docs: Instance streaming](https://create.roblox.com/docs/workspace/streaming)
- Unions vs meshes: Roblox's CSG produces more triangles than an equivalent Blender mesh, and unioning plain parts usually *increases* polygons. The exception is cutting holes, especially cylindrical ones. Community consensus: use Blender MeshParts. — [DevForum "Unions vs MeshParts 2023"](https://devforum.roblox.com/t/unions-vs-meshparts-2023/2638232); [DevForum "Do unions reduce lag"](https://devforum.roblox.com/t/do-unions-reduce-lag/476186)
- Reported example: a per-mesh triangle limit exists, and developers have asked for it to be raised. — [DevForum "Increase the max triangle limit"](https://devforum.roblox.com/t/increase-the-max-triangle-limit/4650221) (I did not fetch the limit value)

### Inferences
- Practical agent budget for a mobile-first simulator:
  - ≤500 draw calls and ≤500k triangles in any camera view.
  - Client memory <1.3 GB.
  - About 10k to 20k streamed-in BaseParts near the player (inference).
  - StreamingEnabled on, Opportunistic, MinRadius 64.
  - Hub and landmarks Persistent or Atomic.
  - Decor CastShadow=false, CanCollide=false, CanQuery=false, CanTouch=false.
  - Collision Box or Hull.
- Checking: use Ctrl+F1/Shift+F2 render stats and the MicroProfiler (Ctrl+Alt+F6) on a real phone. Look for draw-call and triangle counts per view, and for long "Render"/"Perform" bars. These shortcuts come from general Roblox knowledge and are not verified in sources this session.

### Gaps
- I found no official per-mobile instance-count ceiling, and no official MicroProfiler label guide was fetched.

## AI-assisted map building workflows, pitfalls, and automated QA

### Takeaway
As of 2026, AI can drive Studio through Roblox's **built-in MCP server**. The standalone open-source `studio-rust-mcp-server` was archived on 2026-04-03. Roblox's Cube model offers text-to-mesh (beta since March 2025) and "4D" functional-object generation (public beta, 2026-02-04). Full scene generation is still research. AI "slop" is best prevented by structure: a style bible, a fixed kit, phased builds, origin-relative coordinates, and a validation script plus screenshots after every phase.

### Cited Findings
- The official open-source Roblox Studio MCP server (Rust) was **archived on April 3, 2026**, in favour of a "built-in MCP Server included with Roblox Studio". The old server's tools were run_code, insert_model (from the Creator Store), get_console_output, start_stop_play, run_script_in_play_mode and get_studio_mode. Caveat: third-party tools can read and modify the open place. — [GitHub Roblox/studio-rust-mcp-server](https://github.com/Roblox/studio-rust-mcp-server)
- In February 2026, Roblox updated the Studio MCP and Assistant with agentic features and support for external LLMs (Claude, Gemini, ChatGPT). Assistant includes a built-in MCP client. — [creation.dev](https://www.creation.dev/learn/roblox-studio-mcp-server-assistant-updates); [MoguraVR](https://www.moguravr.com/roblox-studio-mcp-server-agentic-update/) (secondary sources)
- Cube 3D: an open-source text-to-mesh model (GitHub and Hugging Face), with a mesh generation API in beta in Studio and in-experience, announced March 2025. — [Roblox newsroom, Introducing Roblox Cube, 2025-03](https://corp.roblox.com/newsroom/2025/03/introducing-roblox-cube); [Wikipedia: Cube 3D](https://en.wikipedia.org/wiki/Cube_3D)
- 4D generation (beta, 2026-02-04): generates functional objects using schemas (launched with Car-5 and Body-1), with script retargeting to the object's dimensions. Full scene generation ("assets, environments, code, animations") is described only as being explored, with no date. — [Roblox newsroom 2026-02](https://about.roblox.com/newsroom/2026/02/accelerating-creation-powered-roblox-cube-foundation-model)
- Community agent skills for MCP map building: the 6-phase pipeline (layout → ground → zone shells → landmarks → fill → environment), origin-relative coordinates against float drift, folder hierarchy, post-build validation script, and a design-consultant skill that gathers requirements through dialogue before building. — [ohzw/roblox-dev-skills](https://github.com/ohzw/roblox-dev-skills); [skillsmp listing](https://skillsmp.com/creators/ohzw/roblox-dev-skills/claude-skills-building-maps)
- Observed directly (not a web source): the Roblox_Studio MCP connected in this user's environment (Oct 2026) exposes, among other tools, `generate_procedural_model`, `generate_mesh`, `generate_material`, `generate_texture`, `insert_asset`/`search_asset`, `screen_capture`, `character_navigation`, `start_stop_play`, `execute_luau`, `multi_edit` and `get_console_output`. These support a build → screenshot → playtest-walk → fix loop.

### Inferences (recommended agent workflow and QA)
1. **Spec first:** a style bible (palette, materials, kit, LightingStyle), a scale sheet (dummy-based), a zone graph, and a budget (draw calls, triangles, parts per zone).
2. **Greybox:** build the layout in neutral parts on a grid, with all coordinates relative to a map origin CFrame. Place an R15 dummy in every zone, take a screen_capture, and check the sightlines from spawn.
3. **Kit, not freeform:** the AI places pre-made kit pieces (from the user's own meshes, uploaded once and cloned for instancing) instead of inventing geometry from loose parts, which is where floating objects and wrong scale come from. Treat generated meshes (generate_mesh / Cube) as hero props only, then normalise their scale to the scale sheet and set their CollisionFidelity.
4. **Scatter procedurally:** use a seeded RNG, Poisson-disk spacing, raycast snap, slope and material filters, and an exclusion radius around paths and spawns.
5. **Run automated QA after each phase** (execute_luau), reporting counts plus a list of offending instances:
   - floating check (bottom-corner raycasts, >0.25 stud gap)
   - buried or overlapping check
   - z-fighting duplicates
   - unanchored static decor
   - off-palette colours and off-list materials
   - scale outliers (Model bounding-box height vs an expected range per tag)
   - doorway and tunnel clearance boxes
   - SpawnLocation clear of obstacles and facing the progression direction
   - total parts, MeshParts, unions, and unique MeshIds (instancing ratio)
   - CastShadow and CanCollide on tiny parts
   - StreamingEnabled settings
   - lights: count of shadow-casting local lights per zone
6. **Visual QA:** take screen_capture from fixed camera bookmarks (spawn, each zone entry, top-down), plus a `character_navigation` walk from spawn to each zone goal to catch blocked paths.
7. **Device QA:** check render stats and the MicroProfiler on a real low-end phone against the budget. The human signs off on style.
- Pitfalls to tell the agent about: float drift and rounding (snap to a 0.5 or 1 stud grid), Creator Store models with scripts or mismatched style (prefer the user's kit, and scan inserted models for Scripts), CSG unions used as a shortcut (high triangle count), invisible giant colliders, and lighting tuned in Studio that looks wrong on device.

### Gaps
- I found no official documentation of the built-in Studio MCP tool list, and no Roblox guidance on AI-generated map QA.
- I found no RDC 2025 talk transcript on environment art or level design.
- creation.dev and MoguraVR are secondary sources. I did not fetch the official DevForum announcement of the February 2026 MCP and Assistant update.
