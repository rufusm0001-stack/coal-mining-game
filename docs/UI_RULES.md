# UI Rules — chunky toy UI, no AI slop

Every screen in the game follows these. The `ui-critic` agent checks screenshots against this
file before UI work is called done. `docs/ui/RESEARCH.md` holds the research these rules come
from; when research changes a rule, update it here.

## What "AI slop" means here (never do these)

- Dark translucent rectangles with a thin gold border and small serif or typewriter text.
  That's the ChatGPT build; it's the opposite of what we want.
- Emoji or plain letters standing in for icons.
- Walls of text, lore paragraphs, tooltips longer than two short lines.
- Everything the same size and weight, no clear focal point.
- Generic gradients that don't come from the palette.
- Panels that cover the whole screen on a phone with no way to see the game.

## Look

- **Shapes:** rounded corners (12–16 px), chunky proportions.
- **Outline:** every button and panel has a thick dark outline (`UIStroke` 3–4 px,
  `#1E1A2E`).
- **Fill:** bright palette colours, two-tone (lighter top via `UIGradient`).
- **Toy depth:** a darker copy of the shape offset 3–4 px below, so it looks like a toy.
- **Fonts:** headings and numbers in Fredoka One (`Enum.Font.FredokaOne`); body text in
  Builder Sans Bold. All text gets a 2 px dark stroke so it reads over the bright world.
- **Icons:** real illustrated icons in one consistent style (generated as a set). A padlock
  plus "???" for anything locked.
- **Colour coding, always the same:**
  - money: yellow / gold
  - coal: charcoal
  - diamonds and shards: cyan
  - upgrades: green
  - locked: grey
  - close: red

## Layout (desktop and phone)

- **Left rail:** round icon buttons with a short label under each (Upgrades, Shop, Map,
  Settings), as in Prehistoric Farm.
- **Top centre:** run progress (how much of the mine has been searched, and whether the
  diamond has been found).
- **Top right:** money, then diamond shards.
- **Corner:** the minimap.
- **Bottom centre:** cart capacity bar (fills as you mine, turns red when full) above the
  hotbar.
- **Panels:**
  - one at a time, centred, with a title on a banner at the top and a red round X close
    button top-right
  - the game stays visible around them
- **Upgrade Book:**
  - an open book, one page per tool
  - three upgrade tracks per tool, each with icon, name, level pips and a price button
  - locked tools appear as padlocked "???" cards
  - "Your money" in the footer

## Feel

- Buttons grow to 1.05 on hover and shrink to 0.95 on press.
- Panels pop open with Back easing in about 0.2 s.
- Buying something:
  - the price button flashes green and coins fly from the money counter
  - a sound plays
- Not enough money: the button shakes and the price flashes red. No popup.
- Numbers count up when they change instead of jumping. Show commas below 10,000, then
  1.2K, 3.4M.

## Mobile

- Design for phones first.
- Minimum touch target 44 px.
- Use `UIScale` driven by screen size. Never hard-code layouts for 1920×1080.
- Test at a 375-wide viewport before calling any screen finished.
