# Art spend ledger

Budget set by Rufus on 2026-10-06: about $10 Meshy and $5 Gemini. Meshy balance on
2026-10-06 was 3,840 credits. Gemini's prepaid credit is empty (HTTP 402), so reference images
run on OpenAI until it's topped up.

## Verdicts

- `refs/style_*.png` (first test, gpt-image-1-mini low): the pickaxe read as a hammer. Superseded.
- `refs/pickaxe_starter`, `coal_node`, `minecart`, `great_furnace` (gpt-image-2 medium):
  real brick-built look with studs everywhere. Sent to Meshy.

## Spend (newest rows appended at the bottom by the scripts)

| Date | Provider | What | Cost |
|---|---|---|---|
| 2026-10-06 | Gemini | 4 style-test images, all failed with HTTP 402 | $0 |
| 2026-10-06 | OpenAI gpt-image-1-mini low | style test: 3 images (NPC blocked by moderation) | ~$0.02 |
| 2026-10-06 | OpenAI gpt-image-2 medium | 9 reference images for Meshy | ~$0.40 (estimate) |
| 2026-10-06 | Meshy image-to-3D | 9 models: pickaxe_starter, coal_node, minecart, great_furnace, tree_oak, tree_pine, bush, rock_mossy, flower_patch (3,840 -> 3,570) | 270 credits |
| 2026-10-07 | Meshy image-to-3D (high detail) | 12 models v2: furnace_v2, collect_pad, town_fountain, pickaxe_shop, robot_workshop, minecart, pickaxe_starter, coal_node, tree_oak, tree_pine, bush, rock_mossy (3,570 -> 3,210) | 360 credits |
