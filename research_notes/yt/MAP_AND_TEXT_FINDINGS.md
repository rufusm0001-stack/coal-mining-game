# Map and text findings: what YouTube tutorials teach (researched 2026-10-10)

For "Find The Diamond In The Coal" (colourful stud-voxel toy style, built by AI agents through the
Studio MCP). Companion files, not repeated here:
- `UI_TUTORIAL_FINDINGS.md`: ScreenGui buttons, panels and the flat UI text recipe (Fredoka One,
  stroke 3-5, hard shadow).
- `AI_GUIDES_FINDINGS.md`: the AI pipeline (skills per discipline, scale sheet, map-critic, grounding).

## How much of this is evidence

**vidIQ credits ran out after 9 transcripts.** The free plan has 150 credits a month, and they renew
on 2026-11-10. Searches cost 5 credits each and transcripts 5 each. The saved transcripts are in
`research_notes/yt/vidiq/<id>.txt`. Each point below has a tag that says where it came from:

| Tag | Meaning |
|---|---|
| `[T:code]` | From a saved transcript. This is the strongest evidence. |
| `[D:code]` | From the video's own description or chapter list only. The video wasn't watched. |
| `[UI:code]` | From the earlier transcripts in `yt/ui/`, already summarised in UI_TUTORIAL_FINDINGS.md. |
| `[Studio]` | Default values I read from fresh, unparented instances in Studio. Nothing was changed. |
| `[Web]` | From a DevForum post. |
| `[synth]` | My own synthesis, not from a source. Treat it as a proposal. |

**Coordinator correction (applied).** Rufus rejected the "Anime Outfits" text look and the fake
3D effect made by stacking copies of a label. Section 4 is now about **real 3D text**. Anime Outfits
is only his reference for **map layout**: an avenue leading to a gate, lined with booths. That is
section 2.3.

---

## 1. Sources

### 1a. Transcripts pulled (9)

| Code | Title | Channel | Date | Views | URL |
|---|---|---|---|---|---|
| KK10 | 10 Building Tip You Need To Know In Roblox Studio | Kingkade 3D | 2026-06-13 | 22.5k | https://www.youtube.com/watch?v=J57CWAn7-34 |
| ICE5 | 5 Building Tips to Transform Your Roblox Games | Ice Guy | 2026-07-28 | 11.2k | https://www.youtube.com/watch?v=7kqghm8oqa8 |
| COKE | 10 Roblox Studio Tips to Build Like a Pro | C0K3 | 2026-03-12 | 15.6k | https://www.youtube.com/watch?v=p1c9iU2mQ6U |
| DEV-L | Make Your Roblox Game Look 10x Better With Lighting | Develuper | 2026-04-21 | 204k | https://www.youtube.com/watch?v=vkEXLmRAQgs |
| RILEY | Give me 2 minutes and I'll fix your lighting FOREVER (cartoony simulator) | Rileybytes | 2025-04-01 | 54k | https://www.youtube.com/watch?v=06KmD8aNJ5o |
| M8 | How to make CARTOON LIGHTING in Roblox Studio | Gamer M8 | 2023-02-11 | 282k | https://www.youtube.com/watch?v=YIyir52FiYo |
| HAPY | How to Build PRO Roblox Maps! (simulator hub in 1 hour) | DeHapy | 2024-05-05 | 228k | https://www.youtube.com/watch?v=I-AB6pJ-y5g |
| ROB-SIM | How To Make Good Simulator Maps... | RoBuilder | 2021-10-05 | 176k | https://www.youtube.com/watch?v=Y3eUDs3FFGQ |
| VAIN | Building The 3 Best Roblox Art Styles (classic stud / low poly / realistic) | VainOath | 2024-06-28 | 39k | https://www.youtube.com/watch?v=3KBgLxPV-8E |

### 1b. Strong videos found but not pulled (description only, or pull after 2026-11-10)

