# UI Research — chunky toy UI for "Find The Diamond In The Coal"

Researched 2026-10-06 by the `ui-researcher` agent. Every finding is one actionable sentence
plus its source. "Unverified" means I couldn't confirm it from a primary source. Nothing here
changes `docs/UI_RULES.md` by itself; see **Proposed rule changes** at the bottom.

Limits of this pass:
- YouTube pages returned no description, chapters or transcript to the fetch tool, so no
  finding below comes from a video. Video titles found are listed under "Not used" at the end.
- Fan wikis for Bee Swarm Simulator and some guide sites blocked fetching (402/403).
- I could not find a Roblox game called "Prehistoric Farm" by name (see Open questions).

---

## Findings

### A. UIStroke (the outline system changed in late 2025, and it matters for us)

1. **One object can now carry several UIStrokes**, ordered by `UIStroke.ZIndex`, so a panel can
   have a thick dark outer outline plus a thin light inner rim without extra Frames; give each
   stroke a different ZIndex because equal ZIndex has undefined order.
   Source: https://devforum.roblox.com/t/studio-beta-uistroke-improvements-scaling-offsets-and-more/3958036
2. **Those improvements are fully released** (4 Dec 2025, beta toggle removed), so we can rely
   on `ZIndex`, `StrokeSizingMode`, `BorderStrokePosition` and `BorderOffset` on all clients.
   Source: same thread as 1.
3. **`BorderStrokePosition` = `Outer` / `Center` / `Inner`** controls whether the stroke sits
   outside, across or inside the object's box; `Inner` keeps a 4 px outline from spilling into
   neighbours in a grid and keeps the visible button the same size as its hit area.
   Source: same thread as 1; property list at https://create.roblox.com/docs/en-us/reference/engine/classes/UIStroke.md
4. **`StrokeSizingMode.ScaledSize` makes Thickness a fraction of the parent's shortest side**
   (0.1 on a 200×300 frame = 20 px; on text it's relative to font size); `FixedSize` (default)
   is pixels, and pixel Thickness and BorderOffset both follow a `UIScale` ancestor.
   Source: thread in 1; https://devforum.roblox.com/t/how-do-i-automatically-scale-uistrokes/4061225
5. **Keep fewer than ~300 UIStrokes on screen** for low-end devices (Roblox engineer guidance in
   the release thread); an Upgrade Book with 3 tracks × (card + button + text) is fine, a
   50-item scrolling shop with 4 strokes each is not.
   Source: thread in 1.
6. **Outline text with a `UIStroke` (ApplyStrokeMode `Contextual`), not `TextStrokeColor3`**;
   a second UIStroke with `Border` mode on the same label outlines the box independently.
   Source: https://create.roblox.com/docs/en-us/ui/appearance-modifiers.md
7. **Don't tween `UIStroke.Thickness` on text objects** (flicker/performance), and don't put a
   `UIGradient` on an object that uses `TextStrokeColor3` (gradient blends with the stroke).
   Source: appearance-modifiers page above; https://create.roblox.com/docs/en-us/reference/engine/classes/UIGradient.md

### B. Shape, fill and fonts

8. **`UICorner` now supports per-corner radii** (`TopLeftRadius` etc.), and a scale of 0.5+
   gives a pill; use this for the open-book spine (round outer corners only) and for pill price
   buttons.
   Source: appearance-modifiers page above.
9. **`UIGradient.Color` "blends with the parent" along the sequence and `Rotation` is clockwise
   from left-to-right**, so a two-tone top-light fill is `Rotation = 90` with a light-to-base
   sequence. Whether the blend is a multiply is not stated in the docs (community practice is
   white BackgroundColor3 + palette gradient, or palette colour + white→light-grey gradient;
   unverified which looks closer to our palette — test both on one button).
   Source: UIGradient reference above.
10. **Build panels from Frames + UICorner + UIGradient + UIStroke rather than ImageLabels where
    possible**: DevForum posters report primitives render faster and need no asset loading;
    keep images for illustrated icons only.
    Source: https://devforum.roblox.com/t/gui-optimization-tips/3986563
11. **Set fonts through `FontFace`**: `Font.fromName("FredokaOne")` for headings/numbers and
    `Font.fromName("BuilderSans", Enum.FontWeight.Bold)` for body; both families exist in the
    Font enum (FredokaOne = 26, BuilderSansBold = 48) and Gotham now maps to Montserrat, so
    don't pick Gotham expecting Gotham.
    Source: https://create.roblox.com/docs/en-us/reference/engine/datatypes/Font.md ;
    https://create.roblox.com/docs/en-us/reference/engine/enums/Font.md
12. **Other chunky built-in display fonts exist (`LuckiestGuy`, `Bangers`, `Cartoon`)**; if
    Fredoka feels too soft for big title banners, LuckiestGuy is the obvious alternative to try.
    Source: Font enum page above.

### C. Scaling, safe areas and mobile

13. **Leave `ScreenGui.ScreenInsets` at `CoreUISafeInsets`** (the default when IgnoreGuiInset is
    false) so HUD clears the Roblox top bar and phone notches; only full-screen backdrops should
    use `DeviceSafeInsets`/`None`.
    Source: https://create.roblox.com/docs/en-us/reference/engine/classes/ScreenGui.md
14. **`GuiService.TopbarInset` gives the free space beside the Roblox top bar** and
    `GuiService:GetInsetArea(Enum.ScreenInsets.X)` returns each safe rect, so the top-centre run
    progress bar can be placed against real insets instead of a guessed offset.
    Source: https://create.roblox.com/docs/reference/engine/classes/GuiService
15. **`GuiService.ViewportDisplaySize` (full release) classifies the physical screen as Small /
    Medium / Large** (phone-tablet / laptop-monitor / TV) from device APIs, not pixels; use it
    to pick a size step on top of the viewport-based UIScale (phones get bigger text/buttons
    even when their pixel count matches a monitor). Listen with GetPropertyChangedSignal.
    Source: https://devforum.roblox.com/t/full-release-build-cross-platform-ui-with-the-viewportdisplaysize-api/3880384
16. **On phones the default thumbstick and jump button own the bottom-left and bottom-right
    corners**; place no HUD there and put frequent touch buttons near the jump button.
    Source: https://create.roblox.com/docs/ui/cross-platform-design
17. **A common, simple scaling recipe is one root UIScale = min(viewportW / designW,
    viewportH / designH)** recomputed on ViewportSize change, with layouts authored in offset at
    the design size; this is what lets fixed-pixel strokes and corners stay proportional.
    Source: https://devforum.roblox.com/t/how-do-i-make-my-ui-scale-correctly/3971659 (search
    summary; exact code not verified)
