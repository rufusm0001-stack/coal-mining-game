# Find The Diamond In The Coal — Project Instructions

Loaded automatically by Claude Code in this folder. Read before doing anything else:

1. `GAME_SPEC.md` — what the game is (v2, decided 2026-10-06).
2. `STATUS.md` — what changed recently and what's in progress. Newest entry first.
3. `TASKS.md` — who is working on what.

Place: "Find The Diamond In the Coal", placeId 105849041537760. Built directly in Roblox Studio
via the Studio MCP tools, on Team Create. No Rojo; game code lives only in Studio.

## Hard rules

- **Look:** colourful stud-voxel toy style. Every model, part and colour follows
  `docs/STYLE_BIBLE.md`. Never use realistic materials. Never write "LEGO" anywhere (trademark).
- **UI:** follows `docs/UI_RULES.md`. Run the `ui-critic` agent on a screen before calling it
  done. Research lives in `docs/ui/RESEARCH.md`.
- **Art spending:** goes through the `asset-artist` agent's rules. API keys live outside
  the repo and must never be committed or printed. Every spend is logged in `art/LEDGER.md`.
- **Archive:** ChatGPT/Codex's earlier build is in `ServerStorage.Archive_ChatGPT_20261006`.
  It's reference only: don't restore or extend it unless Rufus asks.
- **Scope:** don't build the "later, not now" features in GAME_SPEC.md (mobs, swords,
  crafting, harder layers) until asked.

## Agents (`.claude/agents/`)

- `ui-researcher`: researches Roblox UI design (YouTube tutorials, DevForum, top games) and
  writes `docs/ui/RESEARCH.md`.
- `ui-critic`: reviews a screen against UI_RULES.md and returns a ranked punch list.
- `asset-artist`: runs the Gemini → Meshy → Roblox model pipeline within budget.

## Studio gotchas

- Stop Play before editing. Edits made during Play are lost.
- Animations made as KeyframeSequences only play in Studio until they're published.
- Freezing a second copy of an animation track on a marker frame re-fires the marker
  handlers on the real track. Gate marker handlers with a state flag.
- Scripts edited under Team Create collaborative editing may sit as drafts until committed.

## Workflow

- Before editing a shared Instance (RemoteEvents, `ReplicatedStorage.Modules.Config`),
  log it in STATUS.md.
- At the end of a session:
  - add a STATUS.md entry with the exact Instance paths changed, the shared interfaces and
    the known gaps
  - commit and push