| Code | Title | Channel | Date | Views | URL | Why |
|---|---|---|---|---|---|---|
| ROB-HUGE | How to Plan and Build HUGE Maps | RoBuilder | 2021-11-09 | 107k | https://www.youtube.com/watch?v=eRnnjqVOq7c | Big-map planning. Its transcript call failed on credits. |
| DBE-ST | the ULTIMATE stylized tutorial for ROBLOX studio | DatBoiEle | 2025-12-13 | 70k | https://www.youtube.com/watch?v=YG-IZoKAaQI | Stylized look |
| DBE-MAP | I just figured out how ALL ROBLOX games make their MAPS | DatBoiEle | 2026-04-23 | 36k | https://www.youtube.com/watch?v=wmB8BW4y5EA | Kit-bash workflow |
| HOLLY-T | How to Make Realistic Terrain | HollyHollers | 2026-01-23 | 46k | https://www.youtube.com/watch?v=Ye1zLeYa7qE | Terrain |
| RWS | How I Do Lighting & Atmosphere in Roblox | RingWorld Studio | 2026-02-07 | 43k | https://www.youtube.com/watch?v=UlvSrWHESwA | Atmosphere |
| BONES-VFX | Building Tutorial: Using VFX with lights | BONES | 2025-08-08 | 100k | https://www.youtube.com/watch?v=NFFs16r5qYw | Glow, flare and beam on lamps (lantern avenue) |
| ARK | Making A PROFESSIONAL Roblox Horror Game | Ark Hannold | 2024-09-15 | 212k | https://www.youtube.com/watch?v=otmZVVnmzqM | Horror |
| SYPHO | How to Make a Roblox Game With AI (Claude Opus 5.5 Full Tutorial) | SyphoDev | 2026-10-04 | 86k | https://www.youtube.com/watch?v=afuKhenJldY | Claude Code skills, Studio MCP, Open Cloud model upload |
| PILLED | ChatGPT vs Claude Make A Viral Roblox Game | AI PILLED | 2026-09-28 | 207k | https://www.youtube.com/watch?v=elqpTtfFD40 | Has a "Fable 5.1 vs GPT 6 Astra create the map" chapter |
| AXELL | Which AI Creates the Best Roblox Maps? Claude vs Gemini | MrAxell | 2026-02-23 | 16k | https://www.youtube.com/watch?v=hxv0MGEcJug | Procedural map generation |
| SCUP-E | Can Claude Make A VIRAL Roblox Game? | Scuppy | 2026-08-26 | 54k | https://www.youtube.com/watch?v=JkA-sl5f5us | Scale bug |
| SCUP-C | I Asked Opus 5.5 To Make My DREAM Game! | Scuppy | 2026-10-03 | 62k | https://www.youtube.com/watch?v=IFtKCN8jw6o | AI city build |
| TEF | Building Viral Roblox Game w/ AI | tef | 2026-06-22 | 248k | https://www.youtube.com/watch?v=Si8T9D-kPBY | Milestones, with world building last |
| 3DT-CT | How to make 3D text in Roblox Easily (ThreeDText 2) | Cookie Tech | 2024-05-27 | 23k | https://www.youtube.com/watch?v=-lT2hD7Md00 | 3D text plugin |
| 3DT-DB | This Roblox Plugin Makes 3D Text EASY | DevBlox | 2025-09-13 | 16k | https://www.youtube.com/watch?v=y7S_T1czFR0 | Same plugin |
| 3DT-BL | 3D TEXT (Any Font!) Roblox/Blender | coffeeboi | 2021-09-11 | 7k | https://www.youtube.com/watch?v=-1A-jZTNXtU | Blender extruded text into Roblox |
| SIGN | How to Make Sign Text (SurfaceGui) | Squidingz | 2023-02-19 | 104k | https://www.youtube.com/watch?v=SEFbQ2H_on8 | World signs |
| GRAD | How to Use UI Gradients with Backgrounds, Text, and Borders | Bigbfromcle | 2023-06-23 | 14k | https://www.youtube.com/watch?v=1StNnFIvQDQ | Gradient rules |
| GFX-S | how PRO designers use UIStroke | gfxcomet | 2025-08-05 | 140k | https://www.youtube.com/watch?v=fGi6mpXjUG0 | Strokes |