18. **44×44 px minimum touch target** is the Apple HIG figure; I could not find it on an official
    Roblox page (Roblox's adaptive-design guide gives no number), so treat 44 px *after* UIScale
    as our own rule. Unverified as a Roblox rule.
    Source: https://create.roblox.com/docs/en-us/production/publishing/adaptive-design.md

### D. Feel and motion

19. **Animate hover/press by tweening a `UIScale` child of the button (1 → 1.05 / 0.95), not the
    button's Size or TextSize**: TextSize has no sub-pixel steps so it judders, and Size tweens
    disturb layouts. Set the button's AnchorPoint to (0.5, 0.5) so it grows from the centre.
    Source: https://devforum.roblox.com/t/choppy-ui-tween/2170828 ;
    https://devforum.roblox.com/t/ui-size-animation/2395076 (search summary)
20. **Avoid `CanvasGroup` except for real clipping needs**; posters report a large memory hit,
    so don't use one just to fade a whole panel (fade the panel's children or pop with UIScale).
    Source: https://devforum.roblox.com/t/gui-optimization-tips/3986563
21. **Split HUD into several ScreenGuis by update rate** (cart bar + money counter that tick
    often vs. the static left rail and panels); posters report any change re-renders the whole
    ScreenGui. Also destroy finished tweens/connections when a panel closes.
    Source: same thread as 20.
22. **Plan motion in the wireframe** (arrows + delays like 0.3 s between staggered elements) so
    panel contents cascade in rather than appearing at once.
    Source: https://devforum.roblox.com/t/the-ultimate-ui-design-guide/1236916

### E. Icons and images

23. **Put the icon set on one sprite sheet and pick icons with `ImageRectOffset` /
    `ImageRectSize`**; one asset to upload and load, and every icon shares a grid.
    Source: https://devforum.roblox.com/t/ui-design-starter-guide/53461
24. **Make single-colour UI glyphs (close X, arrows, padlock, tick) pure white and tint them with
    `ImageColor3`**, so the same glyph is red on Close, grey on locked, green on owned; keep
    illustrated item icons full colour.
    Source: https://devforum.roblox.com/t/the-ultimate-ui-design-guide/1236916
25. **Top simulators (Pet Simulator 99, Pls Donate) use mostly ImageButtons with custom art**
    mixed with Frames; that is where their polish comes from. For us the code-built Frame
    approach (finding 10) carries the shapes and the generated icons carry the illustration.
    Source: https://devforum.roblox.com/t/unique-or-good-looking-ui/2914121

### F. Generating a consistent icon set with image AI

26. **Generate icons as sheets, 6–9 per image, on pure magenta `#FF00FF`**, items spaced apart,
    none touching each other or the edge, no ground shadow; one generation costs the same as one
    icon and items drawn in one pass match each other.
    Source: https://rangy.ai/blog/ai-game-assets
