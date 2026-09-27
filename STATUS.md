# Status Log — Coal Mining Game (MCP + Team Create)

Shared logbook between the two Claude sessions, each driving its own Roblox Studio
via MCP against the same Team Create place. Unlike a git workflow, the place itself
updates LIVE the moment either of you edits it — this file's job is purely to tell
the other person's Claude *what changed and why* and *what's about to change*, since
there's no diff/pull to review before it lands. See CLAUDE.md for game design rules
and TASKS.md for the ownership split.

## How to use this file

**At the start of a session, tell your Claude:**
> "Read STATUS.md before touching anything, so you know what my brother's Claude
> changed since I was last online, and check the relevant part of the Explorer tree
> with search_game_tree/inspect_instance to confirm it matches what's logged."

**Before a big edit, tell your Claude:**
> "Post a STATUS.md entry (or just tell me) saying what Instance paths you're about
> to change, before running multi_edit/execute_luau, in case my brother is online
> right now."

**At the end of a session, tell your Claude:**
> "Add an entry to STATUS.md: what you changed, which Instance paths, any new
> RemoteEvents/shared functions/Config values, and anything that could break the
> other side's scripts."

Keep entries short. Newest entry at the top.

---

## Entry format (copy this template)

```
### [YYYY-MM-DD HH:MM] — Person A/B — short title
Touched (Instance paths): <e.g. ServerScriptService.Mining.OreNode>
Did:
- <what changed, plain English>
Added/changed shared interfaces:
- <new RemoteEvent name, new shared function signature, new Config key, etc —
  anything the OTHER side's code might call or depend on>
Heads up:
- <anything that could break the other person's stuff right now, e.g.
  "renamed Config.OreValues to Config.OreWorth — your shop UI reads the old name">
```

---

## Log

### [2026-09-27 00:00] — Setup — initial structure
Touched (Instance paths): none yet — docs only
Did:
- Set up CLAUDE.md (auto-loaded game design rules + hard constraints + shared
  RemoteEvent/ModuleScript names), GAME_SPEC.md (original brief), TASKS.md
  (ownership split by Instance path), STATUS.md (this file).
Added/changed shared interfaces:
- Defined in CLAUDE.md: RemoteEvents MineNodeEvent, SellCoalEvent, BuyUpgradeEvent,
  UpdateHUDEvent; ModuleScripts PickaxeData, UpgradeData, AutomationData.
Heads up:
- Team Create must be enabled on the place before both of you can work "at the
  same time" — otherwise you'd be editing two local copies that can't merge.
- This whole folder needs to exist on BOTH machines for CLAUDE.md to auto-load for
  both of you — see the note below on sharing it.