Written sources: the ThreeDText 2 DevForum post
(https://devforum.roblox.com/t/threedtext-2-plugin-create-text-with-meshparts/290144) and Ruski's
"How to design a map layout" (https://devforum.roblox.com/t/277853/1).

**Gaps.** No usable obby or tycoon map tutorial turned up: the searches returned shorts and
gameplay guides. There is no transcript for horror or terrain. No video covers "avenue/market
street" layouts directly, so section 2.3 is pieced together from the hub videos plus my own
synthesis.

---

## 2. Map techniques

### 2.1 General rules (every genre)

**Order of work**
1. **Fix lighting before building.** "Before we do anything else we got to fix this lighting"
   [T:HAPY]. Plan the lighting while planning the build, not last [T:COKE].
2. **Block out large shapes across the whole map first, then detail.** KK built a whole area from
   just **2 ground-piece variants** before adding any props. Don't finish one corner at a time
   [T:KK10].
3. **Place placeholder blocks for every point of interest (POI) before any art.** RoBuilder uses
   pink blocks [T:ROB-SIM]. DeHapy picks the spawn and POIs first, then brings in assets [T:HAPY].
4. **Detail from big to small.** Big trees at the borders, then large rocks, then grass clumps,
   then small trees in the interior. "Start with the larger filler parts first so … I don't overdo
   the filler" [T:HAPY].

**Scale and grid**
- Check scale against an avatar so doors fit [T:COKE].
- Pick **two increments and stick to them**, e.g. **0.1** and **2** studs. Too many increments
  stop parts lining up [T:COKE].
- Classic stud style: **1-stud snap, 90° rotation only, no model scaling** [T:VAIN].
- Low-poly style: **0.25-stud snap**, scaling allowed [T:VAIN].
- Map footprints:
  - simulator hub ground **250x250 to 300x300** [T:ROB-SIM], **250x250** [T:HAPY]
  - classic-style scene **100x100** [T:VAIN]
  - low-poly scene **200x200** ("scales to the player much better") [T:VAIN]

**Colour**
- Cartoony means high saturation [T:COKE].
- Use the RGB `Color` property, not the BrickColor palette, so shades stay controllable [T:COKE].
- **Three shades per surface.**
  - Paths: light base, dark accents, mid-tone.
  - Grass: 2 shades.
  - Tree leaves: about 4 colours.
  - "If they were all the same, it just wouldn't look as good" [T:KK10].
- **One contrast colour per zone.**
  - Yellow player plots on a green map.
  - A pond to add blue.
  - Grass and vines inside a brown mine [T:KK10].
  - DeHapy added a waterfall "to get some additional colors … other than the brown and green", and
    recoloured parts where there was "too much green" [T:HAPY].
- Randomise colours by script: apply a small tone-variation palette to each part's base colour.
  The same works for textures: pick 3-4 similar ones and loop over the faces [T:DEV-L]. That
  suits an agent.

**Props**
- **Cluster props, never scatter singles.** Duplicate, nudge, rotate slightly, scale one copy up.
  Make several clusters around the map [T:KK10].
- **Reuse one prop at several sizes.** "No specific size these crates have to be" [T:KK10].
- Tweak rotation and scale slightly so nothing looks uniform [T:ICE5].
- **A small reusable kit beats a spray of random assets**, for performance and tidiness [T:ICE5].
- Fill containers: no empty shelves [T:ICE5].
- Dress floors and ceilings too: decals, stains, pipes, small parts [T:ICE5].
- Detail density: "detail the map until you literally can't detail it anymore" [T:ROB-SIM].
  Balance that with the next rule.
- **Put detail on the edges, keep the centre open.** Players shouldn't feel cramped. Detail goes
  in the background (mountains, landmarks), with only a little in the middle. Horror is the
  exception [T:KK10].

**Height and silhouette**
- Vary ground height: hills "every once in a while" ("nobody does this") [T:ROB-SIM].
- Build walls and cliffs from the same piece at different heights and scales, never a flat run
  [T:KK10].
- Add small in-between ledges to stepped drops [T:KK10].

**Borders**
- Don't build the stacked-brick box border [T:ROB-SIM].
- Never make the map exactly square. Curve or cut the corners and vary the depth of border pieces
  [T:ROB-SIM].
- Use water, dense forest or cliffs instead [T:ROB-SIM].
- If you do use border parts, **duplicate the whole ring as a second layer**. That's "such an
  easy way to make the map look much more complete" [T:HAPY].

**Landmarks and story**
- Have big landmarks and small ones (a bridge, a little vignette) [T:KK10].
- Add "storyline" props: a crane lifting crates, a rusty crashed tractor sunk into rock, side paths
  someone once walked [T:KK10].

**Sightlines**
- In rooms, break the line of sight with a wall or a crate stack so players can't see everything on
  entry [T:ICE5].
- Always show something intriguing; avoid blank walls; prefer horseshoe or loop shapes over boxes
  [Web:Ruski].

**Paths**
- Build curves with the **Archimedes** plugin.
- **Never change the arc angle partway through a path.** It keeps the style consistent.
- Use a big loop path around the map plus inner spurs to each POI.
- Make one "grand" path to the main destination (the portals) [T:HAPY].

**Lights inside builds**
- Use an invisible part with a SurfaceLight, copy-paste it, and compose with the shadows [T:ICE5].

**Materials**
- Using the same material everywhere looks dull, so mix 2+ [T:ICE5].
- Unions cost triangles and lag [T:COKE].

### 2.2 Simulator / lobby hub (the main genre template)

**Spawn position**
- Most games put the spawn in the centre. Corner spawns also work, with players working outward
  [T:ROB-SIM].
- DeHapy prefers a corner or side spawn "so that the player could be guided across the map"
  [T:HAPY].

**What goes where** [T:ROB-SIM], [T:HAPY]
- Leaderboards: next to spawn.
- Spin wheel, shop and starter eggs: next to spawn.
- Showcase pet (the monetised "Titanic pet"): at spawn.
- Eggs: a bit away from spawn, "to give players a reason to leave this area".
- Shop: opposite the eggs, so the two sides are "buy" and "play".
- King of the Hill and dungeons: in other corners, so players explore.
- VIP: in its own area.
- Portals: on their own platform at the end of the grand path.

**What the spawn sees**
- From spawn the player should see several POIs **plus one mystery path**: "what happens if I go
  down this path?" [T:ROB-SIM].
- Aim for an open-world feel, not a box [T:ROB-SIM].

**Ground**
- Platforms for the POIs. Swap the default circular plaza for a custom curved shape plus a darker
  inset section [T:HAPY].
- Fill large flat green areas with terrain pieces and put rocks at their base as a transition
  [T:HAPY].

### 2.3 Avenue / market-street hub (Rufus's Anime Outfits reference) [synth from the sources above]

No tutorial covers this layout directly. Each rule is mapped to the evidence it adapts.

1. **Spawn facing the gate.**
   - Spawn at one end. The camera faces down the avenue to a **big gate** at the far end.
   - That's DeHapy's side spawn that guides players across [T:HAPY], plus a destination visible
     from spawn [T:ROB-SIM].
   - The gate is the landmark at the end of the view [T:KK10]. Keep that view down the avenue
     unblocked. Ice Guy's "break the sightline" rule is for rooms, not for the main avenue.
2. **One avenue that is the grand path** [T:HAPY].
   - Proposed avenue width **24-32 studs** of walkable centre [synth: about 8-10 avatar widths;
     check with the scale sheet].
   - Build it in a 3-shade paving pattern [T:KK10].
   - Never change the curve angle partway; a gentle S-curve is better than dead straight
     [T:HAPY], [Web:Ruski].
3. **Booths on both edges, centre open.** This is KK's "detail on the edges, not the centre"
   [T:KK10].
   - Booths cluster in groups of 2-4 with small gaps or side alleys between groups, not as an
     evenly spaced row [T:KK10] (clusters).
   - Each booth reuses one kit at different sizes and roof colours [T:KK10], [T:ICE5].
   - Shelves and counters are filled, never empty [T:ICE5].
   - Every booth has one contrast accent colour [T:KK10].
4. **Lanterns along the path.**
   - Space them at a steady rhythm, proposed every **12-16 studs** on alternating sides [synth].
   - Each lantern: a neon/glass head plus PointLight. Add glow/flare/beam VFX per BONES-VFX
     [D:BONES-VFX].
   - On a sunset or night clock time, the lanterns become the guide line.
5. **Open landscape around the avenue.** Behind the booths, open rolling ground with hills
   [T:ROB-SIM], tree and rock clusters [T:HAPY] and distant mountains or landmarks as background
   detail [T:KK10]. No box border: curve it, use water or a forest edge [T:ROB-SIM].
6. **Themed districts in a row.**
   - Each district is a stretch of avenue with its own colour pair and one landmark.
   - Each one ends at its own gate or arch that frames the next district (a chain of
     destinations), so the player always sees the next goal [Web:Ruski "something intriguing"].
   - Put one side path or mystery branch per district [T:ROB-SIM].
7. **Where the POIs go.** Shop and leaderboards near spawn. Paid or rare booths deeper down the
   avenue, which gives a reason to walk [T:ROB-SIM]. The VIP booth sits on its own side spur
   [T:HAPY].

### 2.4 Classic stud / toy style specifics

- Put studs on top surfaces with the **Resurface** plugin, or by setting surface properties.
  Develuper uses the **Studs MaterialVariant** on the baseplate [T:VAIN], [T:DEV-L].
- Keep Shadows on and Technology = ShadowMap for "modern classic" [T:VAIN].
- In a saturated style, transparent water and LightEmission make things look more cartoony.
  Watch water turning neon under high saturation [T:VAIN].
- VainOath's recommendation: classic for beginners, low-poly for intermediate builders. Low-poly
  looks "more like plastic … more cartoony" [T:VAIN].

### 2.5 Lighting recipes

**Cartoony simulator preset.** RILEY (2025) and M8 (2023) use near-identical values. Where they
differ, M8's value is in brackets.

| Lighting property | Value |
|---|---|
| Ambient | **200,160,225** (purple) |
| Brightness | **2.5** [2] |
| ColorShift_Top | **215,190,135** |
| ColorShift_Bottom | black |
| EnvironmentDiffuseScale | **0.4** [0.3] |
| EnvironmentSpecularScale | **0.5** [0.25] |
| GlobalShadows | on |
| OutdoorAmbient | **125,100,150** |
| ShadowSoftness | **0.2** |
| Technology | ShadowMap |
| ClockTime | **14** |
| GeographicLatitude | **40** |
| ExposureCompensation | 0 |
| FogColor | **200,170,250** |
| FogStart | 0 |
| FogEnd | **2500** |

Other steps in the preset:
- **Delete Atmosphere** (Riley). Fog doesn't apply while an Atmosphere exists.
- Delete the default Sky, Bloom, DepthOfField and SunRays (Riley).
- Add a **ColorCorrection**: Brightness **0.05**, Contrast **0.1**, Saturation **0.15**, Tint white.
- Sky: a Creator Store "sunless blue sky" (Riley), or an "afternoon" sky from the Atmos plugin (M8).

**Stylized preset (Develuper 2026)** [T:DEV-L]
- LightingStyle = **Realistic** ("gives your game much better shadows").
- Atmosphere Density **0.3-0.4**, Offset **0**, a little light-coloured Glare, a little darker Haze.
- Raise Bloom; add a little SunRays (late afternoon or sunset).
- ColorCorrection is "the most important": a soft light-blue tint, more saturation, and above all
  **more contrast**.
- Retro look: a **Highlight** outline on characters. Configure it so it doesn't show through walls.

### 2.6 Horror, obby, tycoon (thin evidence)

- **Horror.**
  - Claustrophobic prop density is fine here, unlike other genres [T:KK10].
  - Break sightlines, dress floors and ceilings, light with SurfaceLight pools and shadows [T:ICE5].
  - Fuller recipe: watch ARK and RWS later.
- **Obby and tycoon.** No tutorial with layout substance found. Apply the general rules: big
  shapes first, 3-shade paths, a contrast colour for player plots [T:KK10] (yellow plots on green).

---

## 3. Building maps with AI

From descriptions, plus `AI_GUIDES_FINDINGS.md`, which has the detailed version.

**What creators do**
- **One skill per discipline** (map, UI, 3D, VFX). Claude Code drives the Studio MCP; Rojo holds the
  code; an Open Cloud key uploads models and images without ever pasting the key into chat. Meshes
  are generated (Hi3DGen) and then cut down in Blender to get under Roblox's triangle limit
  [D:SYPHO].
- **Build in milestones, with world building last**, after the game logic, combat and NPCs [D:TEF].
- **Head-to-head map generation** between models [D:PILLED], [D:AXELL]. AXELL's procedural
  Claude-vs-Gemini test had "ups and downs" on both sides. No setup is the clear winner: the
  prompt, the kit and the review loop matter more than the model.
- **Concept image first.** Generate a building concept in the map's existing style by giving an
  image model a screenshot of the map, then build from that reference [T:KK10]. An agent can do
  the same with the screenshot tool.
- **Procedural variation is safe to automate.** Randomise colour tone and texture per part from a
  small palette [T:DEV-L]. Do clustering, scale jitter and rotation jitter in code [T:KK10],
  [T:ICE5].

**Pitfalls**
- **Scale.** AI-placed assets "too large for the game map" [D:SCUP-E]. Always run the scale sheet
  and the avatar check [T:COKE].
- **Human fixes are still needed.** On an AI city build, "human intervention remains necessary"
  [D:SCUP-C].
- **Same-material, same-size, evenly spaced output** is the AI default and is exactly what every
  tutorial says to avoid [T:KK10], [T:ICE5].
- **Spraying many random free assets** costs performance and looks messy [T:ICE5]. Check free
  models for scripts [T:COKE].
- **Unions** cost triangles [T:COKE]. Prefer parts, or meshes from the kit.

---

## 4. Real 3D text: methods ranked

Studio-verified defaults, read from fresh instances [Studio]:

| Class | Default property values |
|---|---|
| SurfaceGui | SizingMode FixedSize, CanvasSize 800x600, PixelsPerStud 50, **LightInfluence 0**, Brightness 1, **MaxDistance 0 (no limit)**, AlwaysOnTop false, Face Front, ZOffset 0 |
| BillboardGui | Size {0,0},{0,0}, **MaxDistance inf**, LightInfluence 0, Brightness 1, AlwaysOnTop false, DistanceUpperLimit -1 |
| UIStroke | Thickness 1, Color black, LineJoinMode Round, ApplyStrokeMode Contextual, StrokeSizingMode FixedSize, BorderStrokePosition Outer |
| TextLabel | TextStrokeTransparency 1 (the legacy stroke is off and only 1 px; use UIStroke instead) |

### Ranking (best real 3D look first)

**1. Extruded and bevelled font mesh from Blender, as MeshParts**
- Evidence: [D:3DT-BL] "custom 3d text via blender … works with any font", plus the general
  Blender to FBX to MeshPart workflow [Web].
- Why it wins:
  - It's real geometry, in any font (a chunky rounded font suits the toy style).
  - The **bevel catches light**, so the text reads as a solid object under the cartoony lighting
    in 2.5.
  - One mesh per letter means each letter can have its own colour plus a little rotation and
    height jitter, for a playful sign.
- Recipe:
  1. Text object with the font file.
  2. Geometry > Extrude **0.15-0.25** of the letter height.
  3. Bevel depth **0.02-0.04**, **2-3 segments**.
  4. Convert to mesh and separate by loose parts, one object per letter.
  5. Decimate to keep triangles low.
  6. Export FBX and import, giving one MeshPart per letter.
  7. Colour with MeshPart.Color and Material SmoothPlastic, no texture needed.
  8. Optional two-tone look: export the front faces and the sides/back as separate meshes.

  The numbers in steps 2-3 are my proposal [synth].
- **How an agent makes it:** the Blender MCP is connected on this machine, so an agent can script
  all of steps 1-6 in bpy. The upload step needs either Rufus's Studio 3D importer click or an Open
  Cloud key outside the repo, which is SyphoDev's route [D:SYPHO].
- Outline: one **Highlight** on the sign Model, with FillTransparency 1, a dark OutlineColor and
  DepthMode Occluded. Develuper uses Highlight for the outlined retro look [T:DEV-L]. Use one
  Highlight per Model; Roblox caps the number of Highlights shown at once (I believe it's about 31).

**2. ThreeDText 2 plugin (MeshPart letters)** [Web: the DevForum post], [D:3DT-CT], [D:3DT-DB]
- The plugin generates one MeshPart per character.
- It has 12 "optimized and properly kerned" fonts, including **Baloo**, the closest to the rounded
  toy look. Colour, material, size and spacing are customisable, and the text stays editable.
- It's the fastest route for many signs.
- **Agent route:** the plugin needs a click, so Rufus generates **one full alphabet** once. The
  agent then clones those letter MeshParts by MeshId and lays out any word, applying colour, kerning
  and jitter in code.

**3. Stud-voxel letters from Parts** [synth, fits the style bible; VAIN's 1-stud classic grid is
the closest evidence]
- A 5x7 (or 4x6) pixel font on a 1-stud grid, made of studded blocks.
- Add a darker 1-stud "rim" copy one stud behind for the outline and depth.
- It's fully real 3D, needs no assets, fits the style exactly, and an agent can build it entirely
  with execute_luau.
- Cost: about 20-35 parts per letter. Keep words short or merge rows into long bricks.

**4. SurfaceGui text on an extruded sign part** (the board is 3D, the lettering is flat) [D:SIGN]
- Best for many small info signs.
- Settings:
  - SizingMode **PixelsPerStud**, at **50-100** for crisp text.
  - LightInfluence stays **0** for a self-lit, readable sign, or **~0.5** to sit in the scene.
  - Brightness **1-2** for a glowing shop sign.
  - **Set MaxDistance to 150-300.** The default 0 means it renders at any distance.
  - TextLabel at full size, transparent background, TextScaled, UIPadding.
  - UIStroke and UIGradient work here too. The gradient tints only the text and needs a **white
    base colour**; put a UIGradient *inside* the UIStroke to colour the stroke [D:GRAD].
- Frame the board with a 1-stud trim part of a darker shade so it reads as a physical sign.

**5. ViewportFrame showing the real mesh text in UI** (title screen or logo)
- Put the method 1 or 2 letter model in a ViewportFrame with its own camera.
- Light it with ViewportFrame Ambient, LightColor and LightDirection, and bob or rotate it with
  tweens.
- It's real 3D in the UI, but has no shadows or post effects. Use it for the title and the "you
  found a diamond" moment [synth; ViewportFrame docs].

**6. Image logo** (render the 3D text to a transparent PNG and show it in an ImageLabel)
- Best looking per cost for UI logos and thumbnails.
- An agent can render from Blender through the MCP, then upload it like other images (see the
  Image-wiring memory).
- It's flat once placed, so it isn't for in-world signs.

**BillboardGui floating labels** (not 3D text, but needed)
- Size in **scale = studs**, e.g. {4,0},{1.5,0}. That keeps a constant world size, so the label
  shrinks with distance. Offset pixels keep a constant screen size.
- StudsOffset (0,3,0).
- Set MaxDistance to **60-100** (the default is inf). Use AlwaysOnTop only for objective markers.

**Verdict:** method 1, real extruded and bevelled mesh letters, gives the best-looking 3D, and
an agent can produce it end to end through the Blender MCP, apart from the upload. Method 2 is
the quickest high-quality route if Rufus clicks the plugin once to make an alphabet. Method 3 is
the most on-style option an agent can do with zero assets. Use method 4 for the many small signs,
and method 5 or 6 for UI titles.

---

## 5. Rules for an AI agent (paste into a skill)

### Maps
1. Set lighting first: the cartoony preset in 2.5 (Ambient 200,160,225; OutdoorAmbient
   125,100,150; ColorShift_Top 215,190,135; ShadowMap; ColorCorrection 0.05/0.1/0.15).
   Screenshot it before building.
2. Plan on placeholders. Put a block per POI and the spawn, and confirm the layout from a top-down
   screenshot before any art.
3. For the hub: spawn at one end facing a gate landmark, along one gently curving avenue
   (24-32-stud walkway) with booths in clusters of 2-4 on both edges. Keep the centre open and
   lanterns every 12-16 studs. Run themed districts in sequence, each ending in an arch that frames
   the next. Add one mystery side path per district.
4. Shop and leaderboards go near spawn; eggs and rare booths further along; VIP on a side spur.
5. Block out large shapes for the whole map before any detail. Detail goes big to small: border
   trees, then big rocks, then grass, then small trees.
6. Every surface gets 3 shades (path) or 2+ (grass). Leaves get about 4. Use RGB Color, saturated.
   Give each zone one contrast colour.
7. Never place a lone prop. Cluster 2-5, jitter rotation by ±5-15°, jitter scale by ±10-30%, and
   reuse the same kit piece at several sizes.
8. Vary ground height and the heights of wall and cliff pieces. No flat runs, no square map, no
   stacked-brick box border. If you use a border, curve it and add a second layer.
9. Keep the play space open. Put detail on the edges and in the background. Add 1 big landmark
   per zone plus a few small storyline vignettes.
10. Check scale against an R15 dummy every pass. Use two grid increments only (classic: 1 stud and
    90°; fine detail: 0.25).
11. No empty shelves, no bare floors, no single material. Limit the kit to about 20 reusable
    pieces. No unions for scenery.
12. After every pass, screenshot from spawn eye height, top-down and down the avenue. Compare with
    these rules and fix before moving on.

### Text
1. Pick the method by purpose:
   - hero signs and gate titles: extruded mesh letters (Blender MCP, or the ThreeDText alphabet)
   - toy signs with no assets: stud-voxel letters
   - many small signs: SurfaceGui on a trimmed board
   - UI title: ViewportFrame or a rendered PNG
2. Mesh letters:
   - one MeshPart per letter, SmoothPlastic, saturated Color
   - bevel visible under the lighting
   - ±3-6° rotation jitter and ±0.1-stud height jitter for a playful look
   - one Highlight (outline only, Occluded) per sign Model
3. Don't fake 3D by stacking offset copies of a 2D label. Rufus rejected it.
4. SurfaceGui:
   - PixelsPerStud 50-100
   - LightInfluence 0 for a self-lit sign (~0.5 to blend in)
   - MaxDistance 150-300
   - transparent background, TextScaled plus UIPadding, UIStroke 3-5 in a dark shade of the sign
     colour
   - gradients need a white base colour; colour the stroke with a UIGradient inside the UIStroke
5. BillboardGui: size in studs (scale), MaxDistance 60-100, AlwaysOnTop only for objectives.
6. Use one rounded chunky font family across signs and UI (Fredoka One in Studio; Baloo in
   ThreeDText).
7. Check every sign from the player's real camera distance in a screenshot. If it isn't readable
   at 30 studs, make it bigger.
8. Never write the trademarked toy-brick brand name on any sign.