27. **Defringe after keying**: semi-transparent edge pixels keep a magenta cast (they measured
    ~0.8% of pixels, 2.5% on thin items); check every icon on a dark background and erode 1 px
    or subtract the key colour. Our own pixel-grid snap removal already does a version of this.
    Source: same as 26.
28. **Lock the style with reference images, not prompt words alone**: Google's current Gemini
    image models accept several object reference images per request, and (per the doc as
    fetched) some accept up to 3 dedicated *style* references; iterate in multi-turn edits.
    Pass the first approved icon sheet as the style reference for every later sheet.
    Source: https://ai.google.dev/gemini-api/docs/image-generation (model names and limits
    change often; recheck before relying on exact counts)
29. **Google's own icon example prompt has the right shape**: subject, "background is white",
    "colorful and tactile 3D style", "No text". Copy its structure, swap white for magenta.
    Source: same as 28.
30. **Consistency comes from a fixed checklist**: same stroke weight, corner radius, grid
    alignment, palette and level of detail on every icon; review in small batches against an
    approved reference sheet.
    Source: https://iconly.ai/blog/generate-matching-icon-set-ai/ (search summary);
    https://help.scenario.com/articles/4516993982-designing-icons-for-a-match-3-game

Proposed icon prompt (for `asset-artist`; built from 26–29 and the Style Bible template):

> A sheet of [N] separate game UI icons: [list]. Chunky voxel toy style built from small cube
> blocks with little round studs on top surfaces like a building-brick toy, bright saturated
> colours from this palette [hexes], thick dark navy #1E1A2E outline around each icon, same
> 3/4 front view and same size for every icon, soft even lighting. Arrange in a 3×3 grid with
> wide gaps; nothing touches another icon or the edge. Solid flat magenta #FF00FF background,
> no shadows, no ground, no text, no numbers. Match the style of the reference image exactly.

---

## Patterns from top games

| Game | What it does well | What we take |
|---|---|---|
| Search For The Needle (Garage Games) — almost certainly Rufus's hay reference | An "upgrade book" opened with **Tab**; 5 tools in order (Hand, Pitchfork, Dynamite, Vacuum, Hay Drone); each tool has exactly 3 named tracks (Hand: Hold / Grasp / Speed; Dynamite: Power / Speed / Lucky Blast); Cash resets per run, Gems persist. Sources: https://allthings.how/?p=171457 , https://bloxodes.com/wiki/search-for-the-needle | Tab hotkey for our Upgrade Book; three short one-word track names per tool; in-run money vs permanent currency kept visually distinct. Their bag-capacity pressure maps to our cart bar. |
| Needle In A Haystack (DomBlox) | Same one-pile-one-needle hook; tools bought with Cash in a barn, helper drone for Gems. Source: https://allthings.how/?p=171457 search summary | Confirms the genre: the shop is a physical place, the book is for upgrades. Matches our NPC Shop + Upgrade Book split. |
| Pet Simulator 99 / Pls Donate | Polished ImageButton art, icons instead of words, UI kept to screen edges. Source: https://devforum.roblox.com/t/unique-or-good-looking-ui/2914121 | Icon-first buttons with a short label; keep the centre of the screen for the mine. |
| Tower Defense Simulator | UIStroke with a UIGradient on it for styled outlines. Source: https://devforum.roblox.com/t/how-did-they-do-this-ui/3097666 | Optional: gradient on the outline for rare/glowing tiers only (crystal, lava, rainbow tools). |
| Grow a Garden | Shop stock and a restock countdown per tab (Seeds / Gear / Eggs). Source: https://addons.mozilla.org/addon/grow-a-garden/ (indirect) | Tabs along the top of a shop panel; not needed now. |
| Bee Swarm Simulator | Not verified this pass (wiki blocked). | — |

---

## Proposed rule changes (against `docs/UI_RULES.md`)

```diff
 ## Look
-- **Outline:** every button and panel has a thick dark outline (`UIStroke` 3–4 px, `#1E1A2E`).
+- **Outline:** every button and panel has a thick dark outline: `UIStroke` 3–4 px, `#1E1A2E`,
+  `StrokeSizingMode = FixedSize`, `BorderStrokePosition = Inner`, under the root UIScale.
+  Optional toy rim: a second UIStroke, Inner, 2 px, white at 0.6 transparency, higher ZIndex.
```
Reason: findings 1–4. Inner keeps the visible button equal to its hit area and stops grids
overlapping; multiple strokes are now released, so the plastic rim costs no extra Frames.

```diff
-- **Fonts:** headings and numbers in Fredoka One (`Enum.Font.FredokaOne`); body text in
-  Builder Sans Bold. All text gets a 2 px dark stroke so it reads over the bright world.
+- **Fonts:** set `FontFace`: `Font.fromName("FredokaOne")` for headings and numbers,
+  `Font.fromName("BuilderSans", Enum.FontWeight.Bold)` for body. All text gets a 2 px `#1E1A2E`
+  `UIStroke` with ApplyStrokeMode `Contextual`. Never use `TextStrokeColor3`.
```
Reason: findings 6, 7, 11. TextStroke is thin and clashes with UIGradient.

```diff
+- **Gradients:** `UIGradient` with `Rotation = 90`, lighter top, only between a palette colour
+  and its own lighter tint. Never on a text object.
```
Reason: finding 9; keeps "generic gradients" (a slop rule) from creeping back.

```diff
 ## Layout
