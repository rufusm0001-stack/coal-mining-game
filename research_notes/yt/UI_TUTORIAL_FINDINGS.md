# UI tutorial findings: how Roblox creators make UI look good

Source: 17 YouTube transcripts in `research_notes/yt/ui/`, read in full on 2026-10-07. Also checked
against `docs/UI_RULES.md`, `docs/STYLE_BIBLE.md`, `docs/ui/RESEARCH.md` and the playbook's UI
section. These are transcripts only, so I never saw the screen. Any value a creator only showed on
screen without saying it is missing here.

## Source key (cited as [code])

| Code | Video | Channel / views | Weight |
|---|---|---|---|
| [STUD] | The Greatest Stud UI Tutorial on Roblox (w/ Figma), https://www.youtube.com/watch?v=gnIKtS3nUqo | Kek (made by Hamudi) / 54k | **Highest**: exact match to our style, full step-by-step |
| [CART] | The Greatest Cartoony UI Tutorial on Roblox (w/ Figma), https://www.youtube.com/watch?v=z16zs2v-FNI | Kek / 77k | **Highest**: same layer system, cartoony variant |
| [MONZ] | How to create Roblox Guis using Figma!, https://www.youtube.com/watch?v=_UfFmap5cow | MonzterDEV / 152k | High: Figma to Studio import, exact sizes |
| [10X] | Make Your Roblox UI Look 10x Better, https://www.youtube.com/watch?v=F6AtQKo3uIY | Develuper / 112k | High: "identity + depth", export rules, shop structure |
| [LEARN] | How to style your UI on Roblox, https://www.youtube.com/watch?v=_k1ea0OIKaU | Roblox Learn / 175k | High: official Style Editor, tokens and themes |
| [KK-IMP] | How To Improve Your UI In Roblox Studio, https://www.youtube.com/watch?v=RPqIm0I_gsw | Kingkade 3D / 39k | **Highest for agents**: stud UI built natively in Studio |
| [AI] | This AI Makes INSANE Roblox GUIs!, https://www.youtube.com/watch?v=7U0IwCP6jBs | RoBuilder / 175k | AI tool limits |
| [KEK-BEG] | The Ultimate Beginner's Guide to Roblox GUI, https://www.youtube.com/watch?v=lmNWskz9cEI | Kek / 125k | Scale, aspect ratio, icons |
| [OPEN] | How to make Animated Opening Shop Gui in Roblox (2024), https://www.youtube.com/watch?v=u404sKevMPU | Rileybytes / 126k | Open/close tween values |
| [SIM] | How to Make Simulator UI, https://www.youtube.com/watch?v=a8RghxDRhPg | Fruskle / 9k | Exact scale sizes, AutoScale Lite, hover module |
| [SCALE] | How to Scale UI for All Devices, https://www.youtube.com/watch?v=y2Q9iF1LEfo | Code / 65k | Scale vs offset |
| [KK-GUI] | How To Make GUI, https://www.youtube.com/watch?v=L8Fg1pxPrzY | Kingkade 3D / 682k | Image-based bars (Pixlr), HoverImage |
| [SHOP] | How to Make an SHOP GUI in Roblox Studio 2025!, https://www.youtube.com/watch?v=1CZ5RwKSkIk | Glainz / 91k | Baseline "plain" UI (what not to stop at) |
| [DEVMAX] | How to Make Roblox UI Look ACTUALLY GOOD, https://www.youtube.com/watch?v=Zs8_UySTF1A | Devmax / 1k | Stud button recipe with exact numbers |
| [GFX] | Roblox UI Design Basics for Beginners, https://www.youtube.com/watch?v=FK3kBKCn6s8 | gfxcomet / 15k | Anchor/scale basics |
| [PMN] | How to Create Roblox GUIs in Figma, https://www.youtube.com/watch?v=6NwVFktKdu4 | PMN Online / 3k | Low value (generic narration) |
| [ALEX] | How to Create Roblox UI with Figma (2026), https://www.youtube.com/watch?v=c8T6KzEZRAk | Tutorials With Alex / 1k | Low value (Figma Community kits) |

