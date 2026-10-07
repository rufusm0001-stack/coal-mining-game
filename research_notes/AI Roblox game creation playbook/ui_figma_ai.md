# Roblox Game UI with AI and Figma: Making UI That Doesn't Look Like Generic "AI Slop"

Research date: 2026-10-07. Information dated where the source gave a date. Primary sources preferred: create.roblox.com docs, DevForum posts. Many search results for "Roblox image limits" and "Pet Sim 99 UI" came from SEO spam domains (compagnie-des-sens.fr, cannacompanionusa.com, etc.). They were thrown out and are not cited.

---

## 1. What do top Roblox games' UIs have in common (PS99, Grow a Garden, Bee Swarm, Blox Fruits, Find the Needle, Prehistoric Farm)?

### Takeaway
Few sources give measured specs for these games' UI. The ones that exist say top simulator UIs are mostly image-based: custom-drawn ImageButtons and frames, cartoon fonts, thick outlines, and bright colour-coded buttons. Simple layouts are favoured because the audience is young. Grow a Garden-style UI is now its own genre, and third-party UI kits sell the standard screen list for it.

### Cited Findings
- Pet Simulator 99's UI is described as mostly image-based. It uses custom images for buttons and menus, with frames and scrolling frames holding ImageButtons. — [DevForum: Unique or good looking ui](https://devforum.roblox.com/t/unique-or-good-looking-ui/2914121)
- Some designers deliberately go against the loud, screen-covering pet-sim UI and make it minimal and airy so players aren't overwhelmed. — [DevForum: Unique or good looking ui](https://devforum.roblox.com/t/unique-or-good-looking-ui/2914121)
- A commercial "Grow a Garden UI Pack" (editable PSD, aimed at "Grow a Garden and Brainrot games") lists the standard set of frames for the genre: Seed Shop, Confirmation, Codes, Limited Shop, Pet/Cosmetic Shop, HUD, Inventory, Hotbar, Notification, Quests, Settings. This works as a checklist of the screens players expect. — [itch.io: GAG UI Pack by adrianart](https://adrianart.itch.io/gag-ui-pack)
- Cartoony shop UI kits for Roblox sell an "eye-catching cartoon aesthetic paired with smooth animations" for simulators, roleplay games and tycoons. — [itch.io: Free Roblox Store Interface (kwstudioorg)](https://kwstudioorg.itch.io/free-roblox-store-interface-custom-cartoon-ui-system-scripted); [itch.io devlog: custom cartoony store UI](https://itch.io/devlog/1084844/custom-cartoony-store-ui-fully-scripted-shop-system-for-roblox.amp)
- Fredoka One is an "ultra-bold and round sans serif" that reads as cheerful and bouncy. It is the go-to cartoon UI font, and Roblox ships it as Enum.Font.FredokaOne (value 26). — [RightFont: Fredoka](https://rightfontapp.com/family/fredoka); [Roblox Font enum](https://create.roblox.com/docs/reference/engine/enums/Font)
- Other built-in display fonts used for this style: LuckiestGuy (32), GothamBlack (20), Bangers (22), Cartoon (9), plus BuilderSans (46), BuilderSansBold (48) and BuilderSansExtraBold (49). Montserrat is not a built-in enum value. — [Roblox Font enum](https://create.roblox.com/docs/reference/engine/enums/Font)
- DevForum advice for simulators: keep the UI simple so newer and younger players understand what's happening. Make it mobile- and Xbox-friendly, and scale it to look right on every device. — [DevForum: UI Design Guide (Zien, 2024-05-19)](https://devforum.roblox.com/t/ui-design-guide/2975811); [DevForum: Suggestions topic: UI designing](https://devforum.roblox.com/t/suggestions-topic-ui-designing/963950)
- Colour advice from the same guide: a neutral (grey) base with vibrant accent colours on the interactive elements (buttons), strokes on buttons for definition, a single font family, and currency counters (coins/gems) always visible. — [DevForum: UI Design Guide (2024-05-19)](https://devforum.roblox.com/t/ui-design-guide/2975811)
- A UI designer portfolio thread shows the 2025-era freelance standard for simulator-style UI. It is a good source of reference images. — [DevForum: metatablesnow UI/UX portfolio](https://devforum.roblox.com/t/open-metatablesnow-uiux-design-portfolio-2-years-of-experience/3656083)

### Inferences
- These conventions come from what kits and practitioners consistently show, not from a measured study:
  - Currency counters sit top-left or top-centre.
  - Side "menu rail" buttons (Shop / Pets / Inventory / Rebirth / Codes) run down the left edge.
  - The hotbar sits bottom-centre.
  - Modal shops open centre-screen with an X close button top-right, often red.
  - Colour coding: green = buy/confirm, red = close/cancel, gold/yellow = premium/Robux, blue/purple = rarity tiers.
  - Text is a heavy rounded font with a thick dark stroke.
- Treat this as a working spec. Verify it against screenshots of the actual games before copying it.
- Grow a Garden and "brainrot" games have pushed the genre toward chunky, bright, cartoon 9-slice frames with drop shadows. That style is now the expected norm, so a flat, sleek "web-app" UI will read as off-genre for a farming or collecting sim.
- For the coal mining game ("Find The Diamond In The Coal"), give the frames a themed material (9-sliced) so they stand apart from purple-gradient defaults. The project's CLAUDE.md requires a colourful stud-voxel toy style (docs/STYLE_BIBLE.md) and docs/UI_RULES.md, so frames should look like chunky studded toy bricks or panels, not realistic wood or stone. Check this against those files and the existing docs/ui/RESEARCH.md.

### Gaps
- No public, sourced pixel breakdown exists of PS99, Bee Swarm, Blox Fruits, Find the Needle or Prehistoric Farm UI: button sizes, stroke thicknesses, exact fonts. Getting real values would need screenshots of each game captured at a known resolution and then measured.
- Nothing found that studies Find the Needle / Search for the Needle or Prehistoric Farm UI specifically.
- No sourced data on how much each layout choice moves conversion.

---

## 2. Roblox UI technical best practices (2025-2026)

### Takeaway
Use Scale sizing plus UIAspectRatioConstraint, or a UIScale driven by the viewport. Keep the ScreenGui on CoreUISafeInsets so nothing sits under the top bar or notch. Prefer UICorner, UIGradient and UIStroke over images where you can. Use 9-slice images for themed frames.

UIStroke got big upgrades in engine versions 684-685 (around mid-2025), behind the "Improved UIStrokes" beta:
- StrokeSizingMode: thickness in fixed pixels or scaled with the parent
- BorderStrokePosition: Inner / Center / Outer
- BorderOffset
- ZIndex: stack several strokes on one object

### Cited Findings

**UIStroke**
- Main properties: Thickness, Color, Transparency, Enabled, ApplyStrokeMode (on text objects, Border puts the stroke on the box instead of the glyphs) and LineJoinMode (Round default, Bevel, Miter). UIStroke can be combined with UIGradient for gradient outlines. — [UIStroke API](https://create.roblox.com/docs/en-us/reference/engine/classes/UIStroke.md)
- StrokeSizingMode values:
  - FixedSize: thickness in pixels, the default.
  - ScaledSize: thickness relative to the parent's smaller dimension, or relative to font size when the stroke is on text.
  - This fixes the old problem where a 3px stroke looked fat on phones and thin on 4K screens.
  — [StrokeSizingMode enum](https://create.roblox.com/docs/en-us/reference/engine/enums/StrokeSizingMode.md); [robloxapi StrokeSizingMode](https://robloxapi.github.io/ref/enum/StrokeSizingMode.html)
- Other new properties:
  - BorderStrokePosition: Center / Inner / Outer.
  - BorderOffset: a UDim offset relative to the parent's minimum width or height.
  - ZIndex: order among sibling UIStrokes, so you can stack strokes (e.g. a dark outer stroke plus a light inner stroke).
  - These were added in engine versions 684-685. Some need the "Improved UIStrokes beta" turned on.
  — [UIStroke API](https://create.roblox.com/docs/en-us/reference/engine/classes/UIStroke.md); [robloxapi UIStroke](https://robloxapi.github.io/ref-temp/class/UIStroke.html)
- Before ScaledSize existed, developers had to scale strokes by script. That was a common pain point (see "How do I automatically scale UIStrokes"). — [DevForum](https://devforum.roblox.com/t/how-do-i-automatically-scale-uistrokes/4061225)

**Safe areas**
- ScreenGui.ScreenInsets options:
  - CoreUISafeInsets (default): keeps descendants clear of the top bar buttons and screen cutouts. Recommended when the ScreenGui contains interactive elements.
  - DeviceSafeInsets: avoids notches only, not core UI.
  - TopbarSafeInsets
  - None
  — [ScreenGui API](https://create.roblox.com/docs/en-us/reference/engine/classes/ScreenGui.md); [On-screen UI containers](https://create.roblox.com/docs/en-us/ui/on-screen-containers)
- Related ScreenGui properties:
  - ClipToDeviceSafeArea defaults to true.
  - SafeAreaCompatibility defaults to FullscreenExtension. On notched devices it automatically adjusts "fullscreen" descendants, meaning those that cover the safe area in both directions.
  — [ScreenGui API](https://create.roblox.com/docs/en-us/reference/engine/classes/ScreenGui.md); [Notched Screen Support - FULL RELEASE](https://devforum.roblox.com/t/notched-screen-support-full-release/2074324)
- Touch devices show a virtual thumbstick and jump button by default. GuiService.TouchControlsEnabled can disable them. The docs give no pixel dimensions for the thumb zones. — [On-screen UI containers](https://create.roblox.com/docs/en-us/ui/on-screen-containers)

**Sizing and text**
- UIScale multiplies AbsoluteSize, and that includes children and appearance modifiers.
- UIAspectRatioConstraint fixes the shape (1 = square). It overrides layouts.
- UISizeConstraint sets min/max size in pixels. It overrides UIListLayout.
- AutomaticSize X / Y / XY grows the parent to fit its children. On a ScrollingFrame, use AutomaticCanvasSize instead.
— [Size modifiers and constraints](https://create.roblox.com/docs/en-us/ui/size-modifiers)
- UITextSizeConstraint works with TextScaled. The official guidance: "Do not use MinTextSize property values lower than 9." — [Size modifiers](https://create.roblox.com/docs/en-us/ui/size-modifiers); [UITextSizeConstraint API](https://create.roblox.com/docs/en-us/reference/engine/classes/UITextSizeConstraint.md)
- TextScaled pitfalls:
  - UITextSizeConstraint overrides RichText font-size markup.
  - Developers report TextScaled gives inconsistent sizes between neighbouring labels.
  - Roblox's newer "Preferred Text Size" accessibility setting changes non-TextScaled text. A DevForum report says RichText labels can't opt out of it unless TextScaled is on.
  — [DevForum: I don't like TextScaled](https://devforum.roblox.com/t/i-dont-like-textscaled/3429884); [DevForum: Preferred text size setting + RichText](https://devforum.roblox.com/t/new-preferred-text-size-setting-makes-it-impossible-to-have-text-objects-using-richtext-without-textscaled-enabled-that-arent-affected-by-the-setting/3914959)

**9-slice and performance**
- 9-slice: set ScaleType = Slice and define SliceCenter. Corners don't scale, edges stretch along one axis, and the centre stretches both ways. This is how themed frames resize without distortion. — [UI 9-slice design](https://create.roblox.com/docs/en-us/ui/9-slice)
- UICorner and UIGradient need no image assets, which is better for performance than image-based rounding. But Sliced (and possibly Tiled) ImageLabels do not work with UICorner and produce artifacts. — [DevForum: 9-slicing use cases](https://devforum.roblox.com/t/9-slicing-use-cases/667672); [DevForum: GUI optimization tips](https://devforum.roblox.com/t/gui-optimization-tips/3986563)

### Inferences
Practitioner heuristics, not official numbers:
- **Base resolution:** design at 1920x1080 (or 1280x720) in Figma. Build with Scale sizes plus UIAspectRatioConstraint on every button and icon, and add a viewport-driven UIScale on mobile.
- **Text:**
  - Body text at about 18-24px equivalent on 1080p.
  - Never let it drop below 9 at runtime, per the official minimum.
  - Prefer TextScaled with a UITextSizeConstraint (MaxTextSize) on button labels, so neighbouring buttons don't end up with different sizes.
- **Strokes:**
  - Use the new ScaledSize mode so outlines stay proportional.
  - Stack two strokes via ZIndex (dark outer, coloured inner) for the "sticker" look common in top simulators. This replaces the old trick of duplicating frames.
- **Mobile layout:**
  - Keep interactive HUD buttons out of the bottom-right (jump) and bottom-left (thumbstick) thumb zones.
  - Keep the ScreenGui on CoreUISafeInsets.
  - Put rail buttons mid-left or mid-right, not in the corners.
- **Animation:**
  - Use TweenService on a UIScale rather than on Size/Position for hover and press "bounce" effects (e.g. press 0.9, release overshoot to 1.05 with a Back easing, then back to 1). That avoids layout reflow.
  - The specific values are common practice. No official source was found.

### Gaps
- No official documentation found on CanvasGroup memory cost, tween performance limits, or SliceScale best values. The fetched docs didn't cover them.
- No official pixel sizes for the mobile jump button or thumbstick, and no top-bar inset height.
- Builder Sans is in the Font enum, but I found no official statement saying it is "the recommended UI font". Not confirmed.

---

## 3. Figma → Roblox workflows (plugins, MCP, AI agents)

### Takeaway
Since mid-2026 there are two active Figma→Roblox importers on the DevForum, RoImport (free) and UILint v2 (freemium). Both use layer-name tags such as `_Button`, `_Scroll` and `_Image` to rebuild real Roblox GUI hierarchies, export images, and (for RoImport) auto-upload them through an Open Cloud API key.

Figma's official MCP server lets AI agents read design context and screenshots and also write to the canvas: frames, components, variables, auto layout. A practical agent pipeline is:
1. The agent designs or edits in Figma via MCP.
2. A human or the importer plugin brings the design into Studio.
3. The agent wires the behaviour with Luau through the Studio MCP.

### Cited Findings
- **RoImport** (DevForum, 2026-07-11):
  - Free Figma→Roblox plugin. Supports auto layout export, drop shadows, strokes, gradients (radial/angular/diamond), masks, dashed strokes, layer blur, RichText, UIShadow, BillboardGui/SurfaceGui, 9-slice customisation, CanvasGroups, ViewportFrames, and reimporting after design changes.
  - Uses name tags (`_Image`, `_Button`, `_Scroll`, …) and image-size multipliers (`_2x`, `_3x`).
  - Auto-upload needs a Creator Hub API key and a locally run, open-source "bridge" app. It dedupes images already uploaded.
  - Tutorials are incomplete.
  — [DevForum: (Free) Figma to roblox plugin | roimport](https://devforum.roblox.com/t/free-figma-to-roblox-plugin-roimport/4731967)
- **UILint v2** (DevForum, 2026-07-30, by Kailorr1):
  - Lints the UI in Figma, cleans up layer names, exports the full hierarchy plus changed images, and rebuilds structured Roblox UI (frames, text, buttons, layouts, constraints, ScrollingFrames with custom scrollbars) in Studio.
  - Free tier: local linting and manual export.
  - Paid tier: Smart Sync, Deep Analyze, Smart Scale (resolution-independent), Component Extractor, Live Sync. Pricing not listed.
  — [DevForum: UILint v2](https://devforum.roblox.com/t/plugin-uilint-v2-import-figma-ui-into-roblox-studio/4765869)
- An older **Figma Importer Assistant** plugin also exists and claims to keep designs consistent across resolutions. — [DevForum: Figma Importer Assistant](https://devforum.roblox.com/t/2961561)
- The DevForum "figma" tag collects more Figma-to-Roblox threads. — [DevForum tag: figma](https://devforum.roblox.com/tag/figma)
- **Figma MCP server (official):**
  - Remote server recommended; no desktop app needed.
  - Agents can write to the canvas (frames, components, variables, auto layout), generate code from selected frames, pull design context (variables, components, layout), take screenshots, and use Code Connect.
  - Only clients listed in Figma's MCP Catalog can connect. Plan/seat limits and rate limits weren't on the intro page.
  — [Figma MCP server docs](https://developers.figma.com/docs/figma-mcp-server/)
- A DevForum guide recommends Figma (free) for wireframes and frameworks before building in Studio. Its process: sketch, then framework (~20 minutes), then implement. — [DevForum: UI Design Guide (2024-05-19)](https://devforum.roblox.com/t/ui-design-guide/2975811)

### Inferences
- **What's set up in this user's environment** (seen in the session's tool list, not a web source):
  - A Figma MCP connector with `use_figma`, `get_design_context`, `get_screenshot`, `get_variable_defs`, `download_assets`, `upload_assets` and `generate_image`.
  - A Roblox Studio MCP with `upload_image`, `store_image`, `generate_texture`, `execute_luau` and `screen_capture`.
  - So an all-agent loop is technically possible:
    1. Build the design system (colour variables, a type scale, a button component with states) in Figma via `use_figma`.
    2. Export the frame art with `download_assets`.
    3. Upload it with Studio MCP `upload_image`.
    4. Write the Luau that builds the GUI from the design context JSON.
    5. Check the result with `screen_capture` against the Figma screenshot.
- **Hand-written Luau vs importers:**
  - Code-built UI (Luau writing Frames, UICorner, UIStroke, UIGradient) is usually more maintainable for agents than a plugin import: it's diffable, re-runnable and needs no image assets.
  - Use images only for themed frames (9-slice), icons and illustrations.
  - Importers are best when a human designer owns the Figma file.
- **Naming:** follow RoImport/UILint-style naming (`ShopFrame`, `BuyButton_Button`, `ItemList_Scroll`) in Figma even when building by code. That keeps the option to switch to a plugin import later.

### Gaps
- No independent reviews of how well RoImport or UILint actually reproduce designs.
- Couldn't confirm Figma MCP seat requirements or rate limits for 2026.
- No sprite-sheet (ImageRectOffset/ImageRectSize) export support was confirmed for either plugin.

---

## 4. AI-generated UI art (icons, frames, cleanup, upload limits, moderation)

### Takeaway
Consistent AI icon sets come from:
- generating many icons in one image, or from a fixed style reference,
- a written spec covering stroke, grid, corners and lighting,
- then a manual cleanup pass (transparent background, trimmed, uniform padding).

Roblox images are effectively capped at 1024x1024, and anything larger is downscaled. Every upload passes automated moderation, which produces false positives, so plan for some rejections and keep source files.

### Cited Findings
- Generating a whole icon set as one image keeps the style consistent by construction. Cut individual PNGs from the sheet afterwards. Spec the grid, stroke weight, corner radius and fill/outline rules, and default to a transparent background. — [Dreamina: AI image generator for icon sets](https://dreamina.capcut.com/resource/ai-image-generator-for-icon-sets)
- Reported workflow: AI gets 80-90% of an icon set done, then a manual polish/export pass makes it production-consistent. Use AI for concepting, then finish by hand. — [Dreamina](https://dreamina.capcut.com/resource/ai-image-generator-for-icon-sets); [Iconly: complete guide to AI icon generation](https://iconly.ai/blog/complete-guide-ai-icon-generation/) (vendor sources, likely biased toward their tools)
- **Size limit:** images up to 1024x1024 upload without downscaling. Larger ones are shrunk to 1024x1024 with a warning. — [DevForum: Uploading 4K images](https://devforum.roblox.com/t/uploading-4k-images/30343); [DevForum: Developer Product image resizing](https://devforum.roblox.com/t/developer-product-image-resizing/489864)
- **File size:** sources disagree (about 1MB for decals vs 20-30MB via the API), and the cited pages are secondary. Treat as unverified. — [noping.com blog](https://noping.com/blog/how-to-upload-multiple-decals-at-once-in-roblox)
- **Bulk upload:** possible through the Open Cloud assets API (wrapped by e.g. rblx-open-cloud for Python). Rate limits apply but the found docs don't give the numbers. — [rblx-open-cloud docs](https://rblx-open-cloud.readthedocs.io/en/latest/creator.html)
- **Moderation:** every uploaded asset is pre-screened automatically, and the system is known for inconsistency and false positives. — [noping.com blog](https://noping.com/blog/how-to-upload-multiple-decals-at-once-in-roblox) (secondary source)
- **No-image route:** UICorner and UIGradient give rounded and shaded looks without loading image assets, and perform better. — [DevForum: 9-slicing use cases](https://devforum.roblox.com/t/9-slicing-use-cases/667672)

### Inferences
- **Recommended pipeline** (practice-based, not sourced):
  1. Write a one-paragraph style bible. Example: "chunky cartoon, 3/4 top-down view, light from top-left, 6px dark-brown outline, two-tone cel shading, saturated but not neon, no text in image".
  2. Generate 3x3 or 4x4 grids per batch on a flat chroma background (pure magenta or green), not "transparent". Image models often fake transparency with a checkerboard.
  3. Remove the background with a chroma key plus an alpha threshold (alpha below ~10% to 0, above ~90% to 255) to kill halos.
  4. Trim, then re-pad each icon to a square canvas with equal margins (e.g. 512x512 with the icon filling ~85%).
  5. Optionally pack the icons into a 1024x1024 sprite sheet and use ImageRectOffset/ImageRectSize. That's one upload and one moderation pass, and fewer texture loads.
- **This user's existing approach:** a "pixel-grid snap background removal" pipeline and notes on which model to use when (art-pipeline memory). Reuse that instead of starting again.
- **Never bake text into AI images.** Localisation, sharpness and moderation (text in images gets flagged more) all favour live TextLabels laid over plain art.
- **Frames and buttons:** generate one high-quality frame per material (wood, stone, metal), then 9-slice it in Studio. Don't generate each panel size separately. Generated per-size frames are where inconsistency shows most.

### Gaps
- No primary Roblox doc found giving the 2026 image file-size limit or Open Cloud asset-upload rate limits. Check create.roblox.com/docs/cloud before relying on numbers.
- No head-to-head benchmark found of which image model is best for consistent game icons in 2026.

---

## 5. Common mistakes that make UI look amateur or "AI-made", and a review checklist

### Takeaway
"AI slop" is the statistical-average look: Inter or Roboto, purple-to-blue gradients, rounded cards, centred layouts, no committed aesthetic. On Roblox the equivalents are default fonts, mixed font families, uneven strokes, flat grey panels with no theme, and AI icons that don't match each other.

The fix is to:
- commit to one named aesthetic and a real reference,
- replace adjectives with hard constraints,
- do a subtraction pass against a checklist,
- iterate from screenshots.

### Cited Findings
- AI slop is defined as converging on the same Inter font, purple-to-blue gradient and rounded-card layout, because the model returns the average of its training data. — [925studios: AI slop web design guide (2026)](https://www.925studios.co/blog/ai-slop-web-design-guide); [prg.sh: Why your AI keeps building the same purple gradient website](https://scour.ing/@emschwartz/p/https://prg.sh/ramblings/Why-Your-AI-Keeps-Building-the-Same-Purple-Gradient-Website)
- Named offenders: overused fonts (Inter, Roboto, Arial, Open Sans), clichéd purple/blue glow accents, predictable layouts. — [Impeccable: anti-patterns](https://www.mintlify.com/pbakaus/impeccable/concepts/anti-patterns); [Medium: Anti AI-Slop UI design skill](https://medium.com/@porter.nicholas/anthropic-skills-marketplace-the-anti-ai-slop-ui-design-skill-a572d0cfef4f)
- "Slop test": if you said "AI made this" and people believed you immediately, it's a problem. — [Impeccable: anti-patterns](https://www.mintlify.com/pbakaus/impeccable/concepts/anti-patterns)
- Six-step fix:
  1. Lead with a real reference.
  2. Commit to one named aesthetic.
  3. Replace adjectives with constraints.
  4. Generate several distinct directions.
  5. Do a subtraction pass against a slop checklist.
  6. Iterate from screenshots.
  — [Superdesign: how to make AI UI look less generic](https://www.superdesign.dev/blog/how-to-make-ai-ui-look-less-generic)
- Roblox-specific advice:
  - Use one font family across the whole UI.
  - Make sure text is readable against its background.
  - Don't let colour overwhelm.
  - Use strokes on buttons.
  - Take inspiration from references but don't copy them directly.
  — [DevForum: UI Design Guide (2024-05-19)](https://devforum.roblox.com/t/ui-design-guide/2975811)
- DevForum critique threads repeatedly flag inconsistency and clutter as what makes a UI look amateur. — [DevForum: Constructive feedback on gui](https://devforum.roblox.com/t/constructive-feedback-on-gui/2594203); [DevForum: Feedback and suggestions to improve UI](https://devforum.roblox.com/t/feedback-and-suggestions-to-improve-ui/2297137)

### Inferences
Review checklist, synthesised from the sources above plus practice. Use as a pass/fail list before shipping any screen:
1. **One font family**, with at most 2 weights (e.g. FredokaOne for headings/numbers plus BuilderSansBold for small body text). No Arial, SourceSans or Legacy defaults left anywhere.
2. **Every text label has a contrasting stroke or shadow**, and stroke thickness is consistent: same StrokeSizingMode, with the same thickness for every element of the same size class.
3. **Colour roles are fixed and documented:** confirm = green, cancel/close = red, premium = gold, plus one theme colour taken from the game world (coal/ore/lantern palette for the mining game). No purple-blue gradient unless it's deliberate.
4. **Same corner radius per size class.** UICorner never mixed with sliced images.
5. **Icons share one light direction, outline colour/weight and perspective.** No baked-in text, no checkerboard halos, equal padding.
6. **Every button reacts in under 100 ms** with a press scale, a hover state on PC, and a sound.
7. **Mobile pass:**
   - Test at 375x812 and on a small Android landscape screen.
   - Nothing under the top bar, thumbstick or jump button.
   - Tap targets aren't tiny.
   - Text never below size 9.
8. **Popups:** never more than one modal at a time, always a visible close X, a dimmed backdrop, and they open and close with a short tween.
9. **Hierarchy:** the most important number (currency) is the biggest, and secondary info is visibly smaller and lighter.
10. **Theme check:** screenshot the screen next to a top game in the same genre. If it looks like a web dashboard, it fails.
11. **Slop test:** would a player guess "AI made this"? If yes, redo the art direction, not the details.

### Gaps
- No source found that systematically lists "AI-made Roblox UI" tells. The checklist adapts general web/app slop findings plus DevForum feedback threads.

---

## 6. UI as a monetization surface (shop layout and conversion, within Roblox policy)

### Takeaway
Shops and gamepass/dev-product panels are the main monetization surface. Roblox policy has hard rules on paid random items (eggs, crates, gacha bought with Robux or Robux-bought currency):
- Odds must be shown as percentages that sum to exactly 100%.
- An "Info"/"Details" label (not just an icon) is needed when the odds don't fit on screen.
- Restricted users (via PolicyService) must be given a non-paid or non-random path.

### Cited Findings
- **Odds:**
  - Paid random items bought with Robux, or with in-game currency purchasable with Robux, must show all possible outcomes and their numerical odds as probability percentages summing to exactly 100%.
  - If there are too many outcomes to show, a pop-up opened by an "Info"/"Details" control visible before purchase is allowed. A standalone symbol without a descriptive word is not enough.
  — [Paid random items policy](https://create.roblox.com/docs/en-us/production/monetization/paid-random-items)
- **PolicyService:**
  - PolicyService:GetPolicyInfoForPlayerAsync() returns ArePaidRandomItemsRestricted and IsPaidItemTradingAllowed.
  - When ArePaidRandomItemsRestricted is true, the player must not be able to interact with paid random generators.
  - Allowed treatments include an unpaid, earnable path, or outcomes in a pre-determined order disclosed before purchase.
  — [Paid random items policy](https://create.roblox.com/docs/en-us/production/monetization/paid-random-items)
- **Genre conventions:** the Grow a Garden-style kit structure treats Seed Shop, Limited Shop, Pet/Cosmetic Shop, Codes and Confirmation dialogs as separate standard frames. — [itch.io GAG UI Pack](https://adrianart.itch.io/gag-ui-pack)

### Inferences
- **Shop layout patterns** (common practice; conversion effect not sourced):
  - A top "featured/best value" card bigger than the others.
  - Gamepasses shown with a one-line benefit ("2x Coal"), not just a name.
  - Prices always on a gold Robux button.
  - A restock timer for rotating shops (Grow a Garden style).
  - A confirmation step for in-game-currency spends.
  - Dev products as quick-buy buttons near the place they're needed. Example: an "out of energy" popup offering a refill.
- **Avoid:**
  - Fake countdowns that reset.
  - Pre-ticked purchases.
  - Close buttons hidden or delayed on purchase prompts.
  - Odds hidden behind an icon-only "i".
  - "Buy" buttons that look identical to "Close".
- Several of these cross into the explicit policy above. All of them hurt trust with the young audience.
- **For egg/crate-style mechanics in the coal mining game** (e.g. ore crates or pickaxe rolls):
  - Build the odds table into the purchase panel from day one.
  - Gate the paid roll button on `ArePaidRandomItemsRestricted`, with an earnable alternative.

### Gaps
- No sourced conversion-rate data on Roblox shop layouts found.
- I did not fetch Roblox's general monetization or advertising standards beyond the paid random items page. Other dark-pattern rules (e.g. on misleading purchase prompts) were not verified in this pass.