-- **Corner:** the minimap.
+- **Top-left corner, below the Roblox top bar:** the minimap. Nothing in the bottom-left or
+  bottom-right corners (phone thumbstick and jump button live there).
```
Reason: finding 16. "Corner" is ambiguous and the bottom corners are reserved on phones.

```diff
 - **Upgrade Book:**
+  - opens with **Tab** on keyboard (as in Search For The Needle) and from the left rail
   - three upgrade tracks per tool, each with icon, name, level pips and a price button
+  - track names are one word (Power / Speed / Reach)
```
Reason: reference-game pattern table.

```diff
 ## Feel
-- Buttons grow to 1.05 on hover and shrink to 0.95 on press.
+- Buttons grow to 1.05 on hover and shrink to 0.95 on press, by tweening a `UIScale` child
+  (AnchorPoint 0.5, 0.5). Never tween Size, TextSize or a text UIStroke's Thickness.
+- No `CanvasGroup` unless something must be clipped.
```
Reason: findings 7, 19, 20.

```diff
 ## Mobile
-- Use `UIScale` driven by screen size. Never hard-code layouts for 1920×1080.
+- One root `UIScale` per ScreenGui = min(viewW / 1280, viewH / 720), recomputed on resize,
+  multiplied by a step from `GuiService.ViewportDisplaySize` (Small 1.15, Medium 1, Large 1.25;
+  starting values, tune in playtest). Never hard-code layouts for 1920×1080.
+- Leave `ScreenInsets = CoreUISafeInsets`.
 - Minimum touch target 44 px.
+  (measured after scaling; this is the Apple HIG number, Roblox publishes none)
```
Reason: findings 13, 15, 17, 18. The 1280×720 design size and the step multipliers are my
proposal, not from a source.

```diff
+## Performance
+- Separate ScreenGuis: `HUD_Live` (cart bar, money, run progress), `HUD_Static` (rail,
+  minimap frame), `Panels` (Upgrade Book, Shop). Fewer than 300 UIStrokes on screen.
+- Panels built from Frames; images only for icons, which come from one sprite sheet
+  (`ImageRectOffset` / `ImageRectSize`). Glyphs (X, padlock, arrows) are white and tinted
+  with `ImageColor3`.
```
Reason: findings 5, 10, 21, 23, 24.

```diff
 - **Icons:** real illustrated icons in one consistent style (generated as a set). A padlock
   plus "???" for anything locked.
+  Generated as 3×3 sheets on magenta #FF00FF with the first approved sheet passed as the style
+  reference, defringed, checked on a dark background. Prompt template in RESEARCH.md §F.
```
Reason: findings 26–30.

Nothing proposed to drop.

---

## Open questions for Rufus

1. Is the hay-game screenshot from **Search For The Needle** (Garage Games)? Its "upgrade book
   with Tab, three tracks per tool" matches exactly. If yes, we can study it in-game.
2. I couldn't find **Prehistoric Farm** by name in web search. Can you share the Roblox link so
   the left-rail pattern can be checked against the real game?
3. Heading font: keep **Fredoka One**, or try **Luckiest Guy** for big banner titles only?
4. Should the inner white "toy rim" stroke be standard on every button, or only on the main
   call-to-action buttons (price buttons, Close)?

---

## Not used (couldn't read contents)

YouTube results with no readable description or transcript: "How to Make Simulator UI"
(https://www.youtube.com/watch?v=a8RghxDRhPg), "How To Make ROBLOX SIMULATOR UI Tutorial"
(https://www.youtube.com/watch?v=fHNNzeaT4CI), "Creating the Shop GUI! Roblox Studio Simulator
Guide Episode 4" (https://www.youtube.com/watch?v=7_cmK0yO2-g), "Roblox Studio + Claude MCP
Setup Tutorial Auto Generate In Game GUI system" (https://www.youtube.com/watch?v=gF75DxFkfJo).
Worth Rufus watching the first two for visual reference; nothing from them is used above.