All pixel numbers are on a **1920x1080 design canvas** unless marked. Every Figma tutorial starts
on that canvas ([STUD], [CART], [MONZ], [KEK-BEG]). Our proposed design base is 1280x720
(RESEARCH.md #17), so I multiply by 0.667 when I say "@720".

---

## 0. The one-paragraph answer

The good-looking videos all build each button and panel from the same **6-layer "toy" stack**:

1. A gradient face, light at the top.
2. A darker solid slab offset a few pixels below it, for 3D depth.
3. A thick dark outline drawn **outside** the combined face+slab silhouette.
4. A lighter inner stroke on the face, called "edge highlight".
5. A clipped texture layer on the face: **studs** for stud UI; halftone dots and diagonal shine
   bars for cartoony.
6. White Fredoka One or Montserrat ExtraBold text with a dark stroke plus a hard, no-blur drop
   shadow.

Two more rules carry a lot of the look:

- Colour codes the function: green for money/price, red for close/sell, blue for shop, purple for
  rebirth/epic, gold for legendary, grey/white for settings.
- Padding is checked to the pixel.

Every one of these layers except the blend modes can be built natively in Studio ([KK-IMP] does it).
That makes the agent route "native Frames + UIGradient + 2 UIStrokes + a tiled stud PNG + a duplicate
text shadow", with images only for icons and effects Roblox can't draw.

---

## 1. Techniques, step by step

### 1a. Figma setup (all Figma videos)

- **Canvas.** Frame tool, then the Presentation preset, **1920x1080**, at position 0,0 ([STUD], [CART], [MONZ]).
  [MONZ]: this is the base size; "a module inside Roblox scales it up or down".
- **Background.** Paste a **real in-game screenshot** into the canvas so you design against the
  actual game. [STUD] adds a **layer blur** to it. [MONZ] uses a Studio sky screenshot and cycles
  backgrounds. [PMN] dims or blurs a busy background.
- **Organisation.** Group everything (Ctrl+G) and name groups like Roblox instances: header,
  exit button, hero frame, dev products, left side buttons ([STUD], [CART]).
- **Measuring.** Hold Alt and hover to read the gaps. Nudge with the arrow keys (Shift = 10 px).
  [STUD] makes the padding **30/30/30** on all sides and fixes 1 px errors. [CART] makes text
  padding equal top and bottom (9/9).

### 1b. The toy button/panel recipe (from [STUD], [CART], [10X], [DEVMAX])

1. **Face shape.** Rectangle. Fill = **linear gradient rotated top to bottom**, light on top:
   - "Pick saturated colours and keep the brightest ones towards the top" [10X].
   - [DEVMAX] uses **6 gradient stops** of one green for a richer face.
   - Corner radius differs by style:
     - cartoony: **10** [CART]
     - Monzter: **20** panel, **15** button [MONZ]
     - stud button: **3** [DEVMAX]
     - [STUD] never adds a radius, so its bricks are square-cornered.
2. **Depth slab.** Ctrl+D the face, send the copy **behind**, move it **down** a few px, and set it
   to a **solid darker** colour of the same hue ([STUD], [CART], [10X], [DEVMAX]).
   - Offsets: [CART] "a couple of times on your down arrow". [STUD] rail buttons measured **7 px**
     slab. [STUD] header: "3D effect is too much", so they reduced it.
   - [KK-IMP]: make the shadow darker **and shift its hue toward blue**.
3. **Outer outline around the whole silhouette.** Select face + slab, then:
   - Duplicate and **Flatten** (Ctrl+E) into one vector.
   - Move it to the bottom of the stack, remove its fill, and add a stroke set to **Outside**
     ([STUD], [CART], [10X], [DEVMAX]).
   - Weight: **5** on panels/headers [STUD]; **3** on small buttons [CART], [DEVMAX].
   - Black or very dark. [STUD] keeps one weight everywhere: "equal everywhere".
4. **Edge highlight (inner stroke).** On the **face only**, add a stroke set to **Inside** in a
   **brighter tint of the face colour**:
   - **4** on headers, buttons and pet cards ([STUD], [CART])
   - 3 on small buttons
   - bright green on a green header, pink on a red close button, bright yellow on gold cards,
     bright purple on purple cards
   - [10X] calls it "edge highlighting" and says it "makes a surprisingly big difference". His
     version is an invisible frame of the same shape with an inside stroke plus a blend mode.
   - [DEVMAX]: white inside stroke **3**, blend **Soft Light**, on a frame that stops just above
     the dark slab.
5. **Texture mask.** Duplicate the face, group it (Ctrl+G), right-click and choose "Use as mask".
   Anything dropped in the group is clipped to the face ([CART], [STUD], [10X]). Then add:
   - **Studs** [STUD]: paste a stud texture from ui-resources and set the image fill to **Tile**,
     not Fill. Blend **Overlay** ("they pop too much" on Normal). The texture is a "perfect 4x4" stud
     tile. [DEVMAX]: download a stud texture, duplicate it across the button (4 copies), blend Overlay.
   - **Shine bars** [CART], [DEVMAX]:
     - 2–4 long white rectangles, taller than the button, rotated about **160°**
     - varied widths
     - blend **Soft Light** or Overlay, fill lowered to **~45 %** [DEVMAX]
   - **Halftone dots** [CART]: in the **corners only**, shrunk, rotated and mirrored. Blend
     Soft Light/Overlay.
   - **Sunburst** behind an icon on a rail button, blend Overlay [STUD]. Stars, blend-moded [10X].
6. **Sticker outline (cartoony only)** [CART]:
   - A second flattened outline under the black one: **white, stroke 6 Outside** (double the black 3).
   - On the main panel: inner **dashed** blue stroke 5 plus a white Outside stroke via a duplicated layer.
7. **Float shadow** [CART]: drop shadow on the bottom-most layer:
   - set **Y offset to 0** (Figma defaults to 4)
   - raise the blur
   - raise the opacity from 25 % until it shows, then back off
   - [10X]: "you can also add a drop shadow".

### 1c. Text recipe

- **Font.** **Fredoka One** in [CART], [10X] ("probably the most iconic Roblox font"), [MONZ],
  [KK-IMP], [OPEN], [SIM] and [SHOP]. **Montserrat ExtraBold** in [DEVMAX] (size 40) and
  [KEK-BEG] ("my favourite"). **Luckiest Guy** in [KK-GUI].
- **Fill and stroke.** White fill, dark stroke:
  - title **4–5** [STUD], description **3** [MONZ]
  - small text **2** [STUD], button text **3** [DEVMAX]
- **Hard drop shadow = text depth.** Drop shadow with **blur 0, opacity 100 %, Y = 2–4**:
  - title 64 px: Y 4, later dropped to match a stroke of 4
  - icons: Y 3
  - tiny plus button: stroke 2 and Y 2, "more subtle"
  - [CART], [DEVMAX]: the same effect made by duplicating the text, moving the copy down, and making
    it black (or the slab colour).
- **Joins.**
  - [STUD] switches the text stroke from Sharp to **Round**.
  - [MONZ] sets the frame stroke join to **Round** because corners are rounded ("looks odd"
    otherwise in Studio).
  - [KK-IMP] uses **Bevel** on text UIStroke because Round left the counters of "O" and "P"
    unfilled at small sizes.
  - Test both on our font.
- **Spacing from edges.** Text must not touch the button edges: "it just looks a bit odd when it's
  touching the sides" [STUD]. They cut rail label text from 30 to **25** px in **70** px buttons.

### 1d. Icons

- **Figma can't outline bitmaps.** The stroke goes round the image rectangle. Fix: the "Vectorize
  bitmap" plugin, then stroke **3 Outside** plus a hard shadow Y3 [STUD]. Better: add the stroke in
  Photopea/Photoshop and re-import ([STUD]). [10X]: icons must be SVG to recolour, so vectorize.
- [KEK-BEG], Photoshop:
  - Remove the background with the magic wand.
  - Add a **stroke ~20 px at source resolution**.
  - Preview by shrinking a copy onto a real game screenshot at its real size.
  - Export PNG, upload through the **Asset Manager**, then ImageLabel **ScaleType = Fit**,
    BackgroundTransparency 1.
- **Sources.** Pinterest and ui-resources for icons; a paid vector pack ("Rhinos GFX", 800+
  icons, $12) [KK-GUI]. Toolbox decals for the plain baseline [SHOP].

### 1e. Export and rebuild in Studio

- **[10X], image route:**
  - Export **every element as a separate image**.
  - Keep detailed ones "as big as possible but just under **1,024 px**", because Roblox downscales
    larger images.
  - Upload them all in the **Asset Manager**, then rebuild the hierarchy with ImageLabels and
    ImageButtons, adding live text.
  - Verdict: "honestly pretty tedious". The result "doesn't look too bad", but "I'd still like the
    images to look a little sharper".
- **[MONZ], native route (Fig-Roblox Fork plugin):**
  - The plugin converts Figma frames to `.rbxmx` and you insert it from file into StarterGui.
    Rectangle becomes Frame, corner radius becomes **UICorner**, stroke becomes **UIStroke**
    (LineJoinMode carried over), auto layout becomes layouts.
  - **Name layers with Roblox class names** to get the right instance: "Yes TextButton",
    "Confirmation ScreenGui".
  - Use **frames, not rectangles** (rectangles can't hold children). Avoid non-rectangle shapes;
    export those as images instead.
  - Strokes: set Outside (Roblox's old default) and don't use per-side strokes.
  - Known bug: delete the stray **UIPadding** after import.
  - Preview with Test → Device → **1920x1080**.
  - Reported fidelity: "90 to 99 %" of the way. Scrolling frames and grid layouts need manual work.
- **[KK-GUI], image route (682k views):**
  - Draws whole bars and buttons in Pixlr. Bar canvas 1500x500; button 1080x1080.
  - Shape: pill = circle + rect + circle, merged.
  - Depth: darker copy offset down, Hue/Sat lightness lowered.
  - Outline filter; colour via a gradient layer set to **Multiply**.
  - Text: Luckiest Guy.
  - Uploads one image per element, BorderTransparency 1.
  - Hover pop: set **HoverImage** to the same image drawn slightly larger.

### 1f. Images vs native frames

| Part | Image-route creators | Native-route creators |
|---|---|---|
| Panel/button body | PNG per element [10X], [KK-GUI], [AI] | Frame + UIGradient + UIStroke + UICorner [KK-IMP], [MONZ], [KEK-BEG], [OPEN], [SIM] |
| Stud texture | baked into PNG [STUD], [DEVMAX] | **ImageLabel, ScaleType Tile** [KK-IMP] |
| Icons | always images | always images (Asset Manager) [KEK-BEG], [SIM], [SHOP] |
| Text | always live TextLabels (all) | same |
| Halftone, shine, sunburst | baked (blend modes) | not attempted natively by anyone |

---

## 2. Concrete numbers

### 2a. Sizes on screen (1920x1080 canvas)

| Element | Value | Source | % of screen | @720 |
|---|---|---|---|---|
| Left-rail square button | **70x70** | [STUD] | 3.6 % W / 6.5 % H | **47** |
| Sim round button | scale (0.053, 0.1) ≈ 102x108; author then used **75x75** | [SIM] | 3.9 % W | 50 |
| Rail label text | 25 (cut from 30) in a 70 button; stroke 3, shadow 3 (tried 2) | [STUD] | | 17 |
| Sim button label | Size (1,0,0.348,0) at Pos (0,0,0.867,0): bottom third, overflowing | [SIM] | | |
| Sim button icon | 0.8 then **0.9** of the button, centred | [SIM] | | |
| Currency number | **46 px**, stroke **4** outside, round join, hard shadow | [STUD] | 4.3 % H | 31 / stroke 3 |
| Currency "+" button | small square, inner stroke 3, outline 3, "+" stroke **2**, shadow Y **2** | [STUD] | | |
| Currency bar (native) | UIAspectRatioConstraint **3.65**; "+" at Pos (1, 0.5), Anchor 0.5; "+" text 1.4x its parent | [KEK-BEG] | | |
| Panel title | **64**, stroke 4, shadow Y 4 blur 0 | [STUD] | 5.9 % H | 43 |
| Search text | 48 Fredoka One | [CART] | | 32 |
| Product title | **36** | [STUD] | | 24 |
| Confirmation panel | **650x350**, radius 20, stroke 5 | [MONZ] | 34 % W x 32 % H | 433x233 |
| Confirmation text | 52, stroke 3; buttons **170x70**, radius 15, stroke 3, label 46 | [MONZ] | | 113x47 |
| Auto layout | button gap **75**, vertical gap **40**, padding **50** | [MONZ] | | 50/27/33 |
| Shop panel (scale) | **0.4 x 0.45**; header 0.828 x 0.237 centred on the top edge | [SIM] | 40 % x 45 % | |
| Shop panel (scale) | 0.5 W, **UIAspectRatioConstraint 1.5** (= 960x640), UICorner **16**, UIStroke **4**; title Size (1,0,0.2,0) at the top | [OPEN] | 50 % x 59 % | |
| Close X | **75x75** offset, red, top-right Pos (1,0,0,0) | [OPEN] | | 50 |
| Standalone CTA button | **299x81**, outline 3, radius 3, text Montserrat ExtraBold **40**, stroke 3 | [DEVMAX] | | 199x54 |
| Content padding | **30** all sides; card gap **24** | [STUD] | | 20 / 16 |

What "too big" means against these numbers:

- Rail buttons are about **6.5 % of screen height**.
- HUD numbers are about **4 % of screen height**.
- Shop panels are **40–50 % wide** and **45–60 % tall**.
- Confirmation popups are about **1/3 x 1/3**.

Anything bigger on desktop is off-genre.

**Phone math (my inference).** A root UIScale of min(844/1920, 390/1080) = 0.36 makes a 70 px rail
button **25 pt** on an iPhone. That is well under our 44 px touch minimum. Desktop-correct sizes need a
**phone multiplier of about 1.6–1.8** (ViewportDisplaySize Small) to stay touchable. Don't make the
desktop UI bigger to fix phones.

### 2b. Strokes, corners, transparency

| Property | Value | Source |
|---|---|---|
| Panel/header outer outline | **5** (3 on small parts) | [STUD], [MONZ], [KK-IMP], [SHOP] |
| Panel outline (other) | 4 [OPEN]; 5 [GFX] | |
| Inner highlight stroke | **4–5** | [STUD], [CART], [KK-IMP] (UIStroke ApplyStrokeMode Border, *inner*, thickness 5, colour brighter than the fill) |
| Text UIStroke | **4** (5 tried, 4 "looks better"), LineJoinMode **Bevel** | [KK-IMP] |
| Scaled stroke | StrokeSizingMode ScaledSize **0.04** (frame), **0.06** ("+" button) | [KEK-BEG] |
| Scaled corner | UICorner scale **0.2** [KEK-BEG], **0.1** [GFX]; **(1,0)** = circle [SIM] | |
| Stud tile (native) | ImageLabel `ScaleType = Tile`, `TileSize = {0,100},{0,100}` | [KK-IMP] |
| Dark panel body | BackgroundTransparency **0.15**; stud ImageTransparency **0.75** | [KK-IMP] |
| Shadow/slab layer | ImageTransparency **1** (no studs on the slab), ZIndex below the face | [KK-IMP] |
| Inner shadow (search bar) | Y **0**, blur up, opacity **30 %**, radius 10 | [CART] |
| Shine bars | rotation **160°**, Soft Light, fill **45 %** | [DEVMAX] |

### 2c. Colours named

- Header: bright green top to "not so bright" green bottom; slab darker green ([STUD]).
- Gradient: bright green into yellow-green, Rotation **-90** ([KK-IMP]). Check visually which end
  lands on top; UIGradient Rotation 90 runs keypoint 0 at the top.
- Close: red gradient with a brighter top, pink-red inner stroke, dark red slab ([STUD], [CART]).
- Rail buttons:
  - Shop: blue
  - Rebirth: pink/purple
  - Index: green
  - Settings: grey bottom to near-white top, bright white stroke, dark grey slab
  - Sell: red
  - Source: [STUD]
- Pet cards: gold top to darker orange (legendary), purple (epic). Recolour all at once through
  Figma "Selection colours" [CART]. That is a token swap.
- Price buttons are **green**: "green is just the colour of money". Always show a currency icon next
  to the price [10X].
- Panel body: "white with some details or a semi-transparent black" [10X]. [STUD] uses black at
  reduced opacity with a 5 px outline.
- Duotone 3D button: the yellow-orange pair "works perfectly" [10X].

### 2d. Scaling methods

- **Use Scale, never Offset**, for Size and Position. Offset 555 px is huge on VGA ([KEK-BEG],
  [SCALE], [SIM], [GFX]).
- **AnchorPoint (0.5, 0.5)** plus Position (0.5, 0.5) to centre. It is also needed so hover tweens
  grow from the centre ([SCALE], [KEK-BEG], [OPEN], [SIM]). Use increments of 0.5 [GFX].
- **UIAspectRatioConstraint** on anything that must keep its shape:
  - Compute the ratio from the current size: the [KEK-BEG] currency bar is 3.65. Adding it blindly
    resizes the frame.
  - Tools: **AutoScale Lite** "unit conversion" offset→scale plus "add constraint" [SIM]; "UI Tools"
    plugin [KEK-BEG].
- **Device emulator.** Test tab → Device: 1080p, VGA, phones ([KEK-BEG], [MONZ], [SCALE]). [SCALE]:
  close the Explorer and Properties panes while scaling, so the viewport isn't squeezed.
- **Canvas Frame.** A transparent Frame of size (1,0,1,0) under the ScreenGui, so backgrounds and
  scaling sit on one parent [GFX]. Each panel goes in one container Frame so scripts toggle one
  `.Visible` [KK-IMP].
- **TextScaled** + Size (1,0,1,0) labels everywhere in the native tutorials ([KEK-BEG], [OPEN],
  [SIM], [KK-IMP]). My note: this makes text sizes inconsistent across buttons. Prefer a fixed
  TextSize under a root UIScale, or TextScaled plus a UITextSizeConstraint.
- [MONZ] designs in pixels at 1920x1080 and then scales the whole GUI with a module. That is the
  same idea as RESEARCH.md #17's single root UIScale.

### 2e. Official Style Editor ([LEARN])

- UI tab → Style Editor. Three parts:
  - **StyleSheets**: rules per class, e.g. Frame, TextButton.
  - **Tokens**: `$magenta`, `$PrimaryColor`.
  - **Themes**: token sets swapped at edit time or by script.
- Rules can add pseudo-instances (a UIStroke on every Frame) and state selectors (`:hover` sets
  BackgroundColor3 + TextColor3). Set **AutoButtonColor = false** when styling hover yourself.
- **Tags** give variants, such as a "button square" tag: grey, 100x100.
- Why it matters: "my previous magentas were actually slightly off shade from each other". Tokens fix
  colour drift. For an agent, a Luau `Theme` module of tokens gives the same thing in code you can diff.

---

## 3. Stud UI and cartoony recipes

### 3a. Stud shop [STUD]

1. Canvas 1920x1080. Paste a game screenshot, enlarge it, **lock** it, add a **layer blur**.
2. **Main body.** Rectangle centred horizontally, fill **black at reduced opacity**, stroke **5**
   (later set to **Outside**).
3. **Header.**
   - Rectangle the same width as the body, top-to-bottom **green gradient**.
   - Ctrl+D, move the copy down, set it solid **darker green**. This is the slab.
   - Shrink both, then flatten a copy, drop it to the bottom, remove its fill, stroke **5 Outside**.
   - Group as "header".
4. **Exit button.** Duplicate the header group and shrink it beside the header. Recolour:
   - face: red gradient, brighter top
   - slab: darker red
   - the 3D slab was too deep, so make it shallower
5. **Studs.**
   - Paste the stud PNG into the face. Image fill: **Tile**, resized smaller.
   - It's "a perfect 4x4", so it can be reused on the square exit button.
   - Blend **Overlay**; keep the header on Normal if Overlay is too weak.
6. **Edge highlights.** Inside stroke 3, then **4**: bright red on the exit, bright green on the header.
7. **Title "SHOP".** Text 64, stroke 4–5, drop shadow Y 4 / blur 0 / opacity 100.
8. **Robux icon.** Vectorize, white fill, stroke 3 Outside at 100 % opacity, drop shadow Y 3 /
   blur 0 / 100 %.
9. **Hero product frame**, inside the body:
   - group mask with a stud texture and a big **gem icon**
   - duplicate gems rotated and enlarged at **low opacity** in the background
   - title, a short white description with **stroke 2**
   - a price button with the Robux icon
10. **Currency products.**
    - Duplicate the hero frame and resize with the **Scale tool** (K), which keeps proportions.
    - The Scale tool also scales stroke weights, so **reset them**: 7 back to 5, and 3.
    - Three blue cards; title 36 "+50 cash".
    - Gaps **24**; padding **30/30/30** all round, measured with Alt.
11. **HUD top buttons.** Base / Shop / Sell copies of the price button:
    - Base: green
    - Shop: blue
    - Sell: red
    - Text size 45 so it isn't "dropping over the edge".
    - Copy fills between layers: click the fill row, Ctrl+C, then Ctrl+V on the target.
12. **Left rail.**
    - Buttons **70x70**: Robux Shop (blue, with **sunburst Overlay** behind the icon), Rebirth
      (pink/purple), Index (green), Settings (grey to white).
    - Inner stroke 5 on top; text **25**, stroke 3, shadow 3.
    - Highlight opacity lowered ("too bright").
    - Group and **centre vertically** on screen.
13. **Cash counter, bottom.**
    - "$999,999" in **green**, size **46**, stroke **4 Outside, Round join**, hard shadow.
    - A small green "+" square: slab, inner stroke 3 bright green, outline 3, "+" text stroke 2,
      shadow 2.
14. **Pill toggle "Slow mode on".**
    - Resized "to **three studs** long", so sizes are counted in studs.
    - Match slab depth across all buttons: count it, **7 px** each.

### 3b. Native stud panel in Studio [KK-IMP] (the closest to what an agent does)

1. ScreenGui → **ImageLabel**, Image = a stud decal from the Toolbox ("copy texture ID"),
   **ScaleType Tile, TileSize {0,100},{0,100}**.
2. Sizing rule: "scale it depending on the studs ... it ends directly on a stud". Avoid half-studs
   at the edges: "kind of looks sloppy".
3. **Background.** Ctrl+D the ImageLabel, put it on top and shrink it to the body:
   - BackgroundColor dark
   - **BackgroundTransparency 0.15**, **ImageTransparency 0.75**
   - **ZIndex 0**
4. **Header.**
   - Duplicate it and move the copy slightly down as a **Shadow**.
   - Header ZIndex 2. Shadow **ImageTransparency 1**.
   - Header gets a **UIGradient**: bright green to yellow-green, **Rotation -90**.
   - Header gets a **UIStroke, inner, thickness 5**, colour brighter than the fill.
5. **Shadow.** BackgroundColor picked from the header, then **darker and nudged toward blue**. Add a
   **UIStroke outer, 5**. The **Background** also gets a UIStroke outer **5**, so the outlines join
   into one silhouette.
6. Put everything in one transparent **container Frame** ("Shop UI") so scripts toggle one Visible.
7. **Title.**
   - TextLabel, ZIndex 3, **FredokaOne**, lower-case "shop", white
   - BackgroundTransparency 1, TextScaled
   - **UIStroke 4, LineJoinMode Bevel**
8. **Tab buttons.**
   - TextButton, text removed.
   - **Paste the Header + Shadow into it** and scale them to fit.
   - Recolour: gradient orange to yellow, lighter yellow stroke, dark orange shadow.
   - Add a label (ZIndex 3, Fredoka, UIStroke 4 Bevel).
   - Ctrl+D the button and rename it: Coins / Wins / Pets.
9. Build one component, then copy and recolour it for every screen: "an entire game UI in just a
   couple of hours".

### 3c. Cartoony inventory [CART]

1. Canvas 1920x1080 with a dark fill.
2. **Base frame.**
   - Centred, **white**, **radius 10**.
   - Stroke **5 inside, light blue, Style: Dashed**.
   - Duplicate as "white outline" with an **Outside** white stroke: a double outline.
3. **Search bar.**
   - White rect, radius 10.
   - **Inner shadow**: Y 0, blur up, opacity **30 %**.
   - Text "search", **Fredoka One 48**, with equal padding (9 top and bottom).
   - Grey stroke **Outside**.
4. **Pet card.** Tall rect, **gold-to-dark-orange gradient**, radius 10.
   - Slab: duplicate, move down, darker solid.
   - Black outline: flatten a copy, **stroke Outside 3**, no fill.
   - White outline: duplicate that, **stroke 6**, placed below it.
   - **Drop shadow**: Y **0**, larger blur, opacity raised, then lowered.
5. **Mask group** on the card face:
   - two rotated white bars, differing widths, blend **Soft Light**
   - **halftone** image, blend Soft Light
6. **Card text.** Title "doggy" in white with a black stroke; "level 1" below it. Pet icon flipped
   horizontally and scaled up.
7. **Card grid.** Ctrl+D a row, set the gap (41 → more), align with **vertical centre**. Ctrl+D the
   rows down.
8. **Buttons.**
   - "Equip best": green gradient, radius 10, slab, outline 3.
   - Mask with shine bars set to Overlay; halftones in **two corners only** (flip H and V).
   - Text: white, stroke, 3D via a duplicate moved down. Black duplicate = stronger.
   - "Delete mode": red. "Filter": white to grey, small.
9. **Close X.** Square radius 10, red gradient, **pink inner stroke**, slab without a stroke, black
   outline, white "X" with stroke 3 and a 3D duplicate.
10. **Header "inventory".** Blue gradient, radius 10, slab, outline, title stroke + 3D, mask with
    shine + halftones.
11. **Rarity variants.** Recolour each row through Selection colours (purple = epic). Add an
    **inner stroke 4** in a brighter tint per rarity: yellow, purple, green, red. Copy and paste the
    stroke property, then re-set the weight.

### 3d. One CTA button with exact numbers [DEVMAX]

1. Rectangle **299x81**, 6-stop green gradient from top to bottom.
2. Copy it, move it up, and make the original darker green: that is the slab.
3. Flatten both and reset the size to 299x81.
4. Outline: **outside, black, 3**; radius **3**.
5. "Inner outline" frame: covers the face, stops above the slab, radius 3, no fill, **white inside
   stroke 3, blend Soft Light**.
6. "Shine" frame: 4 white bars rotated **160°**, Soft Light, fill **45 %**, kept inside the inner
   outline.
7. Studs from ui-resources: 4 tiles across, blend **Overlay**.
8. Text "purchase", **Montserrat ExtraBold 40**: white fill, black stroke 3, plus a duplicate offset
   for 3D.

### 3e. "10x better" button [10X]

1. Two things to aim for: **identity** (colour, shape, type, texture) and **depth**.
2. Rounded rect with a yellow-to-orange gradient, brightest at the top.
3. Duplicate it, move it straight down (Shift), put it behind, make it darker.
4. Flatten and add a black **outside** stroke.
5. Fredoka One with a thick stroke and the same depth trick.
6. A white SVG arrow icon, also with depth.
7. Shine inside the mask with a blend mode, then **edge highlighting**: an inner stroke on a
   same-shape frame with a blend mode.
8. Stars inside the mask; an optional drop shadow.
9. Shop structure:
   - a **top bar that stands out**
   - the main item **bigger and first**, smaller items after it
   - each item has a title, a short description if it's a bundle, a large image, and a **green price
     button** with a currency icon

---

## 4. Animation and feel

- **[SIM] UI module:**
  - hover: the button **grows**
  - MouseButton1Down: **shrinks**
  - release: grows back
  - click: `toggleFrame` opens and closes the panel
  - Requires AnchorPoint 0.5. The module is from the description, so values aren't spoken.
- **[OPEN] open-shop tween:**
  - **Open:**
    1. Shop.Visible = true
    2. Position snaps to (0.5, 0.55)
    3. TweenInfo **0.1 s** to (0.5, 0.5)
    4. Camera **FieldOfView tween to 75** in 0.1 s (from 70)
    5. `BlurEffect` in Camera, **Size 12**, Enabled = true
  - **Close:** tween back to 0.55 and FOV 70, blur off, `task.wait(0.1)`, then Visible = false.
  - The open button toggles; the Exit button closes.
- **[KK-GUI]:** ImageButton **HoverImage** = the same art drawn slightly bigger. A zero-code
  "popup", but it snaps instead of easing.
- **[LEARN]:** `:hover` style rule sets the colours, with AutoButtonColor = false.
- **[SCALE]:** AnchorPoint (0.5, 0.5) is "super useful in tweens such as hover animations".
- No video gave Back-easing or stagger values. Our UI_RULES numbers (1.05/0.95, Back ~0.2 s) are
  stronger than anything in these tutorials. Keep them, and add [OPEN]'s slide-up 5 % plus optional
  blur/FOV for full panels.

---

## 5. AI UI tools: what [AI] shows, and the limits

**Tool.** Forge GUI (website). Modes: icons, thumbnails, GUI. You start from a reference image or
from nothing.

**Workflow shown:**

1. Upload a screenshot of an existing frame and use "Magic edit", e.g. "using white and blue colours,
   make this frame have a bubbly look".
2. Iterate with edits ("remove the gold avatar"), "generate variants" (4 alternatives), or "change
   this into a shop frame".
3. **Isolate** pieces: claim button, red X.
4. Get a **blank background** with "remove all text and avatars".
5. "Export zip" of PNGs.
6. In Studio:
   - ImageLabel for the background
   - ImageButtons for X and Claim (BackgroundTransparency 1)
   - TextLabel for live text ("cool font", TextScaled)

**Limits seen:**

- It **kept artefacts from the source screenshot**: the player's avatar showing through the frame
  was baked into the new art.
- "Isolate the gold claim button" **failed twice** on the full frame. It only worked after uploading a
  **cropped screenshot** of just that button.
- The input was blurry; output quality follows input quality.
- Output is flat raster with text baked in. You must strip the text and re-add it as live TextLabels.
  Every element needs separate isolation, so there is no structure, no 9-slice, no states.
- "The more complex the frame, the harder it is to get the AI to fully understand."
- The author pitches it mainly as **references, layouts and vibes to hand to an artist**, not
  finished UI. Generated frames "didn't match the theme" of his game.

**Also:** [DEVMAX] closes with an ad for its own one-prompt UI generator, with no demo of the limits.

**Takeaway for us:** an image model is good for mood boards and single isolated assets: icons, an
emblem, a background illustration. It is bad for whole panels you then have to cut up and rebuild.

---

## 6. Mistakes creators call out

1. **Offset sizes**: break on other screens ([KEK-BEG], [SCALE], [SIM], [GFX]).
2. **No aspect-ratio constraint**: frames stretch and text mis-scales ([SCALE], [KEK-BEG]). Adding
   one with a guessed ratio also resizes the frame ([KEK-BEG]).
3. **Stretched stud texture**: you need Tile + TileSize ([KK-IMP]). In Figma, image fill = Tile, not
   Fill ([STUD]).
4. **Panel edges cutting a stud in half**: "looks sloppy" ([KK-IMP]).
5. **Textures and highlights too loud** on Normal blend: use Overlay/Soft Light, lower opacity
   ([STUD], [CART], [10X]: "this effect looks pretty bad right now ... that's where blend modes come in").
6. **3D slab too deep** ([STUD]). **Inconsistent slab depth** between buttons: count the px ([STUD]).
7. **Inconsistent stroke weights**: "match the thickness of all the other strokes, otherwise it's
   going to look kind of weird" ([KK-IMP]). Scale-tool resizing silently changes stroke weights
   ([STUD]).
8. **Uneven padding / 1 px misalignment**: measure with Alt, use the align tools ([STUD], [CART]).
9. **Text touching button edges** ([STUD]). **Text over the edge of its button** ([STUD], size cut
   to 45).
10. **Stroke on a bitmap icon** outlines the rectangle: vectorize, or bake the outline into the PNG
    ([STUD], [10X]). The same is true of UIStroke on an ImageLabel in Roblox.
11. **Figma stroke Inside vs Roblox Outside** mismatch; **Miter joins on rounded frames** look odd in
    Studio ([MONZ]). **Round join on small text** leaves letter counters open, so use Bevel ([KK-IMP]).
12. **Figma drop/inner shadow default Y = 4**: set 0 for an even glow ([CART]).
13. **Images over 1024 px** get downscaled. Exported PNGs look soft ([10X]).
14. **No container frame**: scripters must toggle every piece separately ([KK-IMP]).
15. **Default gradient direction** (left to right) is wrong: rotate so it runs top to bottom
    ([CART], [KEK-BEG], [KK-IMP]).
16. **Off-shade duplicate colours** across elements: use tokens ([LEARN]).
17. **Default AutoButtonColor** fights a custom hover ([LEARN]).
18. **Non-rectangle Figma shapes / per-side strokes** don't convert; **UIPadding** import bug
    ([MONZ]).
19. **The plain baseline** ([SHOP]: flat colour + UICorner + black UIStroke 3/5 + toolbox icon,
    nothing else) is exactly the "outdated" look [KK-IMP] and [10X] open their videos by
    criticising. It is the minimum, not a finished UI.

---

## 7. Agent recipe: this quality with no human in Figma

### Which approach the tutorials imply

- The **look** comes from the layer stack (§0), not from Figma itself. [KK-IMP] gets the stud
  look natively.
- The only things native Roblox UI **can't** do are:
  - blend modes (Overlay/Soft Light)
  - inner shadow
  - blurred drop shadow
  - clipping rotated shapes to a rounded mask
- Every one of those is replaceable with a **pre-shaded transparent PNG**: white highlight and dark
  shadow pixels at partial alpha, i.e. "overlay" baked into the alpha. An agent can draw these
  **procedurally with Python/PIL**: crisp, tiny, free, exactly on-grid. No image model needed.
- Baking whole buttons as PNGs (the [10X] / [KK-GUI] / [AI] route) has costs:
  - per-colour re-renders
  - softness ("I'd like the images to look a little sharper")
  - studs stretch inside a 9-slice centre
  - tedious rebuilds
  - Use it only where native can't reach.

**Recommendation: hybrid native.** Frames + UIGradient + two UIStrokes + a slab Frame, plus a
**tiled procedural stud PNG**, plus a duplicate-label text shadow. Images only for:

- illustrated icons (image model, `asset-artist`)
- a few procedural effect PNGs (stud tile, soft shadow 9-slice, inner-shadow 9-slice, sunburst,
  halftone corner)

### Step-by-step

**Step 1: Tokens (Luau `Theme` module, or Style Editor tokens per [LEARN]).**

- Palette:
  - per function: money gold, upgrade green, close red, shop blue, locked grey, diamond cyan
  - per colour: `face_top`, `face_bottom`, `slab` (about 35–40 % darker, hue nudged toward blue per
    [KK-IMP]), `rim` (lighter tint)
  - `outline` = `#1E1A2E`
- Numbers @720: stud pitch **P = 12 px**; radius **4** (brick) / **7** (cartoony); outline **3**
  (panel **4**); rim **3**; slab depth **3** (small) / **5** (rail/header); padding **20**; gap **16**.

**Step 2: Procedural texture kit (PIL, render at 4x, then downsample).**

- `stud_tile.png`, 64x64, one stud:
  - transparent background
  - a circle about 60 % of the tile, centred
  - a top-left crescent of **white at ~55 % alpha**
  - a bottom-right crescent of **#1E1A2E at ~35 % alpha**
  - a faint 1-px dark ring at ~20 %
  - Works on any colour like Overlay. Tune per surface with ImageTransparency **0.55–0.8**
    ([KK-IMP] used 0.75 on dark).
- `soft_shadow_9s.png`, 128x128: a blurred dark rounded rect for the float shadow
  ([CART] Y 0, big blur). Use as a 9-slice.
- `inner_shadow_9s.png`: a dark edge fading inward, ~30 % ([CART] search bar), 9-slice.
- `sunburst.png` (white rays, alpha 0.25) and `halftone_corner.png` (dots fading diagonally), for
  cartoony accents. Optional for us.
- Upload once (Asset Manager / Open Cloud; see memory "Image wiring") and store the IDs in an
  `Images` module.

**Step 3: `makeToyButton(parent, opts)` in Luau.** This mirrors Figma's face / slab / flattened outline.

```
Root (ImageButton, transparent; hit area = W x (H+depth); AnchorPoint 0.5,0.5; AutoButtonColor=false)
 ├ UIScale                                  -- hover/press tween target
 ├ Slab  (Frame, full root size, colour = slab, UICorner r,
 │        UIStroke outline 3 #1E1A2E, BorderStrokePosition Inner, ZIndex 1)   -- [KK-IMP] outer stroke on shadow
 └ Face  (Frame, size W x H at top, colour white + UIGradient Rotation 90 face_top→face_bottom
          (or palette colour + white→light-grey; test per RESEARCH #9), UICorner r,
          UIStroke rim 3, lighter tint, Inner, ZIndex 2)                    -- edge highlight
     ├ Studs   (ImageLabel, size 1,1, BackgroundTransparency 1, Image stud_tile, ScaleType Tile,
     │          TileSize P x P, ImageTransparency 0.65, UICorner r)          -- own UICorner = rounded clip
     ├ Shine   (optional CTA only: Frame white, size 1,1, UICorner r, UIGradient Rotation ~70 with
     │          Transparency NumberSequence giving 2 hard-edged bars at 0.55, else 1)  -- [DEVMAX] bars natively
     ├ IconShadow (ImageLabel = icon, ImageColor3 #1E1A2E, offset +2 px Y) + Icon
     ├ LabelShadow (TextLabel, #1E1A2E or slab colour, offset +2..3 px Y)
     └ Label   (TextLabel FredokaOne, white, fixed TextSize, UIStroke 2 #1E1A2E Contextual, LineJoin Round/Bevel test)
```

- Size every element in **whole studs**: W and H = n·P, rail button = 4P ≈ 48 @720. The stud tile
  then never cuts a stud in half ([KK-IMP], [STUD] "three studs long").
- ClipsDescendants ignores UICorner, so don't rely on clipping. Every overlay layer carries its
  own UICorner of the same radius.
- Verify in Studio that TileSize follows the root UIScale; if not, recompute it on resize.

**Step 4: `makePanel`.**

- Body:
  - light: white/cream with studs at ImageTransparency ~0.8, or
  - dark: `#1E1A2E` at BackgroundTransparency 0.15 with studs at 0.75 ([KK-IMP])
- Outline 4.
- **Header banner** = a `makeToyButton` in the function colour, straddling the top edge ([SIM] header
  0.828 W centred on the top edge). Title 40–43 @720 with a hard shadow.
- **Close** = a red square toy button 1:1 (~40–50 @720) at the top-right corner.
- Content padding **20**, gap **16**, through UIPadding / UIListLayout / UIGridLayout ([MONZ] auto
  layout equivalent).
- Shops: the hero item first and larger, green price buttons with a currency icon ([10X]).
- Panel size cap: about **50 % W x 60 % H** on desktop ([OPEN], [SIM]).

**Step 5: Icons.**

- Image model sheet (RESEARCH §F prompt) with a **baked thick dark outline**. A UIStroke on an
  ImageLabel would outline the rectangle ([STUD] mistake #10).
- Defringe, ≤1024 px source, ScaleType Fit.
- Hard shadow = a duplicate ImageLabel tinted dark via ImageColor3, offset 2–3 px down.

**Step 6: Scaling.**

- Author in offset at 1280x720 inside one root UIScale = min(vw/1280, vh/720).
- Multiply by a ViewportDisplaySize step. Phones need **~1.6–1.8** to keep rail buttons ≥ 44 pt
  (see the phone math in §2a).
- Keep sizes from the §2a table. Never use TextScaled on headings without a UITextSizeConstraint.

**Step 7: Motion.**

- UIScale 1.05 hover / 0.95 press (UI_RULES).
- Panel open: UIScale 0.9→1 Back 0.2 s plus Position from Y+0.05 → 0 ([OPEN] used 0.55→0.5 in
  0.1 s).
- Optional for full-screen menus only: BlurEffect Size 12 + FOV +5 ([OPEN]).
- Close: reverse in 0.1 s, then Visible = false.

**Step 8: Verify by screenshot, not by eye-balling code.**

- Capture at 1920x1080 and a phone viewport over the **real mine scene** ([STUD], [MONZ] design
  against an in-game screenshot).
- Check:
  - sizes against §2a
  - equal padding
  - one outline weight per tier
  - slab depth identical across buttons
  - no half studs
  - text not touching edges
- Run `ui-critic`.

**Option B: use Figma, but agent-driven.** This session has a Figma MCP with `use_figma` and
`get_screenshot`. An agent could build the [STUD] stack in Figma, where real Overlay/Soft Light blends
exist, then export ≤1024 px PNGs per element and 9-slice them. Studs must stay a separate Tile layer,
not the 9-slice centre. Use this only for hero art (big title banner, rarity card frames) where
blend-mode richness matters. Name layers with Roblox class names in case a plugin import ([MONZ];
RoImport per the playbook) is used.

**Option C: whole-frame AI image generation (Forge-style).** Only for mood references; see §5.

---

## 8. Proposed changes to `docs/UI_RULES.md` (not applied)

These build on the diffs already proposed in `docs/ui/RESEARCH.md`. Numbers are @1280x720 design
size under the root UIScale.

1. **Add a "Toy stack" section** as the required build for every button and panel:
   - face (UIGradient Rotation 90, light top)
   - darker slab underneath, 3 px (small) / 5 px (header and rail); **the same depth on every
     button of a tier**
   - dark `#1E1A2E` outline on the slab so it wraps the whole silhouette
   - lighter-tint **inner rim stroke** 3 px on the face, now required rather than optional
     ([STUD], [CART], [10X], [KK-IMP] all do it)
   - stud tile layer
   - text with stroke + hard shadow
2. **Corner radius.** Change "12–16 px" to **4 px for brick buttons and panels** (stud look: [STUD]
   none, [DEVMAX] 3) and **7 px max** for softer cards ([CART] 10 @1080). Fully round only for
   rail icon buttons and close (if round). 12–16 @720 is 18–24 @1080, rounder than any of the
   tutorials.
3. **Add a stud texture rule.**
   - One procedural `stud_tile.png` (alpha-shaded, works on any colour).
   - ImageLabel ScaleType Tile, TileSize **12 px**, ImageTransparency **0.55–0.8**.
   - Its own UICorner. Never on the slab.
   - **All UI sizes are whole multiples of 12 px**, so no half studs at edges.
4. **Depth colour.** "Slab = the face colour about 35–40 % darker and nudged toward blue/purple"
   ([KK-IMP]); never plain black at reduced opacity.
5. **Text depth.** Every heading and number gets a **hard drop shadow**:
   - a duplicate label in `#1E1A2E`, offset **2 px** (≤24 px text) or **3 px** (titles), no blur
     ([STUD], [CART], [DEVMAX])
   - Text stroke: **2 px** small text, **3 px** titles/numbers
   - Test LineJoinMode Round vs Bevel on Fredoka at 16 px ([KK-IMP])
6. **Size budget table.** Add a hard-numbers table so the agent can't build "too big":

   | Element @720 | Size |
   |---|---|
   | rail button | **48x48** (4 studs) |
   | rail label | 16 |
   | HUD money number | **30**, plus button 24 |
   | panel title | **40** |
   | item title | 24 |
   | body | 16–18 |
   | CTA button | 192x48, label 24 |
   | close | 36–48 |
   | panels | ≤ **50 % W x 60 % H** desktop (confirm dialogs ≈ 1/3 x 1/3); ≤ 92 % W on phone |

   Sources: [STUD], [MONZ], [SIM], [OPEN], [DEVMAX].
7. **Phone step.** State the multiplier: ViewportDisplaySize Small = **x1.7** (not 1.15). Otherwise a
   48 px rail button renders ~26 pt on a phone, below the 44 px minimum.
8. **Panel body.** Pick one for this game; I suggest **light**: cream/white with faint studs and
   a bright coloured header, since our bans target "dark translucent". If dark is used, it must be
   `#1E1A2E` at 0.15 transparency with studs, a 4 px outline and a coloured header. A thin gold
   border stays banned. (Open question for Rufus.)
9. **Shop layout rule** ([10X]): hero item first and bigger; every price is a **green** toy button
   with a currency icon; bundles get a one-line description.
10. **Icons.** Outline baked into the PNG, because UIStroke on images outlines the rectangle. Add a
    hard shadow via a dark-tinted duplicate ImageLabel, offset 2 px.
11. **Shine is for CTAs only.** Diagonal UIGradient transparency bars on price/claim buttons only,
    so the screen keeps a focal point. Halftones and sunbursts are optional accents on the rail
    Shop button only.
12. **Spacing.** Panel padding **20 px**, gap **16 px**, equal on all sides (±0 px). Text keeps at
    least 1/6 of the button height clear of the edges ([STUD]).
13. **Consistency through tokens.** All colours and stroke weights come from one `Theme` module (or
    Style Editor tokens, [LEARN]). No literal Color3 in screen code.
14. **Feel additions.**
    - Panels slide up 5 % while popping ([OPEN]).
    - Full-screen menus only: BlurEffect 12 + FOV +5, both reversed on close.
    - AutoButtonColor = false on every custom button ([LEARN]).
15. **Verification.**
    - Screenshots over the real mine scene at 1920x1080 and a phone viewport.
    - ui-critic checks the size table, slab depth parity, outline parity, no half studs, and text
      clearance.
16. **Process.** Build `makeToyButton` / `makePanel` once and generate every screen from them
    ([KK-IMP] "copy what you previously made"). No hand-built one-off buttons.
